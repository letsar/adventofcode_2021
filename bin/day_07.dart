import 'dart:math' as math;

import 'common.dart';

void main(List<String> arguments) {
  Day07().solve();
}

class Day07 extends AdventOfCodeDay<List<int>> {
  const Day07([String? inputFileName]) : super(7, inputFileName);

  @override
  List<int> parseInput(Input input) {
    return input.rawInput.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  int solvePart01(List<int> input) {
    final positions = input.toList();
    // Compute the median.
    positions.sort();
    final length = positions.length;
    final middle = length ~/ 2;
    final median = () {
      if (length.isOdd) {
        return positions[middle];
      } else {
        return (positions[middle - 1] + positions[middle]) ~/ 2;
      }
    }();

    int fuel = 0;
    for (final position in positions) {
      fuel += (position - median).abs();
    }

    return fuel;
  }

  @override
  int solvePart02(List<int> input) {
    final positions = input.toList();
    final uniqueNumbers = <int>{};
    final seen = <int, int>{};
    int min = positions.first;
    int max = positions.first;
    for (final x in positions) {
      uniqueNumbers.add(x);
      int value = seen.putIfAbsent(x, () => 0);
      seen[x] = value + 1;
      min = math.min(min, x);
      max = math.max(max, x);
    }

    int computeTotalFuel(int position) {
      int totalFuel = 0;
      for (final number in uniqueNumbers) {
        totalFuel += computeFuel(number, position) * seen[number]!;
      }
      return totalFuel;
    }

    int minFuel = computeTotalFuel(min);

    for (int position = min + 1; position <= max; position++) {
      final fuel = computeTotalFuel(position);
      if (fuel < minFuel) {
        minFuel = fuel;
      }
    }

    return minFuel;
  }
}

int computeFuel(int from, int to) {
  final diff = (to - from).abs();
  return (1 + diff) * diff ~/ 2;
}
