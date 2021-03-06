import 'dart:io';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}

String generateId({String text}) {
  var uuid = Uuid();
  if (text != null) {
    return uuid.v5(Uuid.NAMESPACE_URL, text);
  }
  return uuid.v4();
}

List<String> _nGram(String data) {
  List<String> grams = List<String>();
  for (var index = 0; index < data.length; index++) {
    grams.add(data.substring(0, index + 1));
  }
  return grams;
}

List<String> nGram(String data) {
  return _nGram(data.toLowerCase().split(" ").join(""));
}

List<String> _trigramNGram(String data) {
  List<String> grams = [];
  int currentIndex = 0;
  if (data.length > 3) {
    currentIndex = 4;
    grams.add(data.substring(0, 4));
  }
  while (currentIndex < data.length) {
    grams.add(data.substring(0, currentIndex));
    currentIndex++;
  }
  return grams;
}

List<String> trigramNGram(String data) {
  return _trigramNGram(data.toLowerCase().split(" ").join(""));
}

Future<Uint8List> compressImage(File file) async {
  var result;
  if (file.lengthSync() > 5000000) {
    result =
        FlutterImageCompress.compressWithFile(file.absolute.path, quality: 80);
  } else {
    result = file.readAsBytesSync();
  }
  return result;
}
