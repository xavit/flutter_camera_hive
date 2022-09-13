// To parse this JSON data, do
//
//     final imageData = imageDataFromJson(jsonString);

import 'dart:convert';

ImageData imageDataFromJson(String str) => ImageData.fromJson(json.decode(str));

String imageDataToJson(ImageData data) => json.encode(data.toJson());

class ImageData {
  ImageData({
    required this.imagen,
    required this.descripcion,
  });

  String imagen;
  String descripcion;

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        imagen: json["imagen"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "imagen": imagen,
        "descripcion": descripcion,
      };
}
