import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:load_pilot/models/load.dart';
import 'package:load_pilot/repositories/load_repository.dart';
import 'package:load_pilot/screens/dialogs/add_load_dialog.dart';
import 'package:load_pilot/screens/dialogs/edit_load_dialog.dart';

class LoadListScreen extends StatefulWidget {
  const LoadListScreen({super.key});

  @override
  State<LoadListScreen> createState() => _LoadListScreenState();
}

class _LoadListScreenState extends State<LoadListScreen> {
  late final LoadRepository repo;
  Timer? _alertTimer;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<Load>('loads');
    repo = LoadRepository(box);
    repo.checkPickupAlerts();
    _alertTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      repo.checkPickupAlerts();
    });
  }

  @override
  void dispose() {
    _alertTimer?.cancel();
    super.dispose();
  }

  Future<void> _onAddLoad() async {
    await showDialog(
      context: context,
      builder:
          (_) => AddLoadDialog(
            onSave: (load) async {
              await _addLoadAndCloseDialog(load);
            },
          ),
    );
  }

  Future<void> _onEditLoad(Load load) async {
    await showDialog(
      context: context,
      builder:
          (_) => EditLoadDialog(
            load: load,
            onSave: (updatedLoad) async {
              await _saveLoadAndCloseDialog(updatedLoad);
            },
          ),
    );
  }

  Future<void> _addLoadAndCloseDialog(Load load) async {
    try {
      await repo.add(load);
      if (mounted) {
        setState(() {});
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding load: $e')));
    }
  }

  Future<void> _saveLoadAndCloseDialog(Load load) async {
    try {
      await repo.save(load);
      if (mounted) {
        setState(() {});
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving load: $e')));
    }
  }

  void _onDeleteLoad(Load load) async {
    try {
      await repo.delete(load);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting load: $e')));
    }
  }

  void _onEditNotes(Load load) {
    final controller = TextEditingController(text: load.notes ?? '');
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Notes for ${load.driverName}'),
            content: TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Enter notes here'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.dispose();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  load.notes = controller.text;
                  await repo.save(load);
                  controller.dispose();
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Load>('loads');
    return Scaffold(
      appBar: AppBar(title: const Text('🚚 LoadPilot')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<Load> b, __) {
          if (b.isEmpty) {
            return const Center(child: Text('No loads added.'));
          }
          return ListView.builder(
            itemCount: b.length,
            itemBuilder: (_, i) {
              final load = b.getAt(i);
              if (load == null) return const SizedBox();
              return LoadListItem(
                load: load,
                onEdit: () => _onEditLoad(load),
                onDelete: () => _onDeleteLoad(load),
                onEditNotes: () => _onEditNotes(load),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddLoad,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LoadListItem extends StatelessWidget {
  final Load load;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onEditNotes;

  const LoadListItem({
    required this.load,
    required this.onEdit,
    required this.onDelete,
    required this.onEditNotes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final remain = load.pickupTime.difference(DateTime.now());
    final isTrackingOk = load.trackingAccepted;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: load.alertShown ? Colors.green.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(
          isTrackingOk ? Icons.check_circle : Icons.cancel,
          color: isTrackingOk ? Colors.green : Colors.red,
        ),
        title: Text('${load.driverName} → ${load.pickupLocation}'),
        subtitle: Text(
          '${load.pickupTime.toLocal().toString().substring(0, 16)} • '
          '${remain.inHours}h ${remain.inMinutes.remainder(60)}m left\n'
          'Status: ${load.status ?? "Awaiting Pickup"}\n'
          'Notes: ${load.notes?.isEmpty ?? true ? "None" : load.notes}',
        ),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.note),
              tooltip: 'Edit Notes',
              onPressed: onEditNotes,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Load',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Load',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
