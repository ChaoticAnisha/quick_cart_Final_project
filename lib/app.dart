import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_routes.dart';
import 'core/services/network_status_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/auth/presentation/pages/forgot_password_screen.dart';
import 'features/dashboard/presentation/pages/dashboard_screen.dart';
import 'features/category/presentation/pages/category_screen.dart';
import 'features/cart/presentation/pages/cart_screen.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'features/profile/presentation/pages/edit_profile.dart';
import 'features/products/presentation/pages/product_details_screen.dart';
import 'features/products/domain/entities/product.dart';
import 'features/orders/presentation/pages/orders_screen.dart';
import 'features/orders/presentation/pages/order_details_screen.dart';
import 'features/orders/domain/entities/order_entity.dart';
import 'features/checkout/presentation/pages/checkout_screen.dart';
import 'features/checkout/presentation/pages/map_picker_screen.dart';
import 'features/checkout/presentation/pages/order_confirmation_screen.dart';
import 'features/sensors/presentation/pages/sensor_screen.dart';
import 'features/wishlist/presentation/pages/wishlist_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(networkStatusProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickCart',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // Wrap every page with offline banner
      builder: (context, child) {
        return Column(
          children: [
            // Offline banner (animated)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isOnline ? 0 : 32,
              color: const Color(0xFFEF4444),
              child: isOnline
                  ? const SizedBox.shrink()
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'You\'re offline — showing cached data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
            Expanded(child: child ?? const SizedBox.shrink()),
          ],
        );
      },
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding1: (context) => const OnboardingOne(),
        AppRoutes.onboarding2: (context) => const OnboardingTwo(),
        AppRoutes.onboarding3: (context) => const OnboardingThree(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.home: (context) => const DashboardScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.category: (context) => const CategoryScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.editProfile: (context) => const EditProfileScreen(),
        AppRoutes.orders: (context) => const OrdersScreen(),
        AppRoutes.checkout: (context) => const CheckoutScreen(),
        AppRoutes.mapPicker: (context) => const MapPickerScreen(),
        AppRoutes.sensors: (context) => const SensorScreen(),
        AppRoutes.wishlist: (context) => const WishlistScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.productDetails:
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
              settings: settings,
            );
          case AppRoutes.orderDetails:
            final order = settings.arguments as OrderEntity;
            return MaterialPageRoute(
              builder: (_) => OrderDetailsScreen(order: order),
              settings: settings,
            );
          case AppRoutes.orderConfirmation:
            final order = settings.arguments as OrderEntity;
            return MaterialPageRoute(
              builder: (_) => OrderConfirmationScreen(order: order),
              settings: settings,
            );
          default:
            return null;
        }
      },
    );
  }
}
