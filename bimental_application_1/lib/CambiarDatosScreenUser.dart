import 'package:flutter/material.dart';
import 'UserRepository.dart'; // Importar UserRepository

class CambiarDatosScreenUser extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  CambiarDatosScreenUser({Key? key}) : super(key: key);

  void actualizarDatos(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final UserRepository userRepository = UserRepository();

      // Solo actualizar los campos que no estén vacíos
      Map<String, String> nuevosDatos = {};

      if (_nombresController.text.isNotEmpty) {
        nuevosDatos["nombres"] = _nombresController.text;
      }
      if (_apellidosController.text.isNotEmpty) {
        nuevosDatos["apellidos"] = _apellidosController.text;
      }
      if (_emailController.text.isNotEmpty) {
        nuevosDatos["email"] = _emailController.text;
      }
      if (_telefonoController.text.isNotEmpty) {
        nuevosDatos["telefono"] = _telefonoController.text;
      }

      if (nuevosDatos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No ingresaste ningún dato para actualizar'),
          ),
        );
        return;
      }

      bool success = await userRepository.updateUserDataMap(nuevosDatos);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados correctamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar los datos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Actualizar Datos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A119B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nombresController,
                style: const TextStyle(color: Color(0xFF1A119B)),
                decoration: const InputDecoration(
                  labelText: 'Nombre (opcional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                cursorColor: const Color(0xFF1A119B),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _apellidosController,
                style: const TextStyle(color: Color(0xFF1A119B)),
                decoration: const InputDecoration(
                  labelText: 'Apellido (opcional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                cursorColor: const Color(0xFF1A119B),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Color(0xFF1A119B)),
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico (opcional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                cursorColor: const Color(0xFF1A119B),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, ingrese un correo válido';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _telefonoController,
                style: const TextStyle(color: Color(0xFF1A119B)),
                decoration: const InputDecoration(
                  labelText: 'Número telefónico (opcional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                cursorColor: const Color(0xFF1A119B),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => actualizarDatos(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A119B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Actualizar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
