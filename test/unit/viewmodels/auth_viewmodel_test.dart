import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_cart/core/error/failures.dart';
import 'package:quick_cart/features/auth/domain/entities/auth_entities.dart';
import 'package:quick_cart/features/auth/domain/usecases/auth_usecases.dart';
import 'package:quick_cart/features/auth/presentation/state/auth_state.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';

// Mocks
class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}
class MockLogoutUsecase extends Mock implements LogoutUsecase {}
class MockForgotPasswordUsecase extends Mock implements ForgotPasswordUsecase {}
class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

void main() {
  late MockLoginUsecase mockLogin;
  late MockRegisterUsecase mockRegister;
  late MockLogoutUsecase mockLogout;
  late MockForgotPasswordUsecase mockForgotPw;
  late MockGetCurrentUserUsecase mockGetCurrentUser;

  const tAuthEntity = AuthEntity(
    id: 'user-1',
    name: 'Test User',
    email: 'test@example.com',
    phone: '9800000000',
    address: 'Kathmandu',
  );
  const tFailure = ApiFailure(message: 'Invalid credentials', statusCode: 401);

  // Helper: create a ProviderContainer with all usecases mocked
  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        loginUsecaseProvider.overrideWithValue(mockLogin),
        registerUsecaseProvider.overrideWithValue(mockRegister),
        logoutUsecaseProvider.overrideWithValue(mockLogout),
        forgotPasswordUsecaseProvider.overrideWithValue(mockForgotPw),
        getCurrentUserUsecaseProvider.overrideWithValue(mockGetCurrentUser),
      ],
    );
  }

  setUp(() {
    mockLogin = MockLoginUsecase();
    mockRegister = MockRegisterUsecase();
    mockLogout = MockLogoutUsecase();
    mockForgotPw = MockForgotPasswordUsecase();
    mockGetCurrentUser = MockGetCurrentUserUsecase();

    registerFallbackValue(
      const LoginParams(email: '', password: ''),
    );
    registerFallbackValue(
      const RegisterParams(name: '', email: '', password: ''),
    );
  });

  // ── Test 1: login success sets authenticated + user ───────────────────────
  test('login() success → status authenticated and user populated', () async {
    when(() => mockLogin(any()))
        .thenAnswer((_) async => const Right(tAuthEntity));

    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(authViewModelProvider.notifier)
        .login(email: 'test@example.com', password: 'password123');

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user, isNotNull);
    expect(state.user!.email, 'test@example.com');
    expect(state.user!.name, 'Test User');
  });

  // ── Test 2: login failure sets error + errorMessage ───────────────────────
  test('login() failure → status error and errorMessage set', () async {
    when(() => mockLogin(any()))
        .thenAnswer((_) async => const Left(tFailure));

    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(authViewModelProvider.notifier)
        .login(email: 'wrong@example.com', password: 'bad');

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.error);
    expect(state.errorMessage, 'Invalid credentials');
    expect(state.user, isNull);
  });

  // ── Test 3: register success → status registered ──────────────────────────
  test('register() success → status registered', () async {
    when(() => mockRegister(any()))
        .thenAnswer((_) async => const Right(true));

    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(authViewModelProvider.notifier).register(
          name: 'New User',
          email: 'new@example.com',
          password: 'pass123',
        );

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.registered);
  });

  // ── Test 4: fetchCurrentUser restores user from token ─────────────────────
  test('fetchCurrentUser() → status authenticated and user restored', () async {
    when(() => mockGetCurrentUser())
        .thenAnswer((_) async => const Right(tAuthEntity));

    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(authViewModelProvider.notifier).fetchCurrentUser();

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user, isNotNull);
    expect(state.user!.phone, '9800000000');
    expect(state.user!.address, 'Kathmandu');
  });
}
