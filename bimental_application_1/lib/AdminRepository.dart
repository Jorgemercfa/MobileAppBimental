class AdminRepository {
  static final AdminRepository instance = AdminRepository._internal();

  factory AdminRepository() {
    return instance;
  }

  AdminRepository._internal();

  // Inicializando la lista con credenciales predeterminadas
  List<Map<String, String>> Admin = [
    {
      'email': 'admin1@bimental.com',
      'password': '#wrb22ed',
    }
  ];

  List<Map<String, String>> getAdmins() {
    return Admin;
  }

  // Método para agregar nuevos administradores si lo necesitas
  void addAdmin(String email, String password) {
    Admin.add({'email': email, 'password': password});
  }
}
