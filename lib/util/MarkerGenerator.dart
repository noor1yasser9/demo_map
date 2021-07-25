import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';

class ImageCropper {
  Future<BitmapDescriptor> resizeAndCircle(String imageURL, int size) async {
    File imageFile = await _urlToFile(imageURL);
    Uint8List byteData = imageFile.readAsBytesSync();
    ui.Image image = await _resizeAndConvertImage(byteData, size, size);
    return _paintToCanvas(image, Size.zero);
  }

  Future<File> _urlToFile(String imageUrl) async {
    final rd = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath' + (rd.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<ui.Image> _resizeAndConvertImage(
      Uint8List data,
      int height,
      int width,
      ) async {
    img.Image baseSizeImage = img.decodeImage(data);
    img.Image resizeImage =
    img.copyResize(baseSizeImage, height: height, width: width);
    ui.Codec codec = await ui.instantiateImageCodec(img.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<BitmapDescriptor> _paintToCanvas(ui.Image image, Size size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint();
    paint.isAntiAlias = true;

    _performCircleCrop(image, size, canvas);

    final recordedPicture = pictureRecorder.endRecording();
    ui.Image img = await recordedPicture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(buffer);
  }

  Canvas _performCircleCrop(ui.Image image, Size size, Canvas canvas) {
    Paint paint = Paint();
    canvas.drawCircle(Offset(0, 0), 0, paint);

    double drawImageWidth = 0;
    double drawImageHeight = 0;

    Path path = Path()
      ..addOval(Rect.fromLTWH(drawImageWidth, drawImageHeight,
          image.width.toDouble(), image.height.toDouble()));

    canvas.clipPath(path);
    canvas.drawImage(image, Offset(drawImageWidth, drawImageHeight), Paint());
    return canvas;
  }
}