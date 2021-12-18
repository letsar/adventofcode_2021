import 'dart:math' as math;

import 'common.dart';

void main(List<String> arguments) {
  Day18().solve();
}

class Day18 extends AdventOfCodeDay<List<String>> {
  const Day18([String? inputFileName]) : super(18, inputFileName);

  @override
  List<String> parseInput(Input input) {
    return input.toStringList();
  }

  @override
  int solvePart01(List<String> input) {
    final numbers = input.map((x) => Number.parse(x)).toList();
    final sum = numbers.reduce((a, b) => a + b);
    return sum.magnitude;
  }

  @override
  int solvePart02(List<String> input) {
    int max = 0;
    for (int i = 0; i < input.length; i++) {
      for (int j = 0; j < input.length; j++) {
        if (i == j) {
          continue;
        }
        final left = Number.parse(input[i]);
        final right = Number.parse(input[j]);
        final sum = left + right;
        if (sum.magnitude > max) {
          max = sum.magnitude;
        }
      }
    }
    return max;
  }
}

abstract class Number {
  Number();
  factory Number.parse(String input) {
    if (input.startsWith('[')) {
      final withoutBrackets = input.substring(1, input.length - 1);

      // We stop at the first comma outside of a bracket;
      final commaIndex = () {
        int brackets = 0;
        int index = 0;
        do {
          final char = withoutBrackets[index];
          if (char == '[') {
            brackets++;
          } else if (char == ']') {
            brackets--;
          } else if (char == ',' && brackets == 0) {
            return index;
          }
          index++;
        } while (index < withoutBrackets.length);
        return index;
      }();

      final a = withoutBrackets.substring(0, commaIndex);
      final b = withoutBrackets.substring(commaIndex + 1);
      final l = Number.parse(a);
      final r = Number.parse(b);
      final p = Pair(l, r);
      l.parent = p;
      r.parent = p;
      return p;
    } else {
      int value = int.parse(input);
      return Literal(value);
    }
  }

  int get value;

  int get magnitude;

  Pair? parent;

  int get depth;

  bool get canExplode => depth >= 5;

  Number operator +(Number other) {
    final result = Pair(this, other);
    result.reduce();
    return result;
  }

  void reduce() {
    bool reduced;
    do {
      reduced = false;
      if (canExplode) {
        explode();
        reduced = true;
      }
      if (!reduced) {
        reduced = split();
      }
    } while (reduced == true);
  }

  void explode() {
    if (canExplode) {
      explodeFromStep(0);
    }
  }

  void explodeFromStep(int step) {
    final current = this;
    if (current is Pair) {
      final l = current.left;
      final r = current.right;
      if (step == 4 && l is Literal && r is Literal) {
        // explode
        final left = getLeft(current);
        left?.value += l.value;
        final right = getRight(current);
        right?.value += r.value;

        // remove
        final parent = current.parent;
        if (parent != null) {
          final literal = Literal(0);
          literal.parent = parent;
          if (parent.left == current) {
            parent.left = literal;
          } else {
            parent.right = literal;
          }
        }
      } else {
        if (l.depth + step == 4) {
          l.explodeFromStep(step + 1);
        } else {
          r.explodeFromStep(step + 1);
        }
      }
    }
  }

  bool split() {
    return splitNode(this);
  }

  bool splitNode(Number? node, [bool skip = false]) {
    // We iterate from left to right to find the first number that can be split.
    // Post-order
    if (node == null || skip) {
      return false;
    }
    if (node is Pair) {
      skip |= splitNode(node.left, skip);
      skip |= splitNode(node.right, skip);
      return skip;
    } else if (node is Literal) {
      return node.splitIfNeeded();
    } else {
      return false;
    }
  }

  Literal? getLeft(Number number) {
    Number previous = number;
    Pair? parent = number.parent;
    while (parent != null && parent.left == previous) {
      previous = parent;
      parent = parent.parent;
    }

    if (parent != null) {
      Number number = parent.left;
      while (number is Pair) {
        number = number.right;
      }
      return number as Literal;
    }
  }

  Literal? getRight(Number number) {
    Number previous = number;
    Pair? parent = number.parent;
    while (parent != null && parent.right == previous) {
      previous = parent;
      parent = parent.parent;
    }

    if (parent != null) {
      Number number = parent.right;
      while (number is Pair) {
        number = number.left;
      }
      return number as Literal;
    }
  }
}

class Pair extends Number {
  Pair(this.left, this.right) {
    left.parent = this;
    right.parent = this;
  }

  Number left;
  Number right;

  @override
  int get value => left.value + right.value;

  @override
  int get magnitude => 3 * left.magnitude + 2 * right.magnitude;

  @override
  int get depth => math.max(left.depth, right.depth) + 1;

  @override
  String toString() {
    return '[$left,$right]';
  }
}

class Literal extends Number {
  Literal(this.value);

  @override
  int value;

  @override
  int get magnitude => value;

  @override
  final int depth = 0;

  bool splitIfNeeded() {
    if (value > 9) {
      final left = value ~/ 2;
      final right = value - left;
      final pair = Pair(Literal(left), Literal(right));
      final localParent = parent;
      pair.parent = localParent;
      if (localParent == null) {
        // error, we don't supporting adding nothing.
      } else if (localParent.left == this) {
        localParent.left = pair;
      } else {
        localParent.right = pair;
      }
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return '$value';
  }
}
