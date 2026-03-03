import 'package:hive/hive.dart';
import '../../../../core/constants/app_boxes.dart';
import '../../domain/entities/order_entity.dart';

@HiveType(typeId: 2) // matches AppBoxes.orderHiveModelTypeId
class OrderHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final double totalAmount;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final String deliveryAddress;

  @HiveField(5)
  final String paymentMethod;

  @HiveField(6)
  final String createdAt;

  @HiveField(7)
  final List<Map> items;

  OrderHiveModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
  });

  factory OrderHiveModel.fromEntity(OrderEntity e) => OrderHiveModel(
        id: e.id,
        userId: e.userId,
        totalAmount: e.totalAmount,
        status: e.status,
        deliveryAddress: e.deliveryAddress,
        paymentMethod: e.paymentMethod,
        createdAt: e.createdAt.toIso8601String(),
        items: e.items
            .map((i) => {
                  'productId': i.productId,
                  'productName': i.productName,
                  'price': i.price,
                  'quantity': i.quantity,
                  'image': i.image,
                })
            .toList(),
      );

  OrderEntity toEntity() => OrderEntity(
        id: id,
        userId: userId,
        totalAmount: totalAmount,
        status: status,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        createdAt: DateTime.parse(createdAt),
        items: items
            .map((i) => OrderItemEntity(
                  productId: i['productId'] as String? ?? '',
                  productName: i['productName'] as String? ?? '',
                  price: (i['price'] as num?)?.toDouble() ?? 0,
                  quantity: i['quantity'] as int? ?? 1,
                  image: i['image'] as String?,
                ))
            .toList(),
      );
}

/// Manual TypeAdapter — no build_runner required.
class OrderHiveModelAdapter extends TypeAdapter<OrderHiveModel> {
  @override
  final int typeId = AppBoxes.orderHiveModelTypeId; // = 2

  @override
  OrderHiveModel read(BinaryReader reader) {
    final count = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < count; i++) reader.readByte(): reader.read(),
    };
    return OrderHiveModel(
      id: fields[0] as String? ?? '',
      userId: fields[1] as String? ?? '',
      totalAmount: (fields[2] as num?)?.toDouble() ?? 0,
      status: fields[3] as String? ?? '',
      deliveryAddress: fields[4] as String? ?? '',
      paymentMethod: fields[5] as String? ?? '',
      createdAt: fields[6] as String? ?? DateTime.now().toIso8601String(),
      items: (fields[7] as List?)?.cast<Map>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, OrderHiveModel obj) {
    writer.writeByte(8);
    writer
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.totalAmount)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.deliveryAddress)
      ..writeByte(5)
      ..write(obj.paymentMethod)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      other is OrderHiveModelAdapter && other.typeId == typeId;
}
