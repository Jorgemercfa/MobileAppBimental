import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bimental_application_1/main.dart'; // ValueNotifier isDarkModeEnabled

class ConfiguracionAdministracionScreen extends StatefulWidget {
  @override
  _ConfiguracionAdministracionScreenState createState() =>
      _ConfiguracionAdministracionScreenState();
}

class _ConfiguracionAdministracionScreenState
    extends State<ConfiguracionAdministracionScreen> {
  bool recibirNotificaciones = false;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recibirNotificaciones = prefs.getBool('recibirNotificaciones') ?? false;
      isDarkModeEnabled.value = prefs.getBool('isDarkModeEnabled') ?? false;
    });
  }

  // Elimina métodos relacionados con Firebase Messaging y Firestore
  // Elimina _saveAdminToken y lógica de tokens

  void _toggleNotificaciones(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      recibirNotificaciones = value;
    });

    await prefs.setBool('recibirNotificaciones', value);

    // Simple feedback sin lógica de notificaciones push
    if (value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Opción de notificaciones activada (sin efecto)')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Opción de notificaciones desactivada (sin efecto)')),
      );
    }
  }

  void _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkModeEnabled.value = value;
    await prefs.setBool('isDarkModeEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeEnabled,
      builder: (context, isDark, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A119B),
            title: Text(
              'Configuración',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Activar tema oscuro',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Switch(
                      value: isDark,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        _toggleDarkMode(value);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recibir notificaciones',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Switch(
                      value: recibirNotificaciones,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        _toggleNotificaciones(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
