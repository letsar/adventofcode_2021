import 'dart:math' as math;

import 'common.dart';

void main(List<String> arguments) {
  Day14().solve();
}

class Day14 extends AdventOfCodeDay<_Input> {
  const Day14([String? inputFileName]) : super(14, inputFileName);

  @override
  _Input parseInput(Input input) {
    final parts = input.rawInput.split('\n\n');
    final polymerTemplate = parts[0];
    final replacements = Map.fromEntries(parts[1].split('\n').map((l) {
      final pair = l.split(' -> ');
      return MapEntry(pair[0], pair[1]);
    }));
    return _Input(polymerTemplate, replacements);
  }

  @override
  int solvePart01(_Input input) {
    final replacements = input.replacements;
    String polymer = input.polymerTemplate;
    for (int i = 0; i < 10; i++) {
      polymer = polymerize(polymer, replacements);
    }
    final map = countElements(polymer);
    final min = map.values.reduce(math.min);
    final max = map.values.reduce(math.max);
    return max - min;
  }

  @override
  int solvePart02(_Input input) {
    // The solution used in solvePart01 takes too much memory/cpu cycles.
    // So we have to find another way.

    // In fact we just have to create a map of pair->count which will produce a
    // map of other pair -> count.
    final replacements = input.replacements;
    String polymer = input.polymerTemplate;

    var pairCount = transformToPairCount(polymer);
    for (int i = 0; i < 40; i++) {
      pairCount = polymerizePairs(pairCount, replacements);
    }
    final map = countPairElements(pairCount);
    final min = map.values.reduce(math.min);
    final max = map.values.reduce(math.max);
    return max - min;
  }

  String polymerize(String template, Map<String, String> replacements) {
    final buffer = StringBuffer(template[0]);
    for (var i = 0; i < template.length - 1; i++) {
      final pair = template.substring(i, i + 2);
      final replacement = replacements[pair];
      if (replacement != null) {
        buffer.write('$replacement${pair[1]}');
      }
    }
    return buffer.toString();
  }

  Map<String, int> countElements(String polymer) {
    final result = <String, int>{};
    for (int i = 0; i < polymer.length; i++) {
      final element = polymer[i];
      final count = result.putIfAbsent(element, () => 0);
      result[element] = count + 1;
    }
    return result;
  }

  Map<String, int> transformToPairCount(String polymer) {
    final result = <String, int>{};
    for (var i = 0; i < polymer.length - 1; i++) {
      final pair = polymer.substring(i, i + 2);
      final count = result.putIfAbsent(pair, () => 0);
      result[pair] = count + 1;
    }
    return result;
  }

  Map<String, int> polymerizePairs(
    Map<String, int> pairCount,
    Map<String, String> replacements,
  ) {
    final result = <String, int>{};
    for (final entry in pairCount.entries) {
      final pair = entry.key;
      final count = entry.value;
      final replacement = replacements[pair];
      if (replacement != null) {
        final start = pair[0] + replacement;
        final end = replacement + pair[1];
        final startCount = result.putIfAbsent(start, () => 0);
        final endCount = result.putIfAbsent(end, () => 0);
        result[start] = startCount + count;
        result[end] = endCount + count;
      }
    }
    return result;
  }

  Map<String, int> countPairElements(Map<String, int> pairCount) {
    final result = <String, int>{};
    for (final entries in pairCount.entries) {
      final pair = entries.key;
      final count = entries.value;
      final first = pair[0];
      final second = pair[1];
      result[first] = result.putIfAbsent(first, () => 0) + count;
      result[second] = result.putIfAbsent(second, () => 0) + count;
    }
    // We have to divide everything by two because we count everything (except
    // the ends) twice.
    for (final entry in result.entries) {
      final value = entry.value.isEven ? entry.value : entry.value + 1;
      result[entry.key] = value ~/ 2;
    }
    return result;
  }
}

class _Input {
  _Input(this.polymerTemplate, this.replacements);
  final String polymerTemplate;
  final Map<String, String> replacements;
}
