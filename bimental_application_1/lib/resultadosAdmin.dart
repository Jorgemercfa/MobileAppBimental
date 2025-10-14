import 'package:flutter/material.dart';
import 'AnswersUser.dart';
import 'UserRepository.dart';
import 'User.dart';
import 'AnswersRepository.dart';

class UserResultsPage extends StatefulWidget {
  @override
  _UserResultsPageState createState() => _UserResultsPageState();
}

class _UserResultsPageState extends State<UserResultsPage> {
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];
  List<User> users = [];
  String selectedCriterion = 'Depresión';
  String selectedValue = 'Extremadamente severa';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    users = await UserRepository.instance.getUsers();
    List<AnswersUser> respuestasGuardadas =
    await AnswersRepository.getAllAnswersFromFirestore();

    List<Map<String, dynamic>> tempData = respuestasGuardadas.map((entry) {
      User user = users.firstWhere(
            (u) => u.id == entry.userId,
        orElse: () => User('', 'Desconocido', 'N/A', '', '', 'N/A'),
      );

      return {
        'Nombre': user.name,
        'Apellido': user.lastName,
        'Correo': user.email,
        'Teléfono': user.phone,
        'Fecha': entry.timestamp.split(' ')[0],
        'Depresión': AnswersRepository.clasificarDepresion(entry.p_depresion),
        'Ansiedad': AnswersRepository.clasificarAnsiedad(entry.p_ansiedad),
        'Estrés': AnswersRepository.clasificarEstres(entry.p_estres),
        'UserId': user.id,
        'Timestamp': entry.timestamp,
      };
    }).toList();

    setState(() {
      allData = tempData;
      filteredData = List<Map<String, dynamic>>.from(allData);
      isLoading = false;
    });
  }

  void _showFilterDialog() {
    final Map<String, List<String>> options = {
      'Depresión': [
        'Extremadamente severa',
        'Severa',
        'Moderada',
        'Leve',
        'Sin depresión'
      ],
      'Ansiedad': [
        'Extremadamente severa',
        'Severa',
        'Moderada',
        'Leve',
        'Sin ansiedad'
      ],
      'Estrés': [
        'Extremadamente severo',
        'Severo',
        'Moderado',
        'Leve',
        'Sin estrés'
      ],
    };

    showDialog(
      context: context,
      builder: (context) {
        String tempCriterion = selectedCriterion;
        String tempValue = selectedValue;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Seleccionar filtro'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempCriterion,
                    items: ['Depresión', 'Ansiedad', 'Estrés']
                        .map((criterion) => DropdownMenuItem(
                      value: criterion,
                      child: Text(criterion),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        tempCriterion = value ?? 'Depresión';
                        tempValue = options[tempCriterion]!.first;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButton<String>(
                    value: tempValue,
                    items: options[tempCriterion]!
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        tempValue = value ?? options[tempCriterion]!.first;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCriterion = tempCriterion;
                      selectedValue = tempValue;
                      filteredData = allData
                          .where((user) =>
                      user[selectedCriterion] == selectedValue)
                          .toList();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Aplicar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() =>
                    filteredData = List<Map<String, String>>.from(allData));
                    Navigator.of(context).pop();
                  },
                  child: Text('Reiniciar'),
                ),
              ],
            );
          },
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF1A119B),
                      ),
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Color(0xFF4CAF50)),
                        dataRowColor:
                            MaterialStateProperty.all(Color(0xFF1A119B)),
                        columns: [
                          DataColumn(
                            label: Text('Nombre',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
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
                              DataCell(Text(user['Nombre'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(user['Apellido'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(user['Correo'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(user['Teléfono'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(user['Fecha'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(user['Depresión'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(user['Ansiedad'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(user['Estrés'] ?? '',
                                  style: TextStyle(color: Colors.white))),
                            ],
                          );
                        }).toList(),
                      ),
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
                        DataCell(Text(user['Apellido']!,
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
      ),
    );
  }
}