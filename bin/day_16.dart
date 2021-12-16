import 'dart:math' as math;

import 'common.dart';

void main(List<String> arguments) {
  Day16().solve();
}

final hexToBinary = {
  for (int i = 0; i < 16; i++)
    i.toRadixString(16).toUpperCase(): i.toRadixString(2).padLeft(4, '0'),
};

class Day16 extends AdventOfCodeDay<String> {
  const Day16([String? inputFileName]) : super(16, inputFileName);

  @override
  String parseInput(Input input) {
    final buffer = StringBuffer();
    final hexString = input.rawInput;
    for (int i = 0; i < hexString.length; i++) {
      buffer.write(hexToBinary[hexString[i]]);
    }
    return buffer.toString();
  }

  @override
  int solvePart01(String input) {
    final packet = Packet.parse(input);
    return packet.computeVersionSum();
  }

  @override
  int solvePart02(String input) {
    final packet = Packet.parse(input);
    return packet.eval();
  }
}

abstract class Packet {
  const Packet(this.header, this.payload, this.length);
  factory Packet.parse(String input) {
    final header = Header.parse(input);
    final packetPayload = input.substring(6);
    if (header.type == 4) {
      return LiteralPacket.parse(header, packetPayload);
    }

    return OperatorPacket.parse(header, packetPayload);
  }

  final String payload;
  final Header header;
  final int length;

  int computeVersionSum();
  int eval();
}

class Header {
  Header(this.version, this.type);
  factory Header.parse(String payload) {
    final version = payload.extract(0, 3);
    final type = payload.extract(3, 3);
    return Header(version, type);
  }
  final int version;
  final int type;

  @override
  String toString() {
    return '$version:$type';
  }
}

class OperatorPacket extends Packet {
  OperatorPacket(Header header, String payload, this.subPackets, int length)
      : super(header, payload, length);

  factory OperatorPacket.parse(Header header, String payload) {
    final lengthTypeID = payload[0];
    final subPackets = <Packet>[];
    int length = 7;
    if (lengthTypeID == '0') {
      final subPacketTotalLength = payload.extract(1, 15);
      length += 15;
      int subPacketCurrentLength = 0;
      while (subPacketCurrentLength < subPacketTotalLength) {
        final subPacketPayload = payload.substring(16 + subPacketCurrentLength);
        final subPacket = Packet.parse(subPacketPayload);
        subPacketCurrentLength += subPacket.length;
        subPackets.add(subPacket);
        length += subPacket.length;
      }
    } else {
      final subPacketCount = payload.extract(1, 11);
      length += 11;
      int subPacketCurrentLength = 0;
      for (int i = 0; i < subPacketCount; i++) {
        final subPacketPayload = payload.substring(12 + subPacketCurrentLength);
        final subPacket = Packet.parse(subPacketPayload);
        subPacketCurrentLength += subPacket.length;
        subPackets.add(subPacket);
        length += subPacket.length;
      }
    }
    return OperatorPacket(header, payload, subPackets, length);
  }

  final List<Packet> subPackets;

  @override
  int computeVersionSum() {
    return header.version +
        subPackets.fold(0, (sum, x) => sum + x.computeVersionSum());
  }

  @override
  int eval() {
    final typeId = header.type;
    switch (typeId) {
      case 0:
        // SUM
        return subPackets.fold(0, (sum, x) => sum + x.eval());
      case 1:
        // PRODUCT
        return subPackets.fold(1, (product, x) => product * x.eval());
      case 2:
        // MIN
        return subPackets.map((x) => x.eval()).reduce(math.min);
      case 3:
        // MAX
        return subPackets.map((x) => x.eval()).reduce(math.max);
      case 5:
        // GREATER THAN
        return subPackets.first.eval() > subPackets.last.eval() ? 1 : 0;
      case 6:
        // LESS THAN
        return subPackets.first.eval() < subPackets.last.eval() ? 1 : 0;
      case 7:
        // EQUAL
        return subPackets.first.eval() == subPackets.last.eval() ? 1 : 0;
    }
    return 0;
  }

  @override
  String toString() {
    return 'OP:';
  }
}

class LiteralPacket extends Packet {
  LiteralPacket(Header header, String payload, this.value, int length)
      : super(header, payload, length);
  factory LiteralPacket.parse(Header header, String payload) {
    String value = '';
    bool reading = true;
    int step = 0;
    while (reading) {
      final bits = payload.sub(step * 5, 5);
      reading = bits[0] == '1';
      value = value + bits.substring(1);
      step++;
    }
    return LiteralPacket(
      header,
      value,
      int.parse(value, radix: 2),
      step * 5 + 6,
    );
  }

  final int value;

  @override
  int computeVersionSum() {
    return header.version;
  }

  @override
  int eval() {
    return value;
  }

  @override
  String toString() {
    return 'LITERAL:$value';
  }
}

extension on String {
  String sub(int start, [int? length]) {
    return substring(start, length != null ? start + length : null);
  }

  int extract(int start, int length) {
    return int.parse(substring(start, start + length), radix: 2);
  }
}
