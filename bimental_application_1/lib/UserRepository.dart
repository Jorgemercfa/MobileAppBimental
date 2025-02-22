class UserRepository {
  static final UserRepository instance = UserRepository._internal();

  factory UserRepository() {
    return instance;
  }

  UserRepository._internal();

  List<Map<String, String>> users = [];

  addUser(newUser) {
    users.add(newUser);
  }

  getUsers() {
    return users;
  }
}
