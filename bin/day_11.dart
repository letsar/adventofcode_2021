import 'common.dart';

void main(List<String> arguments) {
  Day11().solve();
}

class Day11 extends AdventOfCodeDay<List<int>> {
  const Day11([String? inputFileName]) : super(11, inputFileName);

  @override
  List<int> parseInput(Input input) {
    return input.rawInput
        .split('\n')
        .expand((x) => x.split('').map((e) => int.parse(e)))
        .toList();
  }

  @override
  int solvePart01(List<int> list) {
    final input = list.toList();
    int flashes = 0;
    const cols = 10;
    const rows = 10;
    final flashed = <int>{};
    for (int step = 0; step < 100; step++) {
      // First, the energy level of each octopus increases by 1.
      for (int i = 0; i < input.length; i++) {
        input[i]++;
      }

      // 2. Flashing mode.
      late int oldFlashes;
      do {
        oldFlashes = flashed.length;
        for (int i = 0; i < input.length; i++) {
          if (input[i] > 9) {
            // Then, any octopus with an energy level greater than 9 flashes.
            if (flashed.add(i)) {
              // This increases the energy level of all adjacent octopuses by 1,
              // including octopuses that are diagonally adjacent.
              final col = i % cols;
              final row = i ~/ cols;
              for (int j = -1; j <= 1; j++) {
                for (int k = -1; k <= 1; k++) {
                  if (j == 0 && k == 0) continue;
                  final newRow = row + j;
                  final newCol = col + k;
                  if (newRow < 0 ||
                      newRow >= rows ||
                      newCol < 0 ||
                      newCol >= cols) continue;
                  final index = newRow * cols + newCol;
                  input[index]++;
                }
              }
            }
          }
        }
      } while (oldFlashes != flashed.length);

      // Finally, any octopus that flashed during this step has its energy level
      // set to 0, as it used all of its energy to flash.
      for (final index in flashed) {
        input[index] = 0;
      }

      flashes += flashed.length;
      flashed.clear();
    }
    return flashes;
  }

  @override
  int solvePart02(List<int> list) {
    final input = list.toList();
    const cols = 10;
    const rows = 10;
    final flashed = <int>{};
    int step = 0;
    while (input.any((x) => x > 0)) {
      // First, the energy level of each octopus increases by 1.
      for (int i = 0; i < input.length; i++) {
        input[i]++;
      }

      // 2. Flashing mode.
      late int oldFlashes;
      do {
        oldFlashes = flashed.length;
        for (int i = 0; i < input.length; i++) {
          if (input[i] > 9) {
            // Then, any octopus with an energy level greater than 9 flashes.
            if (flashed.add(i)) {
              // This increases the energy level of all adjacent octopuses by 1,
              // including octopuses that are diagonally adjacent.
              final col = i % cols;
              final row = i ~/ cols;
              for (int j = -1; j <= 1; j++) {
                for (int k = -1; k <= 1; k++) {
                  if (j == 0 && k == 0) continue;
                  final newRow = row + j;
                  final newCol = col + k;
                  if (newRow < 0 ||
                      newRow >= rows ||
                      newCol < 0 ||
                      newCol >= cols) continue;
                  final index = newRow * cols + newCol;
                  input[index]++;
                }
              }
            }
          }
        }
      } while (oldFlashes != flashed.length);

      // Finally, any octopus that flashed during this step has its energy level
      // set to 0, as it used all of its energy to flash.
      for (final index in flashed) {
        input[index] = 0;
      }

      flashed.clear();
      step++;
    }
    return step;
  }
}
