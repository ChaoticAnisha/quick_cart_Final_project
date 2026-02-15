class AuthApiModel {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? profilePicture;
  final String? token;

  AuthApiModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.profilePicture,
    this.token,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json;
    return AuthApiModel(
      id: user['id'] ?? user['_id'],
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone'],
      address: user['address'],
      profilePicture: user['profilePicture'] ?? user['profile_picture'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profilePicture': profilePicture,
      'token': token,
    };
  }
}

// Response wrapper for API calls
class AuthResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }
}
