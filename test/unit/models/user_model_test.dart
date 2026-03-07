import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/auth/domain/entities/user.dart';

void main() {
  group('User.fromJson', () {
    test('parses standard fields', () {
      final user = User.fromJson({
        'id': 'u-1',
        'name': 'Priya Thapa',
        'email': 'priya@example.com',
        'phone': '9811111111',
        'address': 'Pokhara, Gandaki',
        'profilePicture': '/uploads/avatar.jpg',
      });

      expect(user.id, 'u-1');
      expect(user.name, 'Priya Thapa');
      expect(user.email, 'priya@example.com');
      expect(user.phone, '9811111111');
      expect(user.address, 'Pokhara, Gandaki');
      expect(user.profilePicture, '/uploads/avatar.jpg');
    });

    test('reads _id when id is absent', () {
      final user = User.fromJson({'_id': 'u-mongo', 'name': 'X', 'email': 'x@x.com'});
      expect(user.id, 'u-mongo');
    });

    test('falls back to avatar field when profilePicture is absent', () {
      final user = User.fromJson({
        'id': 'u-2',
        'name': 'Sita',
        'email': 's@example.com',
        'avatar': '/uploads/sita.jpg',
      });
      expect(user.profilePicture, '/uploads/sita.jpg');
    });

    test('profilePicture takes precedence over avatar', () {
      final user = User.fromJson({
        'id': 'u-3',
        'name': 'Ram',
        'email': 'r@example.com',
        'profilePicture': '/uploads/ram.jpg',
        'avatar': '/uploads/old.jpg',
      });
      expect(user.profilePicture, '/uploads/ram.jpg');
    });

    test('optional fields are null when absent', () {
      final user = User.fromJson({'id': 'u-4', 'name': 'Min', 'email': 'm@m.com'});
      expect(user.phone, isNull);
      expect(user.address, isNull);
      expect(user.profilePicture, isNull);
    });
  });

  group('User.copyWith', () {
    const tUser = User(id: 'u-1', name: 'Old', email: 'old@example.com');

    test('updates only specified fields', () {
      final updated = tUser.copyWith(name: 'New Name', phone: '9800000000');
      expect(updated.name, 'New Name');
      expect(updated.phone, '9800000000');
      expect(updated.email, 'old@example.com'); // unchanged
      expect(updated.id, 'u-1');               // unchanged
    });

    test('returns equivalent object when no changes', () {
      final copy = tUser.copyWith();
      expect(copy, tUser);
    });
  });

  group('User.toJson', () {
    test('serialises all fields', () {
      const user = User(
        id: 'u-5',
        name: 'Anita',
        email: 'anita@example.com',
        phone: '9822222222',
        address: 'Chitwan',
        profilePicture: '/uploads/anita.jpg',
      );
      final json = user.toJson();
      expect(json['id'], 'u-5');
      expect(json['name'], 'Anita');
      expect(json['email'], 'anita@example.com');
      expect(json['phone'], '9822222222');
      expect(json['address'], 'Chitwan');
      expect(json['profilePicture'], '/uploads/anita.jpg');
    });
  });

  group('User.getProfilePictureUrl', () {
    test('returns null when profilePicture is null', () {
      const user = User(id: 'u-6', name: 'X', email: 'x@x.com');
      expect(user.getProfilePictureUrl(), isNull);
    });

    test('returns non-null string for relative path', () {
      const user = User(
          id: 'u-7', name: 'Y', email: 'y@y.com', profilePicture: '/uploads/y.jpg');
      expect(user.getProfilePictureUrl(), isNotNull);
      expect(user.getProfilePictureUrl()!.contains('y.jpg'), isTrue);
    });
  });
}
