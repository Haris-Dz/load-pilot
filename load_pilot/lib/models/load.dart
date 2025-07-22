import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'load.g.dart';

@HiveType(typeId: 0)
class Load extends HiveObject {
  @HiveField(0)
  String truckNumber;

  @HiveField(1)
  String? notes;

  @HiveField(2)
  bool alertShown;

  @HiveField(3)
  int colorValue; // Boja kao int

  Color get color => Color(colorValue);

  set color(Color newColor) => colorValue = newColor.value;

  Load({
    required this.truckNumber,
    this.notes = '',
    this.alertShown = false,
    this.colorValue = 0xFF4CAF50, // Default: zelena
  });
}
