import 'dart:math' as math;

import 'common.dart';

void main(List<String> arguments) {
  Day03().solve();
}

class Day03 extends AdventOfCodeDay<_Input> {
  const Day03([String? inputFileName]) : super(3, inputFileName);

  @override
  _Input parseInput(Input input) {
    final stringList = input.toStringList();
    final bitsLength = stringList.first.length;
    final list = stringList.map((e) => int.parse(e, radix: 2)).toList();
    return _Input(bitsLength, list);
  }

  @override
  int solvePart01(_Input input) {
    final bitsLength = input.bitsLength;
    final list = input.list;
    int gammaRate = 0;
    final max = math.pow(2, bitsLength).toInt() - 1;
    final inputLength = list.length;
    final half = (inputLength / 2).ceil();
    for (int i = 0; i < bitsLength; i++) {
      final test = 1 << i;
      int oneCount = 0;
      for (int j = 0;
          j < inputLength && (oneCount < half && (j - oneCount) < half);
          j++) {
        final bits = list[j];
        if (bits & test != 0) {
          oneCount++;
        }
      }
      if (oneCount >= half) {
        gammaRate += test;
      }
    }

    int epsilonRate = max - gammaRate;
    int powerConsumption = gammaRate * epsilonRate;
    return powerConsumption;
  }

  @override
  int solvePart02(_Input input) {
    final bitsLength = input.bitsLength;
    final list = input.list;
    List<int> inputCopy = list.toList();
    int oxygenGeneratorRating = 0;
    for (int i = bitsLength - 1; i >= 0 && inputCopy.length > 1; i--) {
      final half = (inputCopy.length / 2).ceil();
      final test = 1 << i;
      int oneCount = 0;
      for (int j = 0; j < inputCopy.length; j++) {
        final bits = inputCopy[j];
        if (bits & test != 0) {
          oneCount++;
        }
      }

      // Keep only those which start with the most common.
      if (oneCount >= half) {
        inputCopy.retainWhere((x) => x & test != 0);
      } else {
        inputCopy.retainWhere((x) => x & test == 0);
      }
    }
    oxygenGeneratorRating = inputCopy.first;

    inputCopy = list.toList();
    int co2ScrubberRating = 0;
    for (int i = bitsLength - 1; i >= 0 && inputCopy.length > 1; i--) {
      final half = (inputCopy.length / 2).ceil();
      final test = 1 << i;
      int oneCount = 0;
      for (int j = 0; j < inputCopy.length; j++) {
        final bits = inputCopy[j];
        if (bits & test != 0) {
          oneCount++;
        }
      }

      // Keep only those which start with the most common.
      if (oneCount >= half) {
        inputCopy.retainWhere((x) => x & test == 0);
      } else {
        inputCopy.retainWhere((x) => x & test != 0);
      }
    }
    co2ScrubberRating = inputCopy.first;

    return oxygenGeneratorRating * co2ScrubberRating;
  }
}

class _Input {
  const _Input(this.bitsLength, this.list);
  final int bitsLength;
  final List<int> list;
}
