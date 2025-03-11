import 'package:flutter/material.dart';
import 'AnswersUser.dart';
import 'ManageAnswers.dart';
import 'UserRepository.dart';
import 'User.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    users = UserRepository.instance.users;
    List<AnswersUser> respuestasGuardadas = ManageAnswers.getAnswers();

    filteredData = respuestasGuardadas.map((entry) {
      // Usar firstWhere con orElse para manejar el caso en que no se encuentre un usuario
      User user = users.firstWhere(
        (u) => u.id == entry.id,
        orElse: () =>
            User('', 'Desconocido', 'N/A', '', 'N/A'), // Valor predeterminado
      );

      return {
        'Nombre': user.name,
        'Correo': user.email,
        'Teléfono': user.phone,
        'Fecha': entry.timestamp.split(' ')[0],
        'Depresión': calcularDepresion(entry.answers),
        'Ansiedad': calcularAnsiedad(entry.answers),
        'Estrés': calcularEstres(entry.answers),
      };
    }).toList();

    setState(() {});
  }

  String calcularDepresion(List<String> respuestas) {
    // Verificar que la lista tenga suficientes elementos
    if (respuestas.length < 21) {
      return 'Datos insuficientes para calcular depresión';
    }

    List<int> indices = [3, 5, 10, 13, 16, 17, 21];
    int suma = _calcularSuma(indices, respuestas);
    if (suma >= 14) return 'Extremadamente severa';
    if (suma >= 11) return 'Severa';
    if (suma >= 7) return 'Moderada';
    if (suma >= 5) return 'Leve';
    return 'Sin depresión';
  }

  String calcularAnsiedad(List<String> respuestas) {
    // Verificar que la lista tenga suficientes elementos
    if (respuestas.length < 20) {
      return 'Datos insuficientes para calcular ansiedad';
    }

    List<int> indices = [2, 4, 7, 9, 15, 19, 20];
    int suma = _calcularSuma(indices, respuestas);
    if (suma >= 10) return 'Extremadamente severa';
    if (suma >= 8) return 'Severa';
    if (suma >= 5) return 'Moderada';
    if (suma >= 4) return 'Leve';
    return 'Sin ansiedad';
  }

  String calcularEstres(List<String> respuestas) {
    // Verificar que la lista tenga suficientes elementos
    if (respuestas.length < 18) {
      return 'Datos insuficientes para calcular estrés';
    }

    List<int> indices = [1, 6, 8, 11, 12, 14, 18];
    int suma = _calcularSuma(indices, respuestas);
    if (suma >= 17) return 'Extremadamente severo';
    if (suma >= 13) return 'Severo';
    if (suma >= 10) return 'Moderado';
    if (suma >= 8) return 'Leve';
    return 'Sin estrés';
  }

  int _calcularSuma(List<int> indices, List<String> respuestas) {
    return indices.map((i) {
      // Verificar que el índice esté dentro del rango de la lista
      if (i - 1 < respuestas.length) {
        return int.tryParse(respuestas[i - 1]) ?? 0;
      } else {
        return 0; // Si el índice está fuera de rango, devolver 0
      }
    }).fold(0, (a, b) => a + b);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String selectedCriterion = 'Depresión';
        String selectedValue = 'Alto';

        return AlertDialog(
          title: Text('Seleccionar filtro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedCriterion,
                items: ['Depresión', 'Ansiedad', 'Estrés']
                    .map((criterion) => DropdownMenuItem(
                        value: criterion, child: Text(criterion)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCriterion = value ?? 'Depresión');
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
                    .map((value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedValue = value ?? 'Alto');
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
