class User {
  final String id;
  final String username;
  final String email;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  // Metode untuk konversi ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Metode untuk konversi dari Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }

  // Metode toJson()
  Map<String, dynamic> toJson() => toMap();

  // Metode fromJson()
  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);
}