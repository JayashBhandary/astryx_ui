/// Two single-path marks — the Astryx logo and the GitHub mark — drawn from
/// their SVG path data.
///
/// The docs app has no SVG renderer and does not need one for two glyphs: a
/// path parser that understands the commands these paths use (M L H V C S A Z,
/// both cases) is forty lines, and it keeps the marks crisp at any size and in
/// any colour the theme asks for.
// The path data is split for line length only; SVG needs no separator
// between a number and the next command.
// ignore_for_file: missing_whitespace_between_adjacent_strings, lines_longer_than_80_chars
library;

import 'package:flutter/widgets.dart';

/// The Astryx logo, from `web/favicon.svg`. 96×96.
const String astryxLogoPath =
    'M26.88 0c8.483 0 15.36 6.877 15.36 15.36v13.92a4.8 4.8 0 0 0 4.8 4.8h1.92'
    'a4.8 4.8 0 0 0 4.8-4.8V15.36C53.76 6.877 60.637 0 69.12 0h21.12A5.76 5.76 '
    '0 0 1 96 5.76v21.12c0 8.483-6.877 15.36-15.36 15.36H66.72a4.8 4.8 0 0 0-4.8 '
    '4.8v1.92a4.8 4.8 0 0 0 4.8 4.8h13.92c8.483 0 15.36 6.877 15.36 15.36v21.12A5.76 '
    '5.76 0 0 1 90.24 96H69.12c-8.483 0-15.36-6.877-15.36-15.36V66.72a4.8 4.8 0 0 '
    '0-4.8-4.8h-1.92a4.8 4.8 0 0 0-4.8 4.8v13.92c0 8.483-6.877 15.36-15.36 15.36H5.76'
    'A5.76 5.76 0 0 1 0 90.24V69.12c0-8.483 6.877-15.36 15.36-15.36h13.92a4.8 4.8 0 '
    '0 0 4.8-4.8v-1.92a4.8 4.8 0 0 0-4.8-4.8H15.36C6.877 42.24 0 35.363 0 26.88V5.76'
    'A5.76 5.76 0 0 1 5.76 0z';

/// The logo's brand blue, as in `web/favicon.svg`.
const Color astryxLogoColor = Color(0xFF225BFF);

/// The GitHub mark (Octicons `mark-github`). 16×16.
const String githubMarkPath =
    'M8 0c4.42 0 8 3.58 8 8a8.013 8.013 0 0 1-5.45 7.59c-.4.08-.55-.17-.55-.38 '
    '0-.27.01-1.13.01-2.2 0-.75-.25-1.23-.54-1.48 1.78-.2 3.65-.88 3.65-3.95 '
    '0-.88-.31-1.59-.82-2.15.08-.2.36-1.02-.08-2.12 0 0-.67-.22-2.2.82-.64-.18'
    '-1.32-.27-2-.27-.68 0-1.36.09-2 .27-1.53-1.03-2.2-.82-2.2-.82-.44 1.1-.16 '
    '1.92-.08 2.12-.51.56-.82 1.28-.82 2.15 0 3.06 1.86 3.75 3.64 3.95-.23.2-.44'
    '.55-.51 1.07-.46.21-1.61.55-2.33-.66-.15-.24-.6-.83-1.23-.82-.67.01-.27.38'
    '.01.53.34.19.73.9.82 1.13.16.45.68 1.31 2.69.94 0 .67.01 1.3.01 1.49 0 '
    '.21-.15.45-.55.38A7.995 7.995 0 0 1 0 8c0-4.42 3.58-8 8-8Z';

/// Paints one SVG path, scaled from [viewBox] to [size].
class DocsSvgMark extends StatelessWidget {
  const DocsSvgMark({
    required this.path,
    required this.viewBox,
    required this.color,
    this.size = 20,
    this.semanticsLabel,
    super.key,
  });

  /// SVG path data.
  final String path;

  /// The side of the square the path is drawn in.
  final double viewBox;

  final Color color;
  final double size;

  /// Null leaves the mark out of the semantics tree, which is right when the
  /// button around it already carries the name.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final paint = CustomPaint(
      size: Size.square(size),
      painter: _MarkPainter(parseSvgPath(path), viewBox, color),
    );
    if (semanticsLabel == null) return ExcludeSemantics(child: paint);
    return Semantics(label: semanticsLabel, image: true, child: paint);
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.path, this.viewBox, this.color);

  final Path path;
  final double viewBox;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / viewBox, size.height / viewBox)
      ..drawPath(path, Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.color != color || old.viewBox != viewBox || old.path != path;
}

final Map<String, Path> _cache = <String, Path>{};

/// Parses SVG path data into a [Path].
///
/// Supports M L H V C S A Z in absolute and relative form, with implicit
/// repetition — what the two marks above use. Anything else throws, so a new
/// mark that needs more is found at once rather than drawn wrong.
Path parseSvgPath(String data) => _cache.putIfAbsent(data, () {
  final tokens = RegExp(
    r'[MmLlHhVvCcSsAaZz]|-?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?',
  ).allMatches(data).map((m) => m.group(0)!).toList();

  final path = Path()..fillType = PathFillType.nonZero;
  var i = 0;
  var command = '';
  var x = 0.0;
  var y = 0.0;
  var startX = 0.0;
  var startY = 0.0;
  var lastCx = 0.0;
  var lastCy = 0.0;

  bool isCommand(String t) => RegExp(r'^[A-Za-z]$').hasMatch(t);
  double next() => double.parse(tokens[i++]);

  while (i < tokens.length) {
    if (isCommand(tokens[i])) command = tokens[i++];
    final relative = command == command.toLowerCase();
    final dx = relative ? x : 0.0;
    final dy = relative ? y : 0.0;

    switch (command.toUpperCase()) {
      case 'M':
        x = next() + dx;
        y = next() + dy;
        path.moveTo(x, y);
        startX = x;
        startY = y;
        lastCx = x;
        lastCy = y;
        // Further pairs after a move are lines.
        command = relative ? 'l' : 'L';
      case 'L':
        x = next() + dx;
        y = next() + dy;
        path.lineTo(x, y);
        lastCx = x;
        lastCy = y;
      case 'H':
        x = next() + dx;
        path.lineTo(x, y);
        lastCx = x;
        lastCy = y;
      case 'V':
        y = next() + dy;
        path.lineTo(x, y);
        lastCx = x;
        lastCy = y;
      case 'C':
        final x1 = next() + dx;
        final y1 = next() + dy;
        final x2 = next() + dx;
        final y2 = next() + dy;
        x = next() + dx;
        y = next() + dy;
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastCx = x2;
        lastCy = y2;
      case 'S':
        final x1 = 2 * x - lastCx;
        final y1 = 2 * y - lastCy;
        final x2 = next() + dx;
        final y2 = next() + dy;
        x = next() + dx;
        y = next() + dy;
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastCx = x2;
        lastCy = y2;
      case 'A':
        final rx = next();
        final ry = next();
        final rotation = next();
        final largeArc = next() != 0;
        final clockwise = next() != 0;
        x = next() + dx;
        y = next() + dy;
        path.arcToPoint(
          Offset(x, y),
          radius: Radius.elliptical(rx, ry),
          rotation: rotation,
          largeArc: largeArc,
          clockwise: clockwise,
        );
        lastCx = x;
        lastCy = y;
      case 'Z':
        path.close();
        x = startX;
        y = startY;
        lastCx = x;
        lastCy = y;
        // A close takes no arguments; a number after one would never be
        // consumed.
        if (i < tokens.length && !isCommand(tokens[i])) {
          throw FormatException('Number after Z at token $i');
        }
      default:
        throw FormatException('Unsupported SVG path command "$command"');
    }
  }
  return path;
});
