void main(List<String> arguments) {
  final args = input.split(',').map((e) => int.parse(e)).toList();
  print(puzzle0602(args, 256));
}

int puzzle0602(List<int> lanternfishes, int days) {
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

const defaultInput = '''3,4,3,1,2''';

// 375482
const input =
    '''4,1,3,2,4,3,1,4,4,1,1,1,5,2,4,4,2,1,2,3,4,1,2,4,3,4,5,1,1,3,1,2,1,4,1,1,3,4,1,2,5,1,4,2,2,1,1,1,3,1,5,3,1,2,1,1,1,1,4,1,1,1,2,2,1,3,1,3,1,3,4,5,1,2,2,1,1,1,4,1,5,1,3,1,3,4,1,3,2,3,4,4,4,3,4,5,1,3,1,3,5,1,1,1,1,1,2,4,1,2,1,1,1,5,1,1,2,1,3,1,4,2,3,4,4,3,1,1,3,5,3,1,1,5,2,4,1,1,3,5,1,4,3,1,1,4,2,1,1,1,1,1,1,3,1,1,1,1,1,4,5,1,2,5,3,1,1,3,1,1,1,1,5,1,2,5,1,1,1,1,1,1,3,5,1,3,2,1,1,1,1,1,1,1,4,5,1,1,3,1,5,1,1,1,1,3,3,1,1,1,4,4,1,1,4,1,2,1,4,4,1,1,3,4,3,5,4,1,1,4,1,3,1,1,5,5,1,2,1,2,1,2,3,1,1,3,1,1,2,1,1,3,4,3,1,1,3,3,5,1,2,1,4,1,1,2,1,3,1,1,1,1,1,1,1,4,5,5,1,1,1,4,1,1,1,2,1,2,1,3,1,3,1,1,1,1,1,1,1,5''';
