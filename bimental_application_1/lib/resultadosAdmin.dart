import 'package:flutter/material.dart';
import 'AnswersUser.dart';
// import 'ManageAnswers.dart';
import 'UserRepository.dart';
import 'User.dart';
import 'AnswersRepository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resultados Usuarios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserResultsPage(),
    );
  }
}

class UserResultsPage extends StatefulWidget {
  @override
  _UserResultsPageState createState() => _UserResultsPageState();
}

class _UserResultsPageState extends State<UserResultsPage> {
  List<Map<String, String>> filteredData = [];
  List<User> users = [];
  String selectedCriterion = 'Depresión';
  String selectedValue = 'Extremadamente severa';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    users = UserRepository.instance.users;
    List<AnswersUser> respuestasGuardadas = AnswersRepository.getAnswers();

    filteredData = respuestasGuardadas.map((entry) {
      User user = users.firstWhere(
        (u) => u.id == entry.userId,
        orElse: () => User('', 'Desconocido', 'N/A', '', 'N/A'),
      );

      // Clasificar los puntajes almacenados en AnswersUser
      String clasificacionDepresion = _clasificarDepresion(entry.p_depresion);
      String clasificacionAnsiedad = _clasificarAnsiedad(entry.p_ansiedad);
      String clasificacionEstres = _clasificarEstres(entry.p_estres);

      return {
        'Nombre': user.name,
        'Correo': user.email,
        'Teléfono': user.phone,
        'Fecha': entry.timestamp.split(' ')[0],
        'Depresión': clasificacionDepresion,
        'Ansiedad': clasificacionAnsiedad,
        'Estrés': clasificacionEstres,
      };
    }).toList();

    setState(() {});
  }

  // Funciones para clasificar los puntajes
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label:
                        Text('Nombre', style: TextStyle(color: Colors.white))),
                DataColumn(
                    label:
                        Text('Correo', style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text('Teléfono',
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label:
                        Text('Fecha', style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text('Depresión',
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text('Ansiedad',
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label:
                        Text('Estrés', style: TextStyle(color: Colors.white))),
              ],
              rows: filteredData.map((user) {
                return DataRow(cells: [
                  DataCell(Text(user['Nombre']!,
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
                ]);
              }).toList(),
              headingRowColor: MaterialStateProperty.all(Colors.green),
              dataRowColor: MaterialStateProperty.all(Color(0xFF1A119B)),
            ),
          ),
        ),
      ),
    );
  }
}
