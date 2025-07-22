import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:load_pilot/models/load.dart';

class LoadListScreen extends StatefulWidget {
  const LoadListScreen({super.key});

  @override
  State<LoadListScreen> createState() => _LoadListScreenState();
}

class _LoadListScreenState extends State<LoadListScreen> {
  late Box<Load> box;
  final List<Color> statusColors = [
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    box = Hive.box<Load>('loads');
  }

  void _addNewLoad() {
    final truckNumberController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Add New Truck"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: truckNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Truck Number',
                      hintText: 'Enter truck number',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Enter notes here',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  truckNumberController.dispose();
                  notesController.dispose();
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final truckNumber = truckNumberController.text.trim();
                  final notes = notesController.text.trim();
                  if (truckNumber.isNotEmpty) {
                    final newLoad = Load(
                      truckNumber: truckNumber,
                      notes: notes,
                    );
                    await box.add(newLoad);
                  }
                  truckNumberController.dispose();
                  notesController.dispose();
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _editNotes(Load load) {
    final controller = TextEditingController(text: load.notes ?? '');
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Notes for ${load.truckNumber}'),
            content: TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Enter notes here'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  load.notes = controller.text;
                  await load.save();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _toggleAlert(Load load) async {
    load.alertShown = !load.alertShown;
    await load.save();
  }

  void _changeColor(Load load, Color newColor) async {
    load.color = newColor;
    await load.save();
  }

  Future<void> _confirmAndDeleteLoad(Load load) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete truck "${load.truckNumber}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Ne briši
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(context).pop(true), // Potvrdi brisanje
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      await load.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚚 Load Pilot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Truck',
            onPressed: _addNewLoad,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<Load> b, __) {
          if (b.isEmpty) {
            return const Center(child: Text('No trucks added.'));
          }

          // Izvući sve loadove i sortirati ih numerički po truckNumber
          final loads = b.values.toList();
          loads.sort((a, b) {
            final aNum = int.tryParse(a.truckNumber) ?? 0;
            final bNum = int.tryParse(b.truckNumber) ?? 0;
            return aNum.compareTo(bNum);
          });

          return ListView.builder(
            itemCount: loads.length,
            itemBuilder: (_, i) {
              final load = loads[i];
              return Card(
                color: load.color.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        load.truckNumber,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Notes: ${load.notes?.isEmpty ?? true ? "None" : load.notes}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Alert: ${load.alertShown ? "🔔 ACTIVE" : "🔕 Inactive"}',
                        style: TextStyle(
                          color:
                              load.alertShown ? Colors.red : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children:
                                statusColors.map((color) {
                                  return GestureDetector(
                                    onTap: () => _changeColor(load, color),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color:
                                              load.color == color
                                                  ? Colors.black
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_note),
                                tooltip: 'Edit Notes',
                                onPressed: () => _editNotes(load),
                              ),
                              IconButton(
                                icon: Icon(
                                  load.alertShown
                                      ? Icons.notifications_active
                                      : Icons.notifications_off,
                                ),
                                tooltip: 'Toggle Alert',
                                onPressed: () => _toggleAlert(load),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete Truck',
                                onPressed: () => _confirmAndDeleteLoad(load),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
