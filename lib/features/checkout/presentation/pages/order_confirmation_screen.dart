import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../orders/domain/entities/order_entity.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderEntity order;
  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      size: 84, color: Colors.green),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Order Placed!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your order has been confirmed.\nSit back and relax while we prepare it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey, height: 1.6),
                ),
                const SizedBox(height: 28),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8DC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFFFD700)
                            .withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.receipt_long_outlined,
                          color: Color(0xFFFFA500)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Order ID',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                          Text(
                            '#${order.id.length > 10 ? order.id.substring(order.id.length - 10) : order.id}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFA500),
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _infoRow(Icons.local_shipping_outlined,
                    'Estimated delivery in 30-45 minutes'),
                const SizedBox(height: 8),
                _infoRow(
                    Icons.payment_outlined, 'Payment: ${_paymentLabel(order.paymentMethod)}'),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.orderDetails,
                        arguments: order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.track_changes_rounded,
                        color: Colors.white),
                    label: const Text('Track Order',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.dashboard, (route) => false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFA500)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.home_outlined,
                        color: Color(0xFFFFA500)),
                    label: const Text('Continue Shopping',
                        style: TextStyle(
                            color: Color(0xFFFFA500),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      );

  String _paymentLabel(String method) {
    switch (method.toLowerCase()) {
      case 'cod':
        return 'Cash on Delivery';
      case 'upi':
        return 'UPI';
      default:
        return 'Card';
    }
  }
}
