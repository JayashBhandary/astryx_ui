/// Two single-path marks — the Astryx logo and the GitHub mark — drawn from
/// their SVG path data.
///
/// The docs app has no SVG renderer and does not need one for two glyphs: a
/// path parser that understands the commands these paths use (M L H V C S Q T A Z,
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

/// The Astryx wordmark, from upstream's hero. 1060×200.
const String astryxWordmarkPath =
    'M922.795 4.765c16.84 0 30.49 13.652 30.49 30.493v27.635c0 5.263 4.266 '
    '9.53 9.528 9.53h3.812c5.262 0 9.528-4.267 9.528-9.53V35.258c0-16.841 1'
    '3.651-30.493 30.487-30.493h41.93c6.31 0 11.43 5.12 11.43 11.435v41.928'
    'c0 16.841-13.65 30.494-30.49 30.494h-27.63a9.53 9.53 0 0 0-9.529 9.53v'
    '3.811a9.53 9.53 0 0 0 9.529 9.529h27.63c16.84 0 30.49 13.652 30.49 30.'
    '494v41.928c0 6.316-5.12 11.435-11.43 11.435h-41.93c-16.836 0-30.487-13'
    '.652-30.487-30.493v-27.635c0-5.263-4.266-9.529-9.528-9.529h-3.812c-5.2'
    '62 0-9.528 4.266-9.528 9.529v27.635c0 16.841-13.65 30.493-30.49 30.493'
    'h-41.923c-6.315 0-11.434-5.119-11.434-11.435v-41.928c0-16.842 13.651-3'
    '0.494 30.49-30.494h27.631a9.53 9.53 0 0 0 9.529-9.529v-3.812a9.53 9.53'
    ' 0 0 0-9.529-9.53h-27.631c-16.839 0-30.49-13.652-30.49-30.493V16.2c0-6'
    '.316 5.119-11.435 11.434-11.435zM629.077 4.765c21.406.02 39.667-.537 5'
    '5.799 17.583 10.073 11.209 15.638 26.392 15.434 42.144-.29 15.777-6.27'
    '5 30.78-16.628 41.716-10.19 10.795-21.342 14.899-33.75 16.227l43.237 5'
    '1.474c3.572 4.764 4.366 5.051 4.736 8.824a11.5 11.5 0 0 1-2.901 8.817 '
    '11.4 11.4 0 0 1-8.458 3.769l-47.399.03a11.4 11.4 0 0 1-8.583-3.894l-54'
    '.819-68.603h-23.02c.011 28.285.016 53.903-.031 60.772-.044 6.361-5.121'
    ' 11.505-11.391 11.539l-22.418.189a11.37 11.37 0 0 1-8.139-3.381 11.72 '
    '11.72 0 0 1-3.375-8.242V15.806a11.74 11.74 0 0 1 3.419-7.68 11.37 11.3'
    '7 0 0 1 8.179-3.36zM552.629 52.64v23.097h82.019c3.802-.026 6.817-.237 '
    '9.045-.712 11.675-2.49 11.363-13.083 7.462-17.506l-.005-.005c-2.175-2.'
    '01-3.876-2.976-5.517-3.571-1.772-.642-4.067-1.073-7.8-1.305zM344.404 6'
    '2.326c-6.19-46.735-57.672-77.63-102.465-54.442l-.015.008c-.281.14-.562'
    '.28-.808.42-8.657 4.638-15.563 12.06-19.605 20.978-8.111 21.836-3.556 '
    '42.18 26.22 60.047l33.081 19.244c3.84 2.196 7.413 5.77 9.096 10.883v.0'
    '05c1.89 6.686-4.065 16.323-15.213 11.43l-24.582-12.975c-9.528-4.764-15'
    '.752-10.365-23.415-11.057-18.731-1.372-22.682 9.866-21.787 20.833 5.88'
    '3 72.094 77.337 72.299 77.741 72.3 75.631 0 64.765-60.262 64.651-60.89'
    '4l-.001-.004c-1.779-12.039-10.236-23.56-19.764-29.516l-41.695-25.014c-'
    '5.955-3.573-10.719-7.147-13.101-13.103-2.914-7.285 5.955-16.676 17.865'
    '-10.72l19.825 11.444 13.523 7.614c7.146 3.574 11.766 1.022 14.652-1.57'
    ' 3.398-3.032 6.333-7.99 5.797-15.91M80.033 4.765c6.896 0 12.648 5.54 1'
    '4.638 13.2.027.032.028.094.028.126 1.827 6.931 6.787 13.293 13.001 13.'
    '8l.003-.002-.01-.005c.042.004.084 0 .126.003q.426-.007.835-.03c5.447-.'
    '642 12.683-9.747 18.391-15.958 3.026-3.07 8.453-7.722 14.832-9.431 10.'
    '276-2.659 26.081.821 34.558 8.766a75 75 0 0 1 2.152 2.121c14.501 15.06'
    '7 14.834 48.208 14.834 79.45v88.399c0 6.315-5.119 11.436-11.434 11.437'
    'h-25.25a30.34 30.34 0 0 1-16.267-4.709c-4.204-2.175-7.083-5.39-9.745-9'
    '.655q-2.74-4.416-4.58-9.688v.066c-6.575-18.393-19.433-.12-19.517 0v-.0'
    '96c-2.726 3.45-5.643 6.552-8.805 9.211-10.821 9.053-24.644 13.579-41.4'
    '08 13.579-19.49 0-31.799-4.527-41.639-13.579C4.936 172.717 0 159.233 0'
    ' 141.35q0-22.08 12.594-34.663c8.369-8.356 21.344-14.148 38.899-17.313l'
    '9.649-1.71c11.694-1.583 28.715-2.373 46.27-2.373 7.223 0 12.292-1.045 '
    '15.209-3.071 2.916-2.057 4.389-4.652 4.389-7.817 0-2.722-1.473-5.035-4'
    '.389-6.966-2.944-1.898-7.032-2.88-12.292-2.88H31.776c-8.341 0-23.467-6'
    '.705-29.422-29.336L0 22.3C0 12.617 6.76 4.766 15.102 4.766zm2.36 117.7'
    '7-15.02 5.956c-12.372 4.765-18.62 6.876-17.137 14.294 1.192 5.956 5.22'
    '8 10.483 16.675 7.147s22.629-8.338 30.966-11.912c7.698-3.299 24.345-10'
    '.083 28.461-19.896v-10.92zM756.477 8.492c-2.24-2.286-5.309-3.727-8.509'
    '-3.727h-21.094c-3.208 0-6.283 1.454-8.523 3.75a11.92 11.92 0 0 0-3.38 '
    '8.61l-.298 51.771c.007 7.926-.564 12.133 1.53 22.004a50 50 0 0 0 12.80'
    '1 24.449l.003-.002c10.111 9.72 26.738 9.198 33.092 11.73v56.335a11.91 '
    '11.91 0 0 0 12.1 11.921h21.251a11.91 11.91 0 0 0 12.101-11.921l-.042-5'
    '6.335c6.354-2.532 23.863-2.01 33.974-11.73l.002.002a50 50 0 0 0 12.802'
    '-24.45c2.094-9.87 1.523-14.077 1.53-22.003v-51.77c.078-3.208-1.8-6.315'
    '-4.039-8.611-2.241-2.296-5.316-3.75-8.523-3.75h-49.679c-3.2 0-6.269 1.'
    '441-8.509 3.727-2.239 2.286-2.117 5.382-2.053 8.582v56.754c-.232 3.734'
    '-.663 6.03-1.305 7.8-.595 1.642-1.56 3.344-3.57 5.52l-.005.004c-4.423 '
    '3.9-15.016 4.213-17.505-7.463-.28-1.316-.466-2.907-.579-4.772a89 89 0 '
    '0 1-.174-5.951V17.074a11.92 11.92 0 0 0-3.399-8.582M481.215 4.765a11.8'
    ' 11.8 0 0 1 8.479 3.594 12 12 0 0 1 3.38 8.022v22.687l.005.003c-.001 1'
    '6.84-13.651 30.493-30.49 30.493h-17.781v113.853a11.94 11.94 0 0 1-3.52'
    '9 8.491 11.79 11.79 0 0 1-8.491 3.423c-3.263-.053-16.174.009-19.842.01'
    '8l-.589-.014a11.7 11.7 0 0 1-3.998-.905l-.977-.411a11.89 11.89 0 0 1-7'
    '.058-8.736l-.077-.396-.002-.021c-.037-.191-.09-.461-.14-.761a18 18 0 0'
    ' 1-.228-2.051l-.021-.989V69.564h-16.827c-16.839 0-30.489-13.653-30.49-'
    '30.493l.005-.003V16.381a12 12 0 0 1 3.38-8.022 11.8 11.8 0 0 1 8.479-3'
    '.594z';

/// The wordmark's view box.
const Size astryxWordmarkViewBox = Size(1060, 200);

/// Paints a single-path wordmark at [height], keeping its aspect ratio.
class DocsSvgWordmark extends StatelessWidget {
  const DocsSvgWordmark({
    required this.color,
    this.path = astryxWordmarkPath,
    this.viewBox = astryxWordmarkViewBox,
    this.height = 40,
    this.semanticsLabel,
    super.key,
  });

  final String path;
  final Size viewBox;
  final Color color;
  final double height;

  /// Null leaves the mark out of the semantics tree.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final paint = CustomPaint(
      size: Size(height * viewBox.aspectRatio, height),
      painter: _WidePainter(parseSvgPath(path), viewBox, color),
    );
    if (semanticsLabel == null) return ExcludeSemantics(child: paint);
    return Semantics(label: semanticsLabel, image: true, child: paint);
  }
}

class _WidePainter extends CustomPainter {
  _WidePainter(this.path, this.viewBox, this.color);

  final Path path;
  final Size viewBox;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / viewBox.width, size.height / viewBox.height)
      ..drawPath(path, Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(_WidePainter old) =>
      old.color != color || old.viewBox != viewBox || old.path != path;
}

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
/// Supports M L H V C S Q T A Z in absolute and relative form, with implicit
/// repetition — what the two marks above use. Anything else throws, so a new
/// mark that needs more is found at once rather than drawn wrong.
Path parseSvgPath(String data) => _cache.putIfAbsent(data, () {
  final tokens = RegExp(
    r'[MmLlHhVvCcSsQqTtAaZz]|-?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?',
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
      case 'Q':
        final x1 = next() + dx;
        final y1 = next() + dy;
        x = next() + dx;
        y = next() + dy;
        path.quadraticBezierTo(x1, y1, x, y);
        lastCx = x1;
        lastCy = y1;
      case 'T':
        final x1 = 2 * x - lastCx;
        final y1 = 2 * y - lastCy;
        x = next() + dx;
        y = next() + dy;
        path.quadraticBezierTo(x1, y1, x, y);
        lastCx = x1;
        lastCy = y1;
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
