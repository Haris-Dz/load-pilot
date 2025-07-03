import 'package:hive/hive.dart';

part 'load.g.dart';

@HiveType(typeId: 0)
class Load extends HiveObject {
  @HiveField(0)
  String driverName;

  @HiveField(1)
  String pickupLocation;

  @HiveField(2)
  DateTime pickupTime;

  @HiveField(3)
  String? status; // ← ovo

  @HiveField(4)
  bool trackingAccepted;

  @HiveField(5)
  String? notes; // ← ovo

  @HiveField(6)
  bool alertShown;

  Load({
    required this.driverName,
    required this.pickupLocation,
    required this.pickupTime,
    this.status = "Awaiting Pickup",
    this.trackingAccepted = false,
    this.notes = '',
    this.alertShown = false,
  });
}
