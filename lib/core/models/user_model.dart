class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password = '',
    this.avatarUrl = 'assets/icons/user.png',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? 'assets/icons/user.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      avatarUrl: map['avatarUrl'] ?? 'assets/icons/user.png',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatarUrl': avatarUrl,
    };
  }
}

