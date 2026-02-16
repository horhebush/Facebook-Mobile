import 'dart:io';

import 'package:image/image.dart' as img;

/// Generates assets/launcher/icon.png - a 1024x1024 paw icon in Pawbook orange.
/// Run from project root: dart run tool/generate_paw_icon.dart
void main() {
  const int size = 1024;
  const int cx = size ~/ 2;
  // Pawbook brand: FB_PRIMARY #FF8C42, FB_LIGHT_PRIMARY #FFF4E6
  const int rOrange = 255, gOrange = 140, bOrange = 66;
  const int rCream = 255, gCream = 244, bCream = 230;

  final im = img.Image(width: size, height: size, numChannels: 4);
  im.clear(im.getColor(rCream, gCream, bCream, 255));

  final orange = im.getColor(rOrange, gOrange, bOrange, 255);

  // Main pad (bottom center)
  img.fillCircle(im, x: cx, y: 620, radius: 220, color: orange, antialias: true);
  // Toe beans (four circles above)
  img.fillCircle(im, x: 380, y: 380, radius: 95, color: orange, antialias: true);
  img.fillCircle(im, x: cx, y: 320, radius: 95, color: orange, antialias: true);
  img.fillCircle(im, x: 644, y: 380, radius: 95, color: orange, antialias: true);
  img.fillCircle(im, x: 440, y: 460, radius: 75, color: orange, antialias: true);
  img.fillCircle(im, x: 584, y: 460, radius: 75, color: orange, antialias: true);

  final outDir = Directory('assets/launcher');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  final outFile = File('assets/launcher/icon.png');
  outFile.writeAsBytesSync(img.encodePng(im));
  print('Generated ${outFile.path}');
}
