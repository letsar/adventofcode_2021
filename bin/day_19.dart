import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

import 'common.dart';

void main(List<String> arguments) {
  Day19().solve();
}

class Day19 extends AdventOfCodeDay<Map<int, ResolvedScanner>> {
  const Day19([String? inputFileName]) : super(19, inputFileName);

  @override
  Map<int, ResolvedScanner> parseInput(Input input) {
    final scanners = input.rawInput
        .split(RegExp(r'(\s+)\n'))
        .map((s) => Scanner.parse(s))
        .toList();

    return resolveScanners(scanners);
  }

  @override
  int solvePart01(Map<int, ResolvedScanner> resolvedScanners) {
    // Get all the overlapping beacons.
    final allBeacons = resolvedScanners.values.expand((s) => s.beacons).toSet();
    return allBeacons.length;
  }

  @override
  int solvePart02(Map<int, ResolvedScanner> resolvedScanners) {
    int max = 0;
    for (final firstScanner in resolvedScanners.values) {
      for (final secondScanner in resolvedScanners.values) {
        max = math.max(max, secondScanner.manhattanDistance(firstScanner));
      }
    }

    return max;
  }

  Map<int, ResolvedScanner> resolveScanners(List<Scanner> input) {
    final resolvedScanners = <int, ResolvedScanner>{
      0: ResolvedScanner(0, 0, Vector3.zero(), 0, input[0].beacons),
    };

    // First we try only with zero, then with the ones directly related to 0
    // Then we then one related to the one before, and so on.
    final resolved = <int>{};
    final notResolved = <int>{for (int i = 1; i < input.length; i++) i};
    var currentToVisit = <int>{0};
    var nextToVisit = <int>{};
    while (currentToVisit.isNotEmpty) {
      for (final index in currentToVisit) {
        final currentScanner = input[index];
        for (final notResolvedIndex in notResolved) {
          final resolvedScanner =
              currentScanner.overlap(input[notResolvedIndex]);
          if (resolvedScanner != null) {
            resolvedScanners[notResolvedIndex] = resolvedScanner;
            nextToVisit.add(notResolvedIndex);
          }
        }
      }
      notResolved.removeAll(nextToVisit);
      resolved.addAll(currentToVisit);
      currentToVisit = nextToVisit;
      nextToVisit = <int>{};
    }

    for (final resolved in resolvedScanners.values) {
      // We need to get the relative position to the scanner 0.
      if (resolved.relativeTo != 0) {
        Vector3 pos = resolved.position;
        int relativeTo = resolved.relativeTo;
        List<int> rotations = [resolved.rotation];

        var sentinelPos = Vector3(1, 2, 3).rotate(resolved.rotation);
        while (relativeTo != 0) {
          final reference = resolvedScanners[relativeTo]!;
          pos = (reference.position + pos.rotate(reference.rotation));
          sentinelPos = sentinelPos.rotate(reference.rotation);
          rotations.add(reference.rotation);
          relativeTo = reference.relativeTo;
        }

        // We need to find the cumulative the final rotation
        final cumulativeRotation = _scannerRotations.entries
            .firstWhere((pair) => pair.value(Vector3(1, 2, 3)) == sentinelPos)
            .key;

        final newResolved = ResolvedScanner(
          relativeTo,
          resolved.index,
          pos,
          cumulativeRotation,
          input[resolved.index]
              .beacons
              .map((b) =>
                  rotations.fold<Vector3>(b, (x, r) => x.rotate(r)) + pos)
              .toSet(),
        );
        resolvedScanners[resolved.index] = newResolved;
      }
    }
    return resolvedScanners;
  }
}

class Scanner {
  const Scanner(this.index, this.beacons);
  factory Scanner.parse(String input) {
    final parts = input.split('\n');
    // The first part contains the index.
    final index = int.parse(
      parts[0].replaceFirst('--- scanner ', '').split(' ')[0],
    );
    final beacons = parts.skip(1).map((s) {
      final parts = s.split(',');
      return Vector3(
        double.parse(parts[0]),
        double.parse(parts[1]),
        double.parse(parts[2]),
      );
    }).toSet();
    return Scanner(index, beacons);
  }

  final int index;
  final Set<Vector3> beacons;

  ResolvedScanner? overlap(Scanner other) {
    for (final pivot in beacons) {
      final resolvedScanner = tryResolve(other, pivot);
      if (resolvedScanner != null) {
        return resolvedScanner;
      }
    }
    return null;
  }

  ResolvedScanner? tryResolve(
    Scanner other,
    Vector3 pivot,
  ) {
    for (int rot = 0; rot < 24; rot++) {
      final rotatedBeacons = other.beacons.map((b) => b.rotate(rot)).toList();
      for (final otherPivotbeacon in rotatedBeacons) {
        final translation = otherPivotbeacon - pivot;
        final translatedBeacons =
            rotatedBeacons.map((b) => b - translation).toSet();
        final overlappingBeacons =
            beacons.intersection(translatedBeacons).length;
        if (overlappingBeacons >= 12) {
          return ResolvedScanner(
            index,
            other.index,
            -translation,
            rot,
            translatedBeacons,
          );
        }
      }
    }
    return null;
  }

  @override
  String toString() => beacons.toScannerString(index);
}

class ResolvedScanner {
  const ResolvedScanner(
    this.relativeTo,
    this.index,
    this.position,
    this.rotation,
    this.beacons,
  );
  final int relativeTo;
  final Vector3 position;
  final int index;
  final int rotation;
  final Set<Vector3> beacons;

  int manhattanDistance(ResolvedScanner other) {
    return ((other.position - position)..absolute()).manhattanDistance();
  }

  @override
  String toString() => beacons.toScannerString(index);
}

extension on Vector3 {
  Vector3 rotate(int rotation) {
    return _scannerRotations[rotation]!(this);
  }

  int manhattanDistance() {
    return (x + y + z).toInt();
  }
}

extension on Set<Vector3> {
  String toScannerString(int index) {
    final buffer = StringBuffer('--- scanner $index ---\n');
    for (final beacon in this) {
      buffer.writeln(
          '${beacon.x.toInt()},${beacon.y.toInt()},${beacon.z.toInt()}');
    }
    return buffer.toString();
  }
}

final Map<int, Vector3 Function(Vector3)> _scannerRotations = {
  0: (p) => Vector3(p.x, p.y, p.z),
  1: (p) => Vector3(p.x, p.z, -p.y),
  2: (p) => Vector3(p.x, -p.y, -p.z),
  3: (p) => Vector3(p.x, -p.z, p.y),
  4: (p) => Vector3(-p.x, -p.y, p.z),
  5: (p) => Vector3(-p.x, p.z, p.y),
  6: (p) => Vector3(-p.x, p.y, -p.z),
  7: (p) => Vector3(-p.x, -p.z, -p.y),
  8: (p) => Vector3(p.y, -p.x, p.z),
  9: (p) => Vector3(p.y, p.z, p.x),
  10: (p) => Vector3(p.y, p.x, -p.z),
  11: (p) => Vector3(p.y, -p.z, -p.x),
  12: (p) => Vector3(-p.y, p.x, p.z),
  13: (p) => Vector3(-p.y, p.z, -p.x),
  14: (p) => Vector3(-p.y, -p.z, p.x),
  15: (p) => Vector3(-p.y, -p.x, -p.z),
  16: (p) => Vector3(p.z, p.y, -p.x),
  17: (p) => Vector3(p.z, -p.x, -p.y),
  18: (p) => Vector3(p.z, -p.y, p.x),
  19: (p) => Vector3(p.z, p.x, p.y),
  20: (p) => Vector3(-p.z, p.y, p.x),
  21: (p) => Vector3(-p.z, p.x, -p.y),
  22: (p) => Vector3(-p.z, -p.y, -p.x),
  23: (p) => Vector3(-p.z, -p.x, p.y),
};
