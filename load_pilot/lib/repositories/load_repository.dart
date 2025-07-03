import 'package:hive/hive.dart';
import 'package:load_pilot/models/load.dart';
import 'package:load_pilot/services/notifications_service.dart';

class LoadRepository {
  final Box<Load> box;

  LoadRepository(this.box);

  List<Load> getAll() => box.values.toList();

  Future<void> add(Load load) async {
    await box.add(load);
  }

  Future<void> delete(Load load) async {
    await load.delete();
  }

  Future<void> save(Load load) async {
    await load.save();
  }

  Future<void> checkPickupAlerts() async {
    final now = DateTime.now();
    for (final load in box.values) {
      final diff = load.pickupTime.difference(now);
      if (diff.inMinutes > 0 && diff.inMinutes <= 60 && !load.alertShown) {
        await NotificationService.showPickupAlert(load);
        load.alertShown = true;
        await load.save();
      }
    }
  }
}
