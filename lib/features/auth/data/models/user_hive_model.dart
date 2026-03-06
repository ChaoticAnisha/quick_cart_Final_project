import 'package:hive/hive.dart';
import '../../../../core/constants/app_boxes.dart';

@HiveType(typeId: AppBoxes.userHiveModelTypeId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String? address;

  @HiveField(5)
  final String? profilePicture;

  @HiveField(6)
  final String? role;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.profilePicture,
    this.role,
  });

  factory UserHiveModel.fromMap(Map<String, dynamic> map) => UserHiveModel(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        phone: map['phone'] as String?,
        address: map['address'] as String?,
        profilePicture: map['profilePicture'] as String?,
        role: map['role'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'profilePicture': profilePicture,
        'role': role,
      };
}

/// Manual TypeAdapter — avoids needing build_runner.
class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = AppBoxes.userHiveModelTypeId;

  @override
  UserHiveModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveModel(
      id: fields[0] as String? ?? '',
      name: fields[1] as String? ?? '',
      email: fields[2] as String? ?? '',
      phone: fields[3] as String?,
      address: fields[4] as String?,
      profilePicture: fields[5] as String?,
      role: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer.writeByte(7);
    writer
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.profilePicture)
      ..writeByte(6)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      other is UserHiveModelAdapter && other.typeId == typeId;
}
