void main(List<String> arguments) {
  final args = input.split(',').map((e) => int.parse(e)).toList();
  print(puzzle0601(args, 256));
}

int puzzle0601(List<int> lanternfishes, int days) {
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

const defaultInput = '''3,4,3,1,2''';

// 375482
const input =
    '''4,1,3,2,4,3,1,4,4,1,1,1,5,2,4,4,2,1,2,3,4,1,2,4,3,4,5,1,1,3,1,2,1,4,1,1,3,4,1,2,5,1,4,2,2,1,1,1,3,1,5,3,1,2,1,1,1,1,4,1,1,1,2,2,1,3,1,3,1,3,4,5,1,2,2,1,1,1,4,1,5,1,3,1,3,4,1,3,2,3,4,4,4,3,4,5,1,3,1,3,5,1,1,1,1,1,2,4,1,2,1,1,1,5,1,1,2,1,3,1,4,2,3,4,4,3,1,1,3,5,3,1,1,5,2,4,1,1,3,5,1,4,3,1,1,4,2,1,1,1,1,1,1,3,1,1,1,1,1,4,5,1,2,5,3,1,1,3,1,1,1,1,5,1,2,5,1,1,1,1,1,1,3,5,1,3,2,1,1,1,1,1,1,1,4,5,1,1,3,1,5,1,1,1,1,3,3,1,1,1,4,4,1,1,4,1,2,1,4,4,1,1,3,4,3,5,4,1,1,4,1,3,1,1,5,5,1,2,1,2,1,2,3,1,1,3,1,1,2,1,1,3,4,3,1,1,3,3,5,1,2,1,4,1,1,2,1,3,1,1,1,1,1,1,1,4,5,5,1,1,1,4,1,1,1,2,1,2,1,3,1,3,1,1,1,1,1,1,1,5''';
