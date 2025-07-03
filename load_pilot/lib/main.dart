import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:load_pilot/services/notifications_service.dart';
import 'models/load.dart';
import 'screens/load_list_screen.dart';
import 'package:window_size/window_size.dart';
import 'dart:ui';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(600, 800));
  }

  await Hive.initFlutter();
  Hive.registerAdapter(LoadAdapter());
  await Hive.openBox<Load>('loads');

  await NotificationService.init();

  runApp(const LoadPilotApp());
}

class LoadPilotApp extends StatelessWidget {
  const LoadPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoadPilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const LoadListScreen(),
    );
  }
}
