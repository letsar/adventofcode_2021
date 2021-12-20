import 'dart:math' as math;

import 'common.dart';

typedef Point = math.Point<int>;

void main(List<String> arguments) {
  Day20().solve();
}

class Day20 extends AdventOfCodeDay<_Input> {
  const Day20([String? inputFileName]) : super(20, inputFileName);

  @override
  _Input parseInput(Input input) {
    final parts = input.rawInput.split(RegExp(r'(\s+)\n'));
    final onSymbol = '#'.codeUnits[0];
    final algorithm = parts[0].codeUnits.map((e) => e == onSymbol).toList();
    final image = parts[1].split('\n');
    return _Input(algorithm, Image.parse(image));
  }

  @override
  int solvePart01(_Input input) {
    final img = input.enhance(input.image, 2, true);
    print(img);
    return img.onPixelCount;
  }

  @override
  int solvePart02(_Input input) {
    final img = input.enhance(input.image, 50, true);
    print(img);
    return img.onPixelCount;
  }
}

class _Input {
  _Input(this.algorithm, this.image);
  final List<bool> algorithm;
  final Image image;

  bool getOutputPixel(Image image, int x, int y, int outsideValue) {
    return algorithm[image.getEnhancementIndex(x, y, outsideValue)];
  }

  Image enhance(Image image, int iterations, bool outsideIsDark) {
    final minX = image.minX - 1;
    final maxX = image.maxX + 1;
    final minY = image.minY - 1;
    final maxY = image.maxY + 1;
    final onPixels = <Point>{};
    final remainingIterations = iterations - 1;
    final outsideValue = outsideIsDark ? 0 : 1;
    for (int y = minY; y <= maxY; y++) {
      for (int x = minX; x <= maxX; x++) {
        if (getOutputPixel(image, x, y, outsideValue)) {
          onPixels.add(Point(x, y));
        }
      }
    }
    final newImage = Image(onPixels, minX, minY, maxX, maxY);
    if (remainingIterations == 0) {
      return newImage;
    }
    return enhance(newImage, remainingIterations, !outsideIsDark);
  }
}

class Image {
  Image(this.onPixels, this.minX, this.minY, this.maxX, this.maxY);
  factory Image.parse(List<String> input) {
    final width = input[0].length;
    final height = input.length;
    final onPixels = <Point>{};
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (input[y][x] == '#') {
          onPixels.add(Point(x, y));
        }
      }
    }
    return Image(onPixels, 0, 0, width - 1, height - 1);
  }

  final Set<Point> onPixels;
  final int minX;
  final int maxX;
  final int minY;
  final int maxY;

  int get onPixelCount => onPixels.length;

  bool isOn(int x, int y) {
    return onPixels.contains(Point(x, y));
  }

  int getEnhancementIndex(int x, int y, int outsideValue) {
    int index = 0;
    for (int i = y - 1; i <= y + 1; i++) {
      for (int j = x - 1; j <= x + 1; j++) {
        final newValue = () {
          if (j < minX || j > maxX || i < minY || i > maxY) {
            return outsideValue;
          } else {
            return isOn(j, i) ? 1 : 0;
          }
        }();
        index = index * 2 + newValue;
      }
    }
    return index;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    for (int y = minY; y <= maxY; y++) {
      for (int x = minX; x <= maxX; x++) {
        buffer.write(isOn(x, y) ? '#' : '.');
      }
      buffer.write('\n');
    }
    return buffer.toString();
  }
}
