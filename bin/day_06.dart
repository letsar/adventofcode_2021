import 'common.dart';

void main(List<String> arguments) {
  Day06().solve();
}

class Day06 extends AdventOfCodeDay<List<int>> {
  const Day06([String? inputFileName]) : super(6, inputFileName);

  @override
  List<int> parseInput(Input input) {
    return input.rawInput.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  int solvePart01(List<int> input) {
    final lanternfishes = input.toList();
    final days = 80;
    // Very naive solution which will see in the second part, is not scalable.
    for (int i = 0; i < days; i++) {
      final length = lanternfishes.length;
      for (int l = 0; l < length; l++) {
        int lanternfish = lanternfishes[l];
        if (lanternfish == 0) {
          lanternfish = 6;
          lanternfishes.add(8);
        } else {
          lanternfish--;
        }
        lanternfishes[l] = lanternfish;
      }
    }
    return lanternfishes.length;
  }

  @override
  int solvePart02(List<int> input) {
    final lanternfishes = input.toList();
    final days = 256;
    // Create a list of 9 elements counting the number of lanternfishes in each
    // position.
    final list = List.filled(9, 0);
    for (final lanternfish in lanternfishes) {
      list[lanternfish]++;
    }

    for (int i = 0; i < days; i++) {
      final zero = list[0];

      for (int j = 1; j < list.length; j++) {
        list[j - 1] = list[j];
      }

      list[8] = zero;
      list[6] += zero;
    }

    return list.reduce((sum, x) => sum + x);
  }
}
