import 'common.dart';

void main(List<String> arguments) {
  Day09().solve();
}

class Day09 extends AdventOfCodeDay<_Input> {
  const Day09([String? inputFileName]) : super(9, inputFileName);

  @override
  _Input parseInput(Input input) {
    final parts = input.toStringList();
    final rows = parts.length;
    final cols = parts[0].length;
    final heightmap = parts
        .expand((x) => x.split('').map((e) => int.parse(e)).toList())
        .toList();
    return _Input(heightmap, cols, rows);
  }

  @override
  int solvePart01(_Input input) {
    final heightmap = input.heightmap;
    final rows = input.rows;
    final cols = input.cols;
    // 0 or heightmap[position] if lowPoint.
    int lowPoint(int position) {
      final height = heightmap[position];
      final col = position % cols;
      final row = position ~/ cols;
      bool isLowPoint = true;
      if (col > 0) {
        isLowPoint &= heightmap[position - 1] > height;
      }
      if (col < cols - 1) {
        isLowPoint &= heightmap[position + 1] > height;
      }
      if (row > 0) {
        isLowPoint &= heightmap[position - cols] > height;
      }
      if (row < rows - 1) {
        isLowPoint &= heightmap[position + cols] > height;
      }
      return isLowPoint ? height : -1;
    }

    int sum = 0;
    for (int i = 0; i < heightmap.length; i++) {
      final l = lowPoint(i);
      sum += l + 1;
    }

    return sum;
  }

  @override
  int solvePart02(_Input input) {
    final heightmap = input.heightmap;
    final rows = input.rows;
    final cols = input.cols;
    int getBasinSize(int position, Set<int> visited) {
      final col = position % cols;
      final row = position ~/ cols;
      int size = 1;
      // We try to visit all the neighbors.
      //              (x, y-1)
      // (x-1, y)   ;          ; (x+1, y)
      //              (x, y+1)
      for (int x = -1; x < 2; x++) {
        for (int y = -1; y < 2; y++) {
          if (!((x == 0) ^ (y == 0))) {
            continue;
          }
          final newCol = col + x;
          final newRow = row + y;
          if (newCol < 0 || newCol >= cols || newRow < 0 || newRow >= rows) {
            continue;
          }
          final neighbor = newCol + newRow * cols;
          if (visited.add(neighbor)) {
            // We did not visited it yet. So we continue.
            if (heightmap[neighbor] < 9) {
              size += getBasinSize(neighbor, visited);
            }
          }
        }
      }
      return size;
    }

    // 0 or heightmap[position] if lowPoint.
    int lowPoint(int position) {
      final height = heightmap[position];
      final col = position % cols;
      final row = position ~/ cols;
      bool isLowPoint = true;
      if (col > 0) {
        isLowPoint &= heightmap[position - 1] > height;
      }
      if (col < cols - 1) {
        isLowPoint &= heightmap[position + 1] > height;
      }
      if (row > 0) {
        isLowPoint &= heightmap[position - cols] > height;
      }
      if (row < rows - 1) {
        isLowPoint &= heightmap[position + cols] > height;
      }
      if (isLowPoint) {
        final visited = {position};
        return getBasinSize(position, visited);
      }
      return 0;
    }

    final basinSizes = <int>[];
    for (int i = 0; i < heightmap.length; i++) {
      basinSizes.add(lowPoint(i));
    }

    basinSizes.sort();

    return basinSizes.reversed.take(3).reduce((a, b) => a * b);
  }
}

class _Input {
  const _Input(this.heightmap, this.cols, this.rows);

  final List<int> heightmap;
  final int cols;
  final int rows;
}
