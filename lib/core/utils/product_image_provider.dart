import 'dart:io';

import 'package:flutter/material.dart';

/// [imageRef] is either `assets/...` or an absolute device file path.
ImageProvider productImageProvider(String imageRef) {
  if (imageRef.startsWith('assets/')) {
    return AssetImage(imageRef);
  }
  return FileImage(File(imageRef));
}
