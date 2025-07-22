import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:load_pilot/layouts/master_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';

import 'models/load.dart';
import 'screens/load_list_screen.dart';
import 'services/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Window size config for desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // setWindowTitle('Load Pilot');
    // setWindowMinSize(const Size(1000, 700));
    // setWindowMaxSize(Size.infinite);
  }

  // Hive setup
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(LoadAdapter());
  //await Hive.deleteBoxFromDisk('loads');
  await Hive.openBox<Load>('loads');

  // Notifikacije
  //await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load Pilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MasterScreen(),
    );
  }
}
