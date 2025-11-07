import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'UserRepository.dart';
import 'session_service.dart';

class CambiarDatosScreenUser extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  CambiarDatosScreenUser({Key? key}) : super(key: key);

  void actualizarDatos(BuildContext context) async {
    // Validaciones solo si el usuario escribió algo
    final String emailInput = _emailController.text.trim();
    final String telefonoInput = _telefonoController.text.trim();

    if (emailInput.isNotEmpty) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(emailInput)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingrese un correo válido')),
        );
        return;
      }
    }

    if (telefonoInput.isNotEmpty) {
      final phoneRegex = RegExp(r'^\+?\d{6,15}$');
      if (!phoneRegex.hasMatch(telefonoInput)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor, ingrese un número telefónico válido')),
        );
        return;
      }
    }

    final UserRepository userRepository = UserRepository();

    Map<String, dynamic> nuevosDatos = {};

    // Ajusta las keys según tu Firestore ('name', 'lastName', 'phone' en este ejemplo)
    if (_nombresController.text.trim().isNotEmpty) {
      nuevosDatos["name"] = _nombresController.text.trim();
    }
    if (_apellidosController.text.trim().isNotEmpty) {
      nuevosDatos["lastName"] = _apellidosController.text.trim();
    }
    if (emailInput.isNotEmpty) {
      nuevosDatos["email"] = emailInput;
    }
    if (telefonoInput.isNotEmpty) {
      nuevosDatos["phone"] = telefonoInput;
    }

    // Añadir identificador del usuario desde SessionService si no fue enviado
    final sessionId = await SessionService.getUserId();
    final sessionEmail = await SessionService.getUserEmail();
    final fb_auth.User? firebaseUser =
        fb_auth.FirebaseAuth.instance.currentUser;

    if (!nuevosDatos.containsKey("email")) {
      if (sessionEmail != null && sessionEmail.isNotEmpty) {
        nuevosDatos["email"] = sessionEmail;
      } else if (firebaseUser?.email != null) {
        nuevosDatos["email"] = firebaseUser!.email!;
      }
    }

    // Añadir uid (id) preferiblemente desde sesión, si no desde firebaseUser
    if (!nuevosDatos.containsKey("uid")) {
      if (sessionId != null && sessionId.isNotEmpty) {
        nuevosDatos["uid"] = sessionId;
      } else if (firebaseUser?.uid != null) {
        nuevosDatos["uid"] = firebaseUser!.uid;
      }
    }

    if (!nuevosDatos.containsKey("email") && !nuevosDatos.containsKey("uid")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No se pudo identificar el usuario. Por favor inicie sesión.'),
        ),
      );
      return;
    }

    // Si el único dato enviado es el identificador (sin cambios reales), avisar y salir
    final dataToUpdate = Map<String, dynamic>.from(nuevosDatos)
      ..remove('email')
      ..remove('uid');
    if (dataToUpdate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No ingresaste ningún dato para actualizar')),
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
