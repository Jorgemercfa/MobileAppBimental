import 'package:bimental_application_1/main.dart';
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
  @override
  Widget build(BuildContext context) {
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
                    color: Color(0xFF1A119B),
                    fontSize: 16,
                  ),
                ),
                Switch(
                  value: isDarkModeEnabled.value,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isDarkModeEnabled.value = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CambiarDatosScreen(),
                    ),
                  );
                },
                child: Text(
                  'Cambiar Datos',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A119B),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
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
        backgroundColor: const Color(0xFF1A119B),
        title: Text(
          'Cambiar Datos',
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
                labelText: 'Número telefónico',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String nombres = _nombresController.text;
                String apellidos = _apellidosController.text;
                String telefono = _telefonoController.text;

                print('Datos guardados: $nombres $apellidos $telefono');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cambios realizados con éxito')),
                );
              },
              child: Text('Realizar cambios',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A119B),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
