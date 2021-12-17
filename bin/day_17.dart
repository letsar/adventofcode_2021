import 'dart:math' as math;

import 'common.dart';

typedef Point = math.Point<int>;

void main(List<String> arguments) {
  Day17().solve();
}

class Day17 extends AdventOfCodeDay<Area> {
  const Day17([String? inputFileName]) : super(17, inputFileName);

  @override
  Area parseInput(Input input) {
    return Area.parse(input.rawInput);
  }

  @override
  int solvePart01(Area input) {
    final simulator = Simulator(input);
    int max = 0;
    late List<Point> points;
    for (int vx = 1; vx <= input.xMax; vx++) {
      for (int vy = 1; vy < input.yMin.abs(); vy++) {
        points = simulator.simulate(Probe(vx, vy));
        if (points.any((point) => input.contains(point))) {
          final maxY = points.fold<int>(0, (max, p) => math.max(max, p.y));
          if (maxY > max) {
            max = maxY;
          }
        }
      }
    }
    return max;
  }

  @override
  int solvePart02(Area input) {
    final simulator = Simulator(input);
    final options = <Point>{};
    for (int vx = 1; vx <= input.xMax; vx++) {
      for (int vy = input.yMin; vy < input.yMin.abs(); vy++) {
        final points = simulator.simulate(Probe(vx, vy));
        if (points.any((point) => input.contains(point))) {
          options.add(Point(vx, vy));
        }
      }
    }
    return options.length;
  }
}

class Probe {
  Probe(
    this.velocityX,
    this.velocityY,
  ) : position = const Point(0, 0);

  Point position;
  int velocityX;
  int velocityY;
}

class Simulator {
  const Simulator(this.target);

  final Area target;

  Point simulateStep(Probe probe) {
    final position = probe.position;
    int x = position.x + probe.velocityX;
    int y = position.y + probe.velocityY;
    // Due to drag, the probe's x velocity changes by 1 toward the value 0
    if (probe.velocityX > 0) {
      probe.velocityX--;
    } else if (probe.velocityX < 0) {
      probe.velocityX++;
    }
    // Due to gravity, the probe's y velocity decreases by 1
    probe.velocityY--;
    probe.position = Point(x, y);
    return probe.position;
  }

  List<Point> simulate(Probe probe) {
    final result = <Point>[probe.position];
    Point point = result[0];
    do {
      point = simulateStep(probe);
      result.add(point);
    } while (point.x <= target.xMax && point.y >= target.yMin);
    result.removeLast();
    return result;
  }

  void drawSimulation(List<Point> simulation) {
    simulation.add(Point(target.xMax, target.yMin));
    final minX = simulation.map((p) => p.x).reduce(math.min);
    final maxX = simulation.map((p) => p.x).reduce(math.max);
    final minY = simulation.map((p) => p.y).reduce(math.min);
    final maxY = simulation.map((p) => p.y).reduce(math.max);
    simulation.removeLast();
    final buffer = StringBuffer();
    for (int y = maxY; y >= minY; y--) {
      for (int x = minX; x <= maxX; x++) {
        final point = Point(x, y);
        if (point == const Point(0, 0)) {
          buffer.write('S');
        } else if (simulation.contains(point)) {
          buffer.write('#');
        } else if (target.contains(point)) {
          buffer.write('T');
        } else {
          buffer.write('.');
        }
      }
      buffer.write('\n');
    }
    print(buffer.toString());
  }
}

class Area {
  const Area(this.xMin, this.xMax, this.yMin, this.yMax);
  factory Area.parse(String rawInput) {
    final parts = rawInput.replaceFirst('target area: ', '').split(', ');
    final xMinMax = MinMax.parse(parts[0]);
    final yMinMax = MinMax.parse(parts[1]);
    return Area(xMinMax.min, xMinMax.max, yMinMax.min, yMinMax.max);
  }

  final int xMin;
  final int xMax;
  final int yMin;
  final int yMax;

  bool contains(Point point) {
    return point.x >= xMin &&
        point.x <= xMax &&
        point.y >= yMin &&
        point.y <= yMax;
  }

  @override
  String toString() {
    return 'x=$xMin..$xMax, y=$yMin..$yMax';
  }
}

class MinMax {
  const MinMax(this.min, this.max);
  factory MinMax.parse(String rawInput) {
    final coordinates = rawInput.substring(2).split('..').map(
          (x) => int.parse(x),
        );
    final min = coordinates.reduce(math.min);
    final max = coordinates.reduce(math.max);
    return MinMax(min, max);
  }
  final int min;
  final int max;
}
