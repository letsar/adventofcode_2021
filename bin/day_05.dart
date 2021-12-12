import 'dart:math' as math;

import 'common.dart';

void main(List<String> arguments) {
  Day05().solve();
}

class Day05 extends AdventOfCodeDay<List<String>> {
  const Day05([String? inputFileName]) : super(5, inputFileName);

  @override
  List<String> parseInput(Input input) {
    return input.toStringList();
  }

  @override
  int solvePart01(List<String> input) {
    // We don't know the bottom right corner at the moment.
    // Either we do a first pass to get it, or we have a structure that allows us
    // to do it in one pass.
    // We'll do it in two passes.
    final shapes = <Shape>[];
    int maxX = 0;
    int maxY = 0;
    for (final line in input) {
      final points = line
          .split(' -> ')
          .expand((x) => x.split(','))
          .map((p) => int.parse(p))
          .toList();
      final shape = Shape.fromPoints(points);

      if (shape.isLineOnly()) {
        shapes.add(shape);
        maxX = math.max(maxX, math.max(shape.x1, shape.x2));
        maxY = math.max(maxY, math.max(shape.y1, shape.y2));
      }
    }

    // We know the bottom right corner.
    final cols = maxX + 1;
    final rows = maxY + 1;
    final grid = List.filled((cols) * (rows), 0);

    for (final shape in shapes) {
      // Second pass to fill the grid.
      for (int x = shape.minX; x <= shape.maxX; x++) {
        for (int y = shape.minY; y <= shape.maxY; y++) {
          final index = (y * cols) + x;
          grid[index]++;
        }
      }
    }

    // Another pass to count the number of points where at least two lines
    // overlap.
    final count = grid.where((x) => x >= 2).length;
    return count;
  }

  @override
  int solvePart02(List<String> input) {
    // We don't know the bottom right corner at the moment.
    // Either we do a first pass to get it, or we have a structure that allows us
    // to do it in one pass.
    // We'll do it in two passes.
    final shapes = <Shape>[];
    int maxX = 0;
    int maxY = 0;
    for (final line in input) {
      final points = line
          .split(' -> ')
          .expand((x) => x.split(','))
          .map((p) => int.parse(p))
          .toList();
      final shape = Shape.fromPoints(points);

      if (shape.isLineOrDiagonal()) {
        shapes.add(shape);
        maxX = math.max(maxX, math.max(shape.x1, shape.x2));
        maxY = math.max(maxY, math.max(shape.y1, shape.y2));
      }
    }

    // We know the bottom right corner.
    final cols = maxX + 1;
    final rows = maxY + 1;
    final grid = List.filled((cols) * (rows), 0);

    for (final shape in shapes) {
      // Second pass to fill the grid.
      if (shape.isDiagonal()) {
        final xUnit = shape.xUnit;
        final yUnit = shape.yUnit;
        for (int i = 0; i <= shape.diagonalLength(); i++) {
          final x = shape.x1 + xUnit * i;
          final y = shape.y1 + yUnit * i;
          final index = y * cols + x;
          grid[index]++;
        }
      } else {
        for (int x = shape.minX; x <= shape.maxX; x++) {
          for (int y = shape.minY; y <= shape.maxY; y++) {
            final index = y * cols + x;
            grid[index]++;
          }
        }
      }
    }

    // Another pass to count the number of points where at least two lines
    // overlap.
    final count = grid.where((x) => x >= 2).length;
    return count;
  }
}

class Shape {
  Shape(this.x1, this.y1, this.x2, this.y2);
  Shape.fromPoints(List<int> points)
      : x1 = points[0],
        y1 = points[1],
        x2 = points[2],
        y2 = points[3];

  final int x1;
  final int y1;
  final int x2;
  final int y2;

  int get minX => math.min(x1, x2);
  int get maxX => math.max(x1, x2);
  int get minY => math.min(y1, y2);
  int get maxY => math.max(y1, y2);

  bool isLineOnly() => x1 == x2 || y1 == y2;
  bool isDiagonal() => (x1 - x2).abs() == (y1 - y2).abs();
  bool isLineOrDiagonal() => isLineOnly() || isDiagonal();
  int diagonalLength() => (x1 - x2).abs();
  int get xUnit => (x2 - x1).sign;
  int get yUnit => (y2 - y1).sign;

  @override
  String toString() {
    return '$x1,$y1 -> $x2,$y2';
  }
}
