import 'common.dart';

void main(List<String> arguments) {
  Day12().solve();
}

class Day12 extends AdventOfCodeDay<Graph> {
  const Day12([String? inputFileName]) : super(12, inputFileName);

  @override
  Graph parseInput(Input input) {
    final entries = input.toStringList();
    final Map<String, Cave> caves = {};
    for (final entry in entries) {
      final caveNames = entry.split('-');
      final cave1 = caves.putIfAbsent(caveNames[0], () => Cave(caveNames[0]));
      final cave2 = caves.putIfAbsent(caveNames[1], () => Cave(caveNames[1]));
      cave1.neighbors.add(cave2);
      cave2.neighbors.add(cave1);
    }
    return Graph(caves['start']!, caves['end']!);
  }

  @override
  int solvePart01(Graph input) {
    final paths = pathsToEnd(input.start, {});
    return paths.length;
  }

  @override
  int solvePart02(Graph input) {
    final paths = pathsToEnd02(input.start, {input.start: 0}, false);
    // _log(paths);
    return paths.length;
  }

  List<String> pathsToEnd(Cave cave, Set<Cave> denied) {
    if (cave.name == 'end') {
      return ['end'];
    }

    final newDenied = denied.toSet();
    if (!cave.isBig) {
      newDenied.add(cave);
    }

    List<String> paths = [];
    for (final neighbor in cave.neighbors) {
      if (!newDenied.contains(neighbor)) {
        final otherPaths = pathsToEnd(neighbor, newDenied)
            .map((e) => '${cave.name},$e')
            .toList();
        paths = [...paths, ...otherPaths];
      }
    }
    return paths;
  }

  List<String> pathsToEnd02(
    Cave cave,
    Map<Cave, int> left,
    bool smallOnlyOnce,
  ) {
    if (cave.name == 'end') {
      return ['end'];
    }

    final newLeft = Map.fromEntries(left.entries);
    if (!cave.isBig) {
      final leftCount = newLeft.putIfAbsent(cave, () => 2);
      newLeft[cave] = leftCount - 1;
      if (newLeft[cave] == 0) {
        smallOnlyOnce = true;
      }
    }

    final limit = smallOnlyOnce ? 1 : 0;

    List<String> paths = [];
    for (final neighbor in cave.neighbors) {
      if (!newLeft.containsKey(neighbor) || newLeft[neighbor]! > limit) {
        final otherPaths = pathsToEnd02(neighbor, newLeft, smallOnlyOnce)
            .map((e) => '${cave.name},$e')
            .toList();
        paths = [...paths, ...otherPaths];
      }
    }
    return paths;
  }
}

void _log(List<String> paths) {
  paths.sort();
  final buffer = StringBuffer();
  for (final path in paths) {
    buffer.write(path);
    buffer.writeln();
  }
  print(buffer);
}

class Graph {
  Graph(this.start, this.end);
  final Cave start;
  final Cave end;
}

class Cave {
  Cave(this.name)
      : isBig = name.toUpperCase() == name,
        neighbors = <Cave>{};

  final String name;
  final Set<Cave> neighbors;
  final bool isBig;
}
