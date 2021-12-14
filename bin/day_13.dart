import 'dart:math' as math;

import 'common.dart';

void main(List<String> arguments) {
  Day13().solve();
}

class Day13 extends AdventOfCodeDay<_Input> {
  const Day13([String? inputFileName]) : super(13, inputFileName);

  @override
  _Input parseInput(Input input) {
    final parts = input.rawInput.split('\n\n');
    final points =
        parts[0].split('\n').map((l) => Point.fromString(l)).toList();
    final instrs =
        parts[1].split('\n').map((l) => FoldInstruction.fromString(l)).toList();
    final grid = Grid.fromPoints(points);
    return _Input(grid, instrs);
  }

  @override
  int solvePart01(_Input input) {
    final grid = input.grid;
    final instr = input.instructions.first;
    final newGrid = instr.fold(grid);
    return newGrid.dots.fold(0, (sum, x) => sum + (x ? 1 : 0));
  }

  @override
  int solvePart02(_Input input) {
    var grid = input.grid;
    for (final instr in input.instructions) {
      grid = instr.fold(grid);
    }
    _log(grid);
    return grid.dots.fold(0, (sum, x) => sum + (x ? 1 : 0));
  }
}

class _Input {
  _Input(this.grid, this.instructions);
  final Grid grid;
  final List<FoldInstruction> instructions;
}

class Point {
  const Point(this.x, this.y);
  factory Point.fromString(String s) {
    final parts = s.split(',');
    return Point(int.parse(parts[0]), int.parse(parts[1]));
  }

  final int x;
  final int y;
}

abstract class FoldInstruction {
  const FoldInstruction();
  factory FoldInstruction.fromString(String s) {
    final parts = s.split('=');
    int value = int.parse(parts[1]);
    if (parts[0].endsWith('x')) {
      return FoldLeft(value);
    } else {
      return FoldUp(value);
    }
  }

  Grid fold(Grid grid);
}

class FoldLeft extends FoldInstruction {
  FoldLeft(this.value);
  final int value;

  @override
  Grid fold(Grid grid) {
    final newCols = (grid.cols - 1) ~/ 2;
    final newRows = grid.rows;
    final length = newRows * newCols;
    final dots = List.filled(length, false);
    for (int i = 0; i < length; i++) {
      final row = i ~/ newCols;
      final oldCol = grid.cols - 1 - (i % newCols);
      final newCol = i % newCols;
      final newIndex = row * grid.cols + newCol;
      final oldIndex = row * grid.cols + oldCol;
      dots[i] = grid.dots[oldIndex] || grid.dots[newIndex];
    }
    return Grid(dots, newCols, newRows);
  }
}

class FoldUp extends FoldInstruction {
  FoldUp(this.value);
  final int value;

  @override
  Grid fold(Grid grid) {
    final newRows = (grid.rows - 1) ~/ 2;
    final newCols = grid.cols;
    final length = newRows * newCols;
    final dots = List.filled(length, false);
    for (int i = 0; i < length; i++) {
      final oldRow = grid.rows - 1 - i ~/ newCols;
      final oldCol = i % grid.cols;
      final newIndex = i;
      final oldIndex = oldRow * grid.cols + oldCol;
      dots[i] = grid.dots[oldIndex] || grid.dots[newIndex];
    }
    return Grid(dots, newCols, newRows);
  }
}

class Grid {
  const Grid(this.dots, this.cols, this.rows);
  factory Grid.fromPoints(List<Point> points) {
    int maxRow = 0;
    int maxCol = 0;
    for (final point in points) {
      maxRow = math.max(maxRow, point.y);
      maxCol = math.max(maxCol, point.x);
    }
    final cols = maxCol + 1;
    final rows = maxRow + 1;
    final dots = List.filled(cols * rows, false);
    for (final point in points) {
      dots[point.y * cols + point.x] = true;
    }
    return Grid(dots, cols, rows);
  }
  final int cols;
  final int rows;
  final List<bool> dots;
}

void _log(Grid grid) {
  final buffer = StringBuffer();
  for (int i = 0; i < grid.dots.length; i++) {
    if (i % grid.cols == 0) {
      buffer.writeln();
    }
    buffer.write(grid.dots[i] ? '#' : '.');
  }
  print(buffer);
}
