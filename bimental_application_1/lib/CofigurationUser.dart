import 'package:flutter/material.dart';

// Lista para almacenar temporalmente los datos modificados
Map<String, String> datosUsuario = {
  'nombres': 'Nombre por defecto',
  'apellidos': 'Apellido por defecto',
  'telefono': 'Número por defecto',
};

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
      home: ConfiguracionScreen(),
    );
  }
}

class ConfiguracionScreen extends StatefulWidget {
  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _isDarkModeEnabled = false;

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
            SizedBox(height: 20),
            // Mostrar datos actuales
            Text(
              'Datos actuales:',
              style: TextStyle(color: Color(0xFF1A119B)),
            ),
            Text(
              'Nombres: ${datosUsuario['nombres']}',
              style: TextStyle(color: Color(0xFF1A119B)),
            ),
            Text(
              'Apellidos: ${datosUsuario['apellidos']}',
              style: TextStyle(color: Color(0xFF1A119B)),
            ),
            Text(
              'Teléfono: ${datosUsuario['telefono']}',
              style: TextStyle(color: Color(0xFF1A119B)),
            ),
          ],
        ),
      ),
    );
  }
}

class CambiarDatosScreen extends StatelessWidget {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cambiar Datos',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                labelText: 'Nombre',
                hintText: datosUsuario['nombres'],
              ),
            ),
            SizedBox(height: 10),
            // TextField(
            //   controller: _apellidosController,
            //   decoration: InputDecoration(
            //     labelText: 'Apellidos',
            //     hintText: datosUsuario['apellidos'],
            //   ),
            // ),
            SizedBox(height: 16),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(
                labelText: 'Numero telefonico',
                hintText: datosUsuario['telefono'],
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar cambios
                datosUsuario['nombres'] = (_nombresController.text.isNotEmpty
                    ? _nombresController.text
                    : datosUsuario['nombres'])!;
                datosUsuario['telefono'] = (_telefonoController.text.isNotEmpty
                    ? _telefonoController.text
                    : datosUsuario['telefono'])!;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cambios realizados con éxito')),
                );

                Navigator.pop(context);
              },
              child: Text(
                'Realizar cambios',
                style: TextStyle(color: Colors.white),
              ),
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
