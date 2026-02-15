class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? avatar;
  final String? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt,
    };
  }
}
