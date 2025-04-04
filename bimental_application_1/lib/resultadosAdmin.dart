import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AnswersUser.dart';
import 'UserRepository.dart';
import 'User.dart';
import 'AnswersRepository.dart';
import 'NotificationService.dart';

class UserResultsPage extends StatefulWidget {
  @override
  _UserResultsPageState createState() => _UserResultsPageState();
}

class _UserResultsPageState extends State<UserResultsPage> {
  List<Map<String, String>> filteredData = [];
  List<User> users = [];
  String selectedCriterion = 'Depresión';
  String selectedValue = 'Extremadamente severa';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool recibirNotificaciones =
        prefs.getBool('recibirNotificaciones') ?? false;

    if (recibirNotificaciones) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          NotificationService().showNotification(
            message.notification!.title ?? 'Nueva notificación',
            message.notification!.body ?? 'Tienes un nuevo mensaje',
          );
        }
      });
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    users = await UserRepository.instance.getUsers();
    List<AnswersUser> respuestasGuardadas =
        await AnswersRepository.getAllAnswersFromFirestore();

    filteredData = respuestasGuardadas.map((entry) {
      User user = users.firstWhere(
        (u) => u.id == entry.userId,
        orElse: () => User('', 'Desconocido', 'N/A', '', '', 'N/A'),
      );

      String clasificacionDepresion = _clasificarDepresion(entry.p_depresion);
      String clasificacionAnsiedad = _clasificarAnsiedad(entry.p_ansiedad);
      String clasificacionEstres = _clasificarEstres(entry.p_estres);

      _verificarNotificaciones(clasificacionDepresion, clasificacionAnsiedad,
          clasificacionEstres, user);

      return {
        'Nombre': user.name,
        'Apellido': user.lastName, // Nuevo campo añadido
        'Correo': user.email,
        'Teléfono': user.phone,
        'Fecha': entry.timestamp.split(' ')[0],
        'Depresión': clasificacionDepresion,
        'Ansiedad': clasificacionAnsiedad,
        'Estrés': clasificacionEstres,
      };
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  void _verificarNotificaciones(
      String depresion, String ansiedad, String estres, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool recibirNotificaciones =
        prefs.getBool('recibirNotificaciones') ?? false;

    if (recibirNotificaciones) {
      if (depresion == 'Extremadamente severa' || depresion == 'Severa') {
        NotificationService().showNotification(
          'Alerta de Depresión',
          '${user.name} ${user.lastName} tiene un nivel de depresión: $depresion', // Apellido añadido
        );
      }
      if (ansiedad == 'Extremadamente severa' || ansiedad == 'Severa') {
        NotificationService().showNotification(
          'Alerta de Ansiedad',
          '${user.name} ${user.lastName} tiene un nivel de ansiedad: $ansiedad', // Apellido añadido
        );
      }
      if (estres == 'Extremadamente severo' || estres == 'Severo') {
        NotificationService().showNotification(
          'Alerta de Estrés',
          '${user.name} ${user.lastName} tiene un nivel de estrés: $estres', // Apellido añadido
        );
      }
    }
  }

  String _clasificarDepresion(int score) {
    if (score >= 14) return 'Extremadamente severa';
    if (score >= 11) return 'Severa';
    if (score >= 7) return 'Moderada';
    if (score >= 5) return 'Leve';
    return 'Sin depresión';
  }

  String _clasificarAnsiedad(int score) {
    if (score >= 10) return 'Extremadamente severa';
    if (score >= 8) return 'Severa';
    if (score >= 5) return 'Moderada';
    if (score >= 4) return 'Leve';
    return 'Sin ansiedad';
  }

  String _clasificarEstres(int score) {
    if (score >= 17) return 'Extremadamente severo';
    if (score >= 13) return 'Severo';
    if (score >= 10) return 'Moderado';
    if (score >= 8) return 'Leve';
    return 'Sin estrés';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Seleccionar filtro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedCriterion,
                items: ['Depresión', 'Ansiedad', 'Estrés']
                    .map((criterion) => DropdownMenuItem(
                          value: criterion,
                          child: Text(criterion),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCriterion = value ?? 'Depresión';
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedValue,
                items: [
                  'Extremadamente severa',
                  'Severa',
                  'Moderada',
                  'Leve',
                  'Sin depresión',
                  'Sin ansiedad',
                  'Sin estrés'
                ]
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value ?? 'Extremadamente severa';
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  filteredData = filteredData
                      .where((user) => user[selectedCriterion] == selectedValue)
                      .toList();
                });
                Navigator.of(context).pop();
              },
              child: Text('Aplicar'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _loadUserData());
                Navigator.of(context).pop();
              },
              child: Text('Reiniciar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Resultados Usuarios', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A119B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF1A119B),
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                          Color(0xFF4CAF50)), // Color verde del encabezado
                      dataRowColor: MaterialStateProperty.all(Color(
                          0xFF1A119B)), // Color azul oscuro para las filas
                      columns: [
                        DataColumn(
                          label: Text('Nombre',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          // Nueva columna para el apellido
                          label: Text('Apellido',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Correo',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Teléfono',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Fecha',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Depresión',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Ansiedad',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Estrés',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                      rows: filteredData.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(Text(user['Nombre']!,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(
                                user[
                                    'Apellido']!, // Nueva celda para el apellido
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(user['Correo']!,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(user['Teléfono']!,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(user['Fecha']!,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(user['Depresión']!,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(user['Ansiedad']!,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(user['Estrés']!,
                                style: TextStyle(color: Colors.white))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
