import 'day_01_part_01.dart';

void main(List<String> arguments) {
  print(puzzle0102(input.toListInt()));
}

int puzzle0102(List<int> input) {
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
  return puzzle0101(newInput);
}
