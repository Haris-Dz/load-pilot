import 'package:flutter/material.dart';
import 'package:load_pilot/screens/import_export_screen.dart';
import 'package:load_pilot/screens/load_list_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  String _currentScreen = 'Loads';

  Widget _getScreen() {
    switch (_currentScreen) {
      case 'Loads':
        return const LoadListScreen();
      case 'ImportExport':
        return const ImportExportScreen();
      case 'Placeholder':
        return const Center(child: Text('Placeholder Screen'));
      default:
        return const Center(child: Text('Unknown screen'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 65, 119),
      body: Row(
        children: [
          Container(
            width: 240,
            color: const Color.fromARGB(255, 2, 19, 36),
            child: Column(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/century.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSidebarItem('Loads', Icons.local_shipping, 'Loads'),
                _buildSidebarItem(
                  'ImportExport',
                  Icons.home_outlined,
                  'ImportExport',
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(_currentScreen),
                  backgroundColor: const Color.fromARGB(255, 5, 25, 49),
                  elevation: 0,
                ),
                Expanded(child: _getScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, String screenName) {
    final isSelected = _currentScreen == screenName;
    return Container(
      color: isSelected ? const Color(0xFF0D47A1) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape:
            isSelected
                ? const Border(left: BorderSide(color: Colors.white, width: 4))
                : null,
        onTap: () {
          setState(() {
            _currentScreen = screenName;
          });
        },
      ),
    );
  }
}
