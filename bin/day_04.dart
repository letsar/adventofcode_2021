import 'common.dart';

void main(List<String> arguments) {
  Day04().solve();
}

class Day04 extends AdventOfCodeDay<_Input> {
  const Day04([String? inputFileName]) : super(4, inputFileName);

  @override
  _Input parseInput(Input input) {
    final list = input.toStringList();
    final numbers = list.first.split(',').map((x) => int.parse(x)).toList();
    final boards = <List<int>>[];
    for (int i = 2; i < list.length; i += 6) {
      final board = <int>[];
      for (int r = 0; r < 5; r++) {
        final row = list[i + r];
        final items =
            row.split(RegExp(r'(\s+)')).where((s) => s.isNotEmpty).toList();
        board.addAll(items.map((x) => int.parse(x)));
      }
      boards.add(board);
    }
    return _Input(numbers, boards);
  }

  @override
  int solvePart01(_Input input) {
    final numbers = input.numbers;
    final boards = input.boards;
    final score = 0;
    final markedBoards = List.generate(
      boards.length,
      (i) => List.filled(25, false),
    );
    for (int i = 0; i < numbers.length; i++) {
      final number = numbers[i];
      for (int b = 0; b < boards.length; b++) {
        final board = boards[b];
        final markedBoard = markedBoards[b];
        final indexOfNumber = board.indexOf(number);
        if (indexOfNumber > -1) {
          markedBoard[indexOfNumber] = true;
        }
        if (markedBoard.hasWon()) {
          int sum = 0;
          for (int x = 0; x < 25; x++) {
            if (!markedBoard[x]) {
              sum += board[x];
            }
          }
          return number * sum;
        }
      }
    }

    // No grid won.
    return score;
  }

  @override
  int solvePart02(_Input input) {
    final numbers = input.numbers;
    final boards = input.boards;
    final score = 0;
    final markedBoards = List.generate(
      boards.length,
      (i) => List.filled(25, false),
    );
    final wonBoards = <int>{};
    for (int i = 0; i < numbers.length; i++) {
      final number = numbers[i];
      for (int b = 0; b < boards.length; b++) {
        if (wonBoards.contains(b)) {
          continue;
        }
        final board = boards[b];
        final markedBoard = markedBoards[b];
        final indexOfNumber = board.indexOf(number);
        if (indexOfNumber > -1) {
          markedBoard[indexOfNumber] = true;
        }
        if (markedBoard.hasWon()) {
          if (wonBoards.length < boards.length - 1) {
            wonBoards.add(b);
          } else {
            int sum = 0;
            for (int x = 0; x < 25; x++) {
              if (!markedBoard[x]) {
                sum += board[x];
              }
            }
            return number * sum;
          }
        }
      }
    }

    // No grid won.
    return score;
  }
}

class _Input {
  const _Input(this.numbers, this.boards);
  final List<int> numbers;
  final List<List<int>> boards;
}

extension on List<bool> {
  bool hasWon() {
    bool won = false;
    for (int i = 0; i < 5 && !won; i++) {
      won |= rowHasWon(i) || colHasWon(i);
    }
    return won;
  }

  bool rowHasWon(int row) {
    return skip(row * 5).take(5).every((x) => x);
  }

  bool colHasWon(int col) {
    return this[0 * 5 + col] &&
        this[1 * 5 + col] &&
        this[2 * 5 + col] &&
        this[3 * 5 + col] &&
        this[4 * 5 + col];
  }
}
