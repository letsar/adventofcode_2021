import 'common.dart';

void main(List<String> arguments) {
  Day01().solve();
}

class Day01 extends AdventOfCodeDay<List<int>> {
  const Day01([String? inputFileName]) : super(1, inputFileName);

  @override
  List<int> parseInput(Input input) {
    return input.toIntList();
  }

  @override
  int solvePart01(List<int> input) {
    return _solve(input);
  }

  @override
  int solvePart02(List<int> input) {
    final windowsLength = 3;
    final windows = List.filled(windowsLength, 0);
    final newInput = <int>[];
    for (int i = 0; i < input.length; i++) {
      if (i ~/ windowsLength == 0) {
        for (int j = 0; j <= i % windowsLength; j++) {
          windows[j] += input[i];
        }
      } else {
        for (int j = 0; j < windowsLength; j++) {
          windows[j] += input[i];
        }
      }

      if (i > 1) {
        final pushIndex = (i - 2) % windowsLength;
        newInput.add(windows[pushIndex]);
        windows[pushIndex] = 0;
      }
    }
    return _solve(newInput);
  }

  int _solve(List<int> entries) {
    int largerMeasurements = 0;
    if (entries.length < 2) {
      return 0;
    }

    for (int i = 1; i < entries.length; i++) {
      if (entries[i] > entries[i - 1]) {
        largerMeasurements++;
      }
    }
    return largerMeasurements;
  }
}
