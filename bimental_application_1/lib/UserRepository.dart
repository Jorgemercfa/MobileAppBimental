class UserRepository {
  static final UserRepository instance = UserRepository._internal();

  factory UserRepository() {
    return instance;
  }

  UserRepository._internal();

  List<Map<String, String>> users = [
    {
      'nombre': 'jorge',
      'email': 'cokijlmf@gmail.com',
      'password': '123456',
    }
  ];

  addUser(newUser) {
    users.add(newUser);
  }

  getUsers() {
    return users;
  }
}
