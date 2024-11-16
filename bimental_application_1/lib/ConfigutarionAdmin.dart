import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ConfiguracionAdministracionScreen(),
    );
  }
}

class ConfiguracionAdministracionScreen extends StatefulWidget {
  @override
  _ConfiguracionAdministracionScreenState createState() =>
      _ConfiguracionAdministracionScreenState();
}

class _ConfiguracionAdministracionScreenState
    extends State<ConfiguracionAdministracionScreen> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración administración'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Acción para volver atrás
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
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: _isDarkModeEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkModeEnabled = value;
                    });
                  },
                  activeColor: Colors.green,
                  activeTrackColor: const Color(0xFF1A119B),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CambiarDatosScreen(),
                  ),
                );
              },
              child: Text('Cambiar Datos'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A119B)),
            ),
          ],
        ),
      ),
    );
  }
}

class CambiarDatosScreen extends StatelessWidget {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Datos administrativos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Acción para volver atrás
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombresController,
              decoration: InputDecoration(
                labelText: 'Nombres',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _apellidosController,
              decoration: InputDecoration(
                labelText: 'Apellidos',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(
                labelText: 'Numero telefonico',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar cambios
                // Ejemplo de manejo de datos:
                String nombres = _nombresController.text;
                String apellidos = _apellidosController.text;
                String telefono = _telefonoController.text;

                print('Datos guardados: $nombres $apellidos $telefono');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cambios realizados con éxito')),
                );
              },
              child: Text('Realizar cambios'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A119B)),
            ),
          ],
        ),
      ),
    );
  }
}
