class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = 'assets/icons/user.png',
  })
  ; 

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
}
