import 'dart:io';

abstract class AdventOfCodeDay<T> {
  const AdventOfCodeDay(
    this.day, [
    this.inputFileName,
  ]);

  final int day;
  final String? inputFileName;
  String get normalizedDay => day.toString().padLeft(2, '0');

  T parseInput(Input input);
  int solvePart01(T input);
  int solvePart02(T input);

  void solve() {
    final rawInput = _readInput(inputFileName);
    final input = parseInput(rawInput);
    print('Day $normalizedDay');
    print('Part 01: ${solvePart01(input)}');
    print('Part 02: ${solvePart02(input)}');
  }

  Input _readInput(String? fileName) {
    final effectiveFileName = fileName ?? 'aoc';
    final filePath = './inputs/$normalizedDay/$effectiveFileName.txt';
    final file = File(filePath);
    final contents = file.readAsStringSync();
    return Input(contents);
  }
}

class Input {
  const Input(this.rawInput);

  final String rawInput;

  List<String> toStringList() {
    return rawInput.split('\n');
  }

  List<int> toIntList() {
    return toStringList().map((e) => int.parse(e)).toList();
  }
}
