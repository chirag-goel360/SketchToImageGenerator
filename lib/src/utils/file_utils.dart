import 'dart:io';

import 'package:humangenerator/src/utils/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

Future<ShipsyFileData> getSingleFileFromPicker({
  List<String> allowedExtensions: const [],
}) async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: allowedExtensions,
      type: allowedExtensions != null ? FileType.custom : FileType.any);

  if (result != null) {
    PlatformFile platformFile = result.files.single;
    File file = File(platformFile.path);
    return ShipsyFileData(
      name: platformFile.name,
      fileExtension: platformFile.extension,
      file: file,
    );
  } else {
    return null;
  }
}

class ShipsyFileData {
  String name;
  String fileExtension;
  File file;

  ShipsyFileData({
    @required this.name,
    @required this.fileExtension,
    @required this.file,
  });

  String getType() {
    return !isEmptyStringOrNull(fileExtension) &&
            FileExtensions.FILE_TYPE.containsKey(fileExtension)
        ? FileExtensions.FILE_TYPE[fileExtension]
        : null;
  }
}

class FileExtensions {
  FileExtensions._();

  static const String JPG = 'jpg';
  static const String JPEG = 'jpeg';
  static const String PNG = 'png';
  static const String PDF = 'pdf';
  static const String DOC = 'doc';
  static const String DOCX = 'docx';
  static const String XLS = 'xls';
  static const String XLSX = 'xlsx';
  static const String CSV = 'csv';

  static const Map<String, String> DATA_HEADERS = {
    JPG: 'image/*',
    JPEG: 'image/*',
    PNG: 'image/*',
    PDF: 'application/*',
    DOC: 'application/*',
    DOCX: 'application/*',
    XLS: 'application/*',
    XLSX: 'application/*',
    CSV: 'text/csv',
  };

  static const Map<String, String> FILE_TYPE = {
    JPG: 'image/jpg',
    JPEG: 'image/jpeg',
    PNG: 'image/png',
    PDF: 'application/pdf',
    DOC: 'application/doc',
    DOCX: 'application/docx',
    XLS: 'application/xls',
    XLSX: 'application/xlsx',
    CSV: 'text/csv',
  };
}

// ignore: non_constant_identifier_names
List<String> ALLOWED_FILE_EXTENSIONS = [
  "pdf",
  "png",
  "xls",
  "xlsx",
  "jpeg",
  "jpg",
  "csv",
  "doc",
  "docx"
];
