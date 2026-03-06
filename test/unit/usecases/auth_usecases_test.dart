import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_cart/core/error/failures.dart';
import 'package:quick_cart/features/auth/domain/entities/auth_entities.dart';
import 'package:quick_cart/features/auth/domain/repositories/auth_repository.dart';
import 'package:quick_cart/features/auth/domain/usecases/auth_usecases.dart';

// Mock
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  // Shared test data
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';
  const tAuthEntity = AuthEntity(
    id: 'user-1',
    name: tName,
    email: tEmail,
    phone: '9800000000',
    address: 'Kathmandu',
  );
  const tFailure = ApiFailure(message: 'Invalid credentials', statusCode: 401);

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  // ── 1. LoginUsecase — success ─────────────────────────────────────────────
  group('LoginUsecase', () {
    test('returns Right(AuthEntity) on successful login', () async {
      when(() => mockRepo.login(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tAuthEntity));

      final usecase = LoginUsecase(authRepository: mockRepo);
      final result = await usecase(
        const LoginParams(email: tEmail, password: tPassword),
      );

      expect(result, const Right(tAuthEntity));
      verify(() => mockRepo.login(tEmail, tPassword)).called(1);
    });

    // ── 2. LoginUsecase — failure ─────────────────────────────────────────
    test('returns Left(Failure) on login failure', () async {
      when(() => mockRepo.login(tEmail, tPassword))
          .thenAnswer((_) async => const Left(tFailure));

      final usecase = LoginUsecase(authRepository: mockRepo);
      final result = await usecase(
        const LoginParams(email: tEmail, password: tPassword),
      );

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f.message, 'Invalid credentials'),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── 3. RegisterUsecase — success ──────────────────────────────────────────
  group('RegisterUsecase', () {
    test('returns Right(true) on successful registration', () async {
      when(() => mockRepo.register(
            name: tName,
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => const Right(true));

      final usecase = RegisterUsecase(authRepository: mockRepo);
      final result = await usecase(
        const RegisterParams(name: tName, email: tEmail, password: tPassword),
      );

      expect(result, const Right(true));
    });

    // ── 4. RegisterUsecase — failure ────────────────────────────────────────
    test('returns Left(Failure) when email already exists', () async {
      const dupFailure = ApiFailure(
          message: 'Email already registered', statusCode: 409);
      when(() => mockRepo.register(
            name: tName,
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => const Left(dupFailure));

      final usecase = RegisterUsecase(authRepository: mockRepo);
      final result = await usecase(
        const RegisterParams(name: tName, email: tEmail, password: tPassword),
      );

      expect(result.isLeft(), true);
    });
  });

  // ── 5. GetCurrentUserUsecase — success ────────────────────────────────────
  group('GetCurrentUserUsecase', () {
    test('returns Right(AuthEntity) with full user data', () async {
      when(() => mockRepo.getCurrentUser())
          .thenAnswer((_) async => const Right(tAuthEntity));

      final usecase = GetCurrentUserUsecase(authRepository: mockRepo);
      final result = await usecase();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.email, tEmail);
          expect(entity.name, tName);
          expect(entity.phone, '9800000000');
        },
      );
    });
  });

  // ── 6. LogoutUsecase — success ────────────────────────────────────────────
  group('LogoutUsecase', () {
    test('returns Right(true) and clears session', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async => const Right(true));

      final usecase = LogoutUsecase(authRepository: mockRepo);
      final result = await usecase();

      expect(result, const Right(true));
      verify(() => mockRepo.logout()).called(1);
    });
  });
}
