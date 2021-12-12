import 'dart:collection';

import 'common.dart';

void main(List<String> arguments) {
  Day10().solve();
}

class Day10 extends AdventOfCodeDay<List<String>> {
  const Day10([String? inputFileName]) : super(10, inputFileName);

  @override
  List<String> parseInput(Input input) {
    return input.toStringList();
  }

  @override
  int solvePart01(List<String> input) {
    return input.fold(0, (x, y) => x + getIncompleteScore(y));
  }

  @override
  int solvePart02(List<String> input) {
    final scores = input
        .map((x) => getAutocompleteScore(x))
        .where((x) => x > 0)
        .toList()
      ..sort();
    return scores[(scores.length - 1) ~/ 2];
  }

  int getIncompleteScore(String line) {
    final expectedClosingChars = ListQueue<String>();
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (pairs.containsKey(char)) {
        // opening char.
        expectedClosingChars.addLast(pairs[char]!);
      } else {
        // We have a closing char. We check if it's the one we expect.
        final expectedClosingChar = expectedClosingChars.removeLast();
        if (expectedClosingChar != char) {
          return incompletePoints[char]!;
        }
      }
    }

    return 0;
  }

  int getAutocompleteScore(String line) {
    final expectedClosingChars = ListQueue<String>();
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (pairs.containsKey(char)) {
        // opening char.
        expectedClosingChars.addLast(pairs[char]!);
      } else {
        // We have a closing char. We check if it's the one we expect.
        final expectedClosingChar = expectedClosingChars.removeLast();
        if (expectedClosingChar != char) {
          return 0;
        }
      }
    }

    int score = 0;
    while (expectedClosingChars.isNotEmpty) {
      final char = expectedClosingChars.removeLast();
      score = score * 5 + autocompletePoints[char]!;
    }
    return score;
  }
}

const pairs = {
  '(': ')',
  '[': ']',
  '{': '}',
  '<': '>',
};

const incompletePoints = {
  ')': 3,
  ']': 57,
  '}': 1197,
  '>': 25137,
};

const autocompletePoints = {
  ')': 1,
  ']': 2,
  '}': 3,
  '>': 4,
};
