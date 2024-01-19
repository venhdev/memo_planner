import 'dart:convert';

import 'package:flutter/widgets.dart';

class IconDataEntity {
  final int codePoint;
  final String? fontFamily;
  final String? fontPackage;
  final bool matchTextDirection;
  final List<String>? fontFamilyFallback;

  const IconDataEntity(
    this.codePoint, {
    this.fontFamily,
    this.fontPackage,
    this.matchTextDirection = false,
    this.fontFamilyFallback,
  });

  factory IconDataEntity.fromIconData(IconData iconData) {
    return IconDataEntity(
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

  factory IconDataEntity.fromMap(Map<String, dynamic> map) {
    return IconDataEntity(
      map['codePoint'] as int,
      fontFamily: map['fontFamily'] != null ? map['fontFamily'] as String : null,
      fontPackage: map['fontPackage'] != null ? map['fontPackage'] as String : null,
      matchTextDirection: map['matchTextDirection'] as bool,
      fontFamilyFallback: map['fontFamilyFallback'] != null
          ? (map['fontFamilyFallback'] as List<dynamic>).map((e) => e as String).toList()
          : null,
    );
  }

  IconData toIconData() {
    return IconData(
      codePoint,
      fontFamily: fontFamily,
      fontPackage: fontPackage,
      matchTextDirection: matchTextDirection,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  String toJson() => json.encode(toMap());

  factory IconDataEntity.fromJson(String source) => IconDataEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
