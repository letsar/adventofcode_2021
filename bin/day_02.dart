import 'common.dart';

void main(List<String> arguments) {
  Day02().solve();
}

class Day02 extends AdventOfCodeDay<List<String>> {
  const Day02([String? inputFileName]) : super(2, inputFileName);

  @override
  List<String> parseInput(Input input) {
    return input.toStringList();
  }

  @override
  int solvePart01(List<String> input) {
    int position = 0;
    int depth = 0;
    for (final command in input) {
      final parts = command.split(' ');
      final direction = parts[0][0];
      final distance = int.parse(parts[1]);
      switch (direction) {
        case 'f':
          position += distance;
          break;
        case 'd':
          depth += distance;
          break;
        case 'u':
          depth -= distance;
          break;
        default:
      }
    }
    return position * depth;
  }

  @override
  int solvePart02(List<String> input) {
    int position = 0;
    int depth = 0;
    int aim = 0;
    for (final command in input) {
      final parts = command.split(' ');
      final direction = parts[0][0];
      final distance = int.parse(parts[1]);
      switch (direction) {
        case 'f':
          position += distance;
          depth += aim * distance;
          break;
        case 'd':
          aim += distance;
          break;
        case 'u':
          aim -= distance;
          break;
        default:
      }
    }
    return position * depth;
  }
}
