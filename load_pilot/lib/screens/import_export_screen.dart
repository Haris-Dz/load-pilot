import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:load_pilot/models/load.dart';

class ImportExportScreen extends StatefulWidget {
  const ImportExportScreen({super.key});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen> {
  late Box<Load> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Load>('loads');
  }

  Future<void> exportHiveBox() async {
    final boxFilePath = box.path;

    if (boxFilePath == null) {
      _showMessage('Error: Could not find Hive box file path');
      return;
    }

    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save LoadPilot data',
      fileName: 'loads_backup.hive',
    );

    if (savePath == null) return; // User cancelled

    try {
      final sourceFile = File(boxFilePath);
      final destinationFile = File(savePath);
      await sourceFile.copy(destinationFile.path);
      _showMessage('Exported to: $savePath');
    } catch (e) {
      _showMessage('Export failed: $e');
    }
  }

  Future<void> importHiveBox() async {
    final boxFilePath = box.path;

    if (boxFilePath == null) {
      _showMessage('Error: Could not find Hive box file path');
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select LoadPilot data file',
      type: FileType.custom,
      allowedExtensions: ['hive'],
    );

    if (result == null || result.files.isEmpty) return;

    try {
      final selectedFilePath = result.files.single.path!;
      final selectedFile = File(selectedFilePath);
      final localBoxFile = File(boxFilePath);

      await box.close(); // Close before replacing

      await selectedFile.copy(localBoxFile.path);

      await Hive.openBox<Load>('loads'); // Reopen box

      setState(() {}); // Refresh UI

      _showMessage('Imported from: $selectedFilePath');
    } catch (e) {
      _showMessage('Import failed: $e');
    }
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import / Export Data')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export Data'),
              onPressed: exportHiveBox,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Import Data'),
              onPressed: importHiveBox,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
