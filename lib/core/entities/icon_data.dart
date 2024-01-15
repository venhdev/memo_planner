import 'dart:convert';

import 'package:flutter/widgets.dart';

class IconDataModel extends IconData {
  const IconDataModel(
    super.codePoint, {
    super.fontFamily,
    super.fontPackage,
    super.matchTextDirection,
    super.fontFamilyFallback,
  });

  factory IconDataModel.fromIconData(IconData iconData) {
    return IconDataModel(
      iconData.codePoint,
      fontFamily: iconData.fontFamily,
      fontPackage: iconData.fontPackage,
      matchTextDirection: iconData.matchTextDirection,
      fontFamilyFallback: iconData.fontFamilyFallback,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codePoint': codePoint,
      'fontFamily': fontFamily,
      'fontPackage': fontPackage,
      'matchTextDirection': matchTextDirection,
      'fontFamilyFallback': fontFamilyFallback,
    };
  }

  factory IconDataModel.fromMap(Map<String, dynamic> map) {
    return IconDataModel(
      map['codePoint'] as int,
      fontFamily: map['fontFamily'] != null ? map['fontFamily'] as String : null,
      fontPackage: map['fontPackage'] != null ? map['fontPackage'] as String : null,
      matchTextDirection: map['matchTextDirection'] as bool,
      fontFamilyFallback: map['fontFamilyFallback'] != null
          ? (map['fontFamilyFallback'] as List<dynamic>).map((e) => e as String).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IconDataModel.fromJson(String source) => IconDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
