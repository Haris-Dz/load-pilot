import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:load_pilot/models/load.dart';

class AddLoadDialog extends StatefulWidget {
  final Future<void> Function(Load) onSave;

  const AddLoadDialog({required this.onSave, super.key});

  @override
  State<AddLoadDialog> createState() => _AddLoadDialogState();
}

class _AddLoadDialogState extends State<AddLoadDialog> {
  final driverCtrl = TextEditingController();
  final locCtrl = TextEditingController();
  DateTime? pickup;

  @override
  void dispose() {
    driverCtrl.dispose();
    locCtrl.dispose();
    super.dispose();
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all fields and pick a pickup time'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add New Load'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: driverCtrl,
          decoration: const InputDecoration(labelText: 'Driver'),
        ),
        TextField(
          controller: locCtrl,
          decoration: const InputDecoration(labelText: 'Pickup Location'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          icon: const Icon(Icons.access_time),
          label: Text(
            pickup == null
                ? 'Pick Pickup Time'
                : DateFormat('MMM d, HH:mm').format(pickup!),
          ),
          onPressed: () async {
            final now = DateTime.now();
            final date = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: now,
              lastDate: now.add(const Duration(days: 30)),
            );
            if (date == null) return;

            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.input, // << ovdje
            );

            if (time == null) return;

            setState(() {
              pickup = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          },
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () async {
          if (driverCtrl.text.isEmpty ||
              locCtrl.text.isEmpty ||
              pickup == null) {
            _showValidationError();
            return;
          }

          final load = Load(
            driverName: driverCtrl.text,
            pickupLocation: locCtrl.text,
            pickupTime: pickup!,
          );

          await widget.onSave(load);

          // Dialog closing handled by parent
        },
        child: const Text('Save'),
      ),
    ],
  );
}
