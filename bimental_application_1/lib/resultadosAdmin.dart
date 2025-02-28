import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserResultsPage(),
    );
  }
}

class UserResultsPage extends StatefulWidget {
  @override
  _UserResultsPageState createState() => _UserResultsPageState();
}

class _UserResultsPageState extends State<UserResultsPage> {
  List<Map<String, String>> userData = [
    {
      'Nombre': 'Juan',
      'Depresión': 'Alto',
      'Ansiedad': 'Medio',
      'Estrés': 'Medio',
      'Teléfono': '999999959',
      'Correo': 'juan123...',
      'Fecha': '11/11/24',
    },
    {
      'Nombre': 'Bemjamin',
      'Depresión': 'Bajo',
      'Ansiedad': 'Medio',
      'Estrés': 'Medio',
      'Teléfono': '979999959',
      'Correo': 'bemjami...',
      'Fecha': '10/11/24',
    },
    {
      'Nombre': 'Jose',
      'Depresión': 'Medio',
      'Ansiedad': 'Bajo',
      'Estrés': 'Medio',
      'Teléfono': '997999959',
      'Correo': 'josere@g...',
      'Fecha': '09/11/24',
    },
    // Agrega los demás datos de usuario aquí...
  ];

  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(userData);
  }

  void _filterData(String filterKey, String filterValue) {
    setState(() {
      filteredData = userData
          .where((user) =>
              user[filterKey]?.toLowerCase() == filterValue.toLowerCase())
          .toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String selectedCriterion =
            'Depresión'; // Campo por defecto para filtrar
        String selectedValue = 'Alto'; // Valor por defecto para filtrar

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
                  if (value != null) {
                    setState(() {
                      selectedCriterion = value;
                    });
                  }
                },
              ),
              DropdownButton<String>(
                value: selectedValue,
                items: ['Alto', 'Medio', 'Bajo']
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedValue = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _filterData(selectedCriterion, selectedValue);
                Navigator.of(context).pop();
              },
              child: Text('Aplicar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  filteredData =
                      List.from(userData); // Reiniciar a datos originales
                });
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
        title: Text(
          'Resultados Usuarios',
          style: TextStyle(color: Colors.white),
        ),
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
          color: Colors.blue.shade900,
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label:
                        Text('Nombre', style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text('Depresión',
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text('Ansiedad',
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label:
                        Text('Estrés', style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text('Teléfono',
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label:
                        Text('Correo', style: TextStyle(color: Colors.white))),
                DataColumn(
                    label:
                        Text('Fecha', style: TextStyle(color: Colors.white))),
              ],
              rows: filteredData.map((user) {
                return DataRow(cells: [
                  DataCell(Text(user['Nombre']!,
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(user['Depresión']!,
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(user['Ansiedad']!,
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(user['Estrés']!,
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(user['Teléfono']!,
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(user['Correo']!,
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(user['Fecha']!,
                      style: TextStyle(color: Colors.white))),
                ]);
              }).toList(),
              headingRowColor: MaterialStateProperty.all(Colors.green),
              dataRowColor: MaterialStateProperty.all(Colors.blue.shade700),
            ),
          ),
        ),
      ),
    );
  }
}
