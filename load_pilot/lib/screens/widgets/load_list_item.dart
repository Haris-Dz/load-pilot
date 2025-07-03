import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:load_pilot/models/load.dart';

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
    if (load.driverName.isEmpty ||
        load.pickupLocation.isEmpty ||
        load.pickupTime == null) {
      // fallback UI za nevalidan load
      return ListTile(
        title: const Text('Invalid load data'),
        subtitle: const Text('Driver or pickup time missing'),
        tileColor: Colors.red.withOpacity(0.2),
      );
    }

    final remain = load.pickupTime!.difference(DateTime.now());

    final trackingIcon =
        load.trackingAccepted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red);

    return ListTile(
      key: ValueKey(load.key),
      tileColor: load.alertShown ? Colors.green.withOpacity(0.1) : null,
      title: Text('${load.driverName} → ${load.pickupLocation}'),
      subtitle: Text(
        '${DateFormat('MMM d, HH:mm').format(load.pickupTime!)}'
        ' • ${remain.inHours}h ${remain.inMinutes.remainder(60)}m left\n'
        'Status: ${load.status ?? "Awaiting Pickup"}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          trackingIcon,
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: onEditNotes,
            tooltip: 'Edit Notes',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Edit Load',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
            tooltip: 'Delete Load',
          ),
        ],
      ),
    );
  }
}
