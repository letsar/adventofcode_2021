import 'common.dart';

void main(List<String> arguments) {
  Day15().solve();
}

class Day15 extends AdventOfCodeDay<_Input> {
  const Day15([String? inputFileName]) : super(15, inputFileName);

  @override
  _Input parseInput(Input input) {
    final parts = input.toStringList();
    final size = parts.length;
    final riskLevels = parts
        .expand((x) => x.split('').map((e) => int.parse(e)).toList())
        .toList();
    return _Input(ArrayList(riskLevels), size);
  }

  @override
  int solvePart01(_Input input) {
    return input.getMinPathRiskLevel(0, input.end);
  }

  @override
  int solvePart02(_Input input) {
    final newInput = _Input(
      ExtendedArrayList(input.riskLevels, input.size, 5),
      input.size * 5,
    );
    return newInput.getMinPathRiskLevel(0, newInput.end);
  }
}

abstract class Array {
  int get length;
  int operator [](int index);
}

class ArrayList extends Array {
  ArrayList(this.list);

  final List<int> list;

  @override
  int get length => list.length;

  @override
  int operator [](int index) => list[index];
}

class ExtendedArrayList extends Array {
  ExtendedArrayList(this.list, this.initialSize, this.multiplier)
      : rowSize = initialSize * initialSize * multiplier,
        newSize = initialSize * multiplier;

  final Array list;
  final int multiplier;
  final int initialSize;
  final int rowSize;
  final int newSize;

  @override
  int get length => list.length * multiplier * multiplier;

  @override
  int operator [](int index) {
    final bigCol = (index ~/ initialSize) % multiplier;
    final bigRow = index ~/ rowSize;
    final col = index % initialSize;
    final row = (index ~/ newSize) % initialSize;
    final realIndex = col + row * initialSize;
    final total = (list[realIndex] + bigCol + bigRow);
    return total % 10 + total ~/ 10;
  }
}

class _Input {
  _Input(this.riskLevels, this.size)
      : end = size * size - 1,
        max = size * size * 9;

  final Array riskLevels;
  final int size;
  final int end;
  final int max;

  int getCol(int position) => position % size;
  int getRow(int position) => position ~/ size;
  int getPos(int col, int row) => row * size + col;

  Set<int> getAdjacentPositions(int position) {
    int col = getCol(position);
    int row = getRow(position);
    Set<int> neighborPositions = {
      if (col - 1 >= 0) getPos(col - 1, row),
      if (col + 1 < size) getPos(col + 1, row),
      if (row - 1 >= 0) getPos(col, row - 1),
      if (row + 1 < size) getPos(col, row + 1),
    };
    return neighborPositions;
  }

  int getMinPathRiskLevel(int source, int target) {
    final length = end + 1;
    final unvisited = <int>{for (int i = 0; i < length; i++) i};
    final dist = List.filled(length, max);
    final prev = List<int?>.filled(length, null);
    dist[source] = 0;
    while (unvisited.isNotEmpty) {
      final position = () {
        int min = max + 1;
        int pos = -1;
        for (final p in unvisited) {
          if (dist[p] < min) {
            min = dist[p];
            pos = p;
          }
        }
        return pos;
      }();

      unvisited.remove(position);

      if (position == target) {
        final s = <int>[];
        int? u = target;
        if (prev[u] != null || u == source) {
          while (u != null) {
            s.add(u);
            u = prev[u];
          }
        }
        return s.map((x) => riskLevels[x]).reduce((a, b) => a + b) -
            riskLevels[source];
      }

      final adjacentPositions = getAdjacentPositions(position);
      final unvisitedAdjacentPositions =
          adjacentPositions.intersection(unvisited);

      for (final v in unvisitedAdjacentPositions) {
        final alt = dist[position] + riskLevels[v];
        if (alt < dist[v]) {
          dist[v] = alt;
          prev[v] = position;
        }
      }
    }
    return 0;
  }
}
