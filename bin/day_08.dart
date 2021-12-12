import 'common.dart';

void main(List<String> arguments) {
  Day08().solve();
}

class Day08 extends AdventOfCodeDay<List<Entry>> {
  const Day08([String? inputFileName]) : super(8, inputFileName);

  @override
  List<Entry> parseInput(Input input) {
    return input.toStringList().map((e) => Entry.fromString(e)).toList();
  }

  @override
  int solvePart01(List<Entry> input) {
    int result = input
        .expand((e) => e.digits)
        .fold(0, (sum, x) => sum + (x.isEasyDigit() ? 1 : 0));
    return result;
  }

  @override
  int solvePart02(List<Entry> input) {
    return input.map((e) => Solver(e).solve()).reduce((sum, x) => sum + x);
  }
}

class Entry {
  const Entry(this.signals, this.digits);

  factory Entry.fromString(String input) {
    final parts = input.split(' | ');
    final signals = parts[0].split(' ').toList();
    final digits = parts[1].split(' ').toList();
    return Entry(signals, digits);
  }

  final List<String> signals;
  final List<String> digits;

  List<String> get all => [...signals, ...digits];
}

extension on String {
  bool isEasyDigit() =>
      length == 2 || length == 4 || length == 3 || length == 7;
}

class Symbol {
  const Symbol(this.value, this.length, this.code);

  final int value;
  final int length;
  final int code;
}

const segmentCodes = {
  97: 0x01,
  98: 0x02,
  99: 0x04,
  100: 0x08,
  101: 0x10,
  102: 0x20,
  103: 0x40,
};

const symbols = [
  // n: 0gfe dcba
  // 0: 0111 0111 = 0x77
  Symbol(0, 6, 0x77),
  // 1: 0010 0100 = 0x24
  Symbol(1, 2, 0x24),
  // 2: 0101 1101 = 0x5d
  Symbol(2, 5, 0x5d),
  // 3: 0110 1101 = 0x6d
  Symbol(3, 5, 0x6d),
  // 4: 0010 1110 = 0x2e
  Symbol(4, 4, 0x2e),
  // 5: 0110 1011 = 0x6b
  Symbol(5, 5, 0x6b),
  // 6: 0111 1011 = 0x7b
  Symbol(6, 6, 0x7b),
  // 7: 0010 0101 = 0x25
  Symbol(7, 3, 0x25),
  // 8: 0111 1111 = 0x7f
  Symbol(8, 7, 0x7f),
  // 9: 0110 1111 = 0x6f
  Symbol(9, 6, 0x6f),
];

const passes = [
  [1, 4, 7],
  [3],
  [2],
];

class Solver {
  Solver(this.entry);
  final Entry entry;

  int solve() {
    // First we transform all the entry into a list of codes.
    final codes = entry.all.map((e) => e.toSegmentCodes()).toList();
    const segmentsCandidates = 0x07F;
    final connexions = {
      0x01: segmentsCandidates,
      0x02: segmentsCandidates,
      0x04: segmentsCandidates,
      0x08: segmentsCandidates,
      0x10: segmentsCandidates,
      0x20: segmentsCandidates,
      0x40: segmentsCandidates,
    };

    void updateSegmentMapping(Set<int> codeSet, int code) {
      for (final pair in connexions.entries) {
        final key = pair.key;
        if (codeSet.contains(pair.key)) {
          // These are possible positions.
          connexions[key] = connexions[key]! & code;
        } else {
          // These are not possible positions.
          connexions[key] = connexions[key]! & ~code;
        }
      }
    }

    // First pass. We find 1, 4 and 7.
    for (final index in passes[0]) {
      final symbol = symbols[index];
      final inputLength = symbol.length;
      bool found = false;
      int i = 0;
      while (!found) {
        final codeSet = codes[i++];
        if (codeSet.length == inputLength) {
          found = true;
          updateSegmentMapping(codeSet, symbol.code);
        }
      }
    }

    // Second pass. We find 3.
    for (final index in passes[1]) {
      final symbol = symbols[index];
      final inputLength = symbol.length;
      final indexes = connexions.entries
          .where((pair) => pair.value == 0x24)
          .map((pair) => pair.key)
          .toList();
      bool found = false;
      int i = 0;
      while (!found) {
        final codeSet = codes[i++];
        // Only one that contains (2 and 5) segments.
        if (codeSet.length == inputLength && codeSet.containsAll(indexes)) {
          found = true;
          updateSegmentMapping(codeSet, symbol.code);
        }
      }
    }

    // Third pass. We find 2.
    for (final index in passes[2]) {
      final symbol = symbols[index];
      final inputLength = symbol.length;
      final k = connexions.entries.firstWhere((pair) => pair.value == 0x10).key;
      bool found = false;
      int i = 0;
      while (!found) {
        final codeSet = codes[i++];
        // Only one that contains segment 4.
        if (codeSet.length == inputLength && (codeSet.contains(k))) {
          found = true;
          updateSegmentMapping(codeSet, symbol.code);
        }
      }
    }

    // The mapping is now complete.
    // We can compute the digits of the entries.
    int sum = 0;
    for (int i = 0; i < 4; i++) {
      sum *= 10;
      sum += codes[10 + i].computeDigit(connexions);
    }

    return sum;
  }
}

extension on String {
  Set<int> toSegmentCodes() {
    return codeUnits.map((e) => segmentCodes[e]!).toSet();
  }
}

extension on Set<int> {
  int computeDigit(Map<int, int> connexions) {
    final code = map((x) => connexions[x]!).reduce((x, y) => x | y);
    return symbols.firstWhere((x) => x.code == code).value;
  }
}
