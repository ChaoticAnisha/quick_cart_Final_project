import 'package:flutter/material.dart';
import '../../../../api/api_endpoints.dart';
import '../../domain/entities/order_entity.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: isTablet
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildLeftColumn()),
                          const SizedBox(width: 20),
                          Expanded(flex: 2, child: _buildRightColumn()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusTracker(),
                          const SizedBox(height: 20),
                          _buildItemsList(),
                          const SizedBox(height: 20),
                          _buildDeliveryCard(),
                          const SizedBox(height: 20),
                          _buildSummaryCard(),
                          const SizedBox(height: 30),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildStatusTracker(),
      const SizedBox(height: 20),
      _buildItemsList(),
    ],
  );

  Widget _buildRightColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDeliveryCard(),
      const SizedBox(height: 20),
      _buildSummaryCard(),
    ],
  );

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(
                  '#${order.id.length > 12 ? order.id.substring(order.id.length - 12) : order.id}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          _statusBadge(order.status),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusTracker() {
    final steps = ['Pending', 'Processing', 'Shipped', 'Delivered'];
    final currentIndex = _stepIndex(order.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                final lineIndex = i ~/ 2;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: lineIndex < currentIndex ? const Color(0xFFFFA500) : Colors.grey.shade200,
                  ),
                );
              }
              final stepIndex = i ~/ 2;
              final done = stepIndex <= currentIndex;
              return Column(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? const Color(0xFFFFA500) : Colors.grey.shade200,
                    ),
                    child: Icon(
                      done ? Icons.check : Icons.circle,
                      size: done ? 16 : 8,
                      color: done ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[stepIndex],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: done ? FontWeight.bold : FontWeight.normal,
                      color: done ? const Color(0xFFFFA500) : Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...order.items.map((item) => _buildItemRow(item)),
      ],
    );
  }

  Widget _buildItemRow(OrderItemEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 60, height: 60,
              color: const Color(0xFFFFF8DC),
              padding: const EdgeInsets.all(4),
              child: item.image != null && item.image!.isNotEmpty
                  ? Image.network(
                      ApiEndpoints.getImageUrl(item.image!),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag_outlined, color: Color(0xFFFFA500)),
                    )
                  : const Icon(Icons.shopping_bag_outlined, color: Color(0xFFFFA500)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('₹${item.price.toStringAsFixed(0)} × ${item.quantity}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(
            '₹${item.subtotal.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFFA500)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFFFFA500), size: 20),
            const SizedBox(width: 8),
            const Text('Delivery Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          Text(order.deliveryAddress,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5)),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.payment_outlined, color: Color(0xFFFFA500), size: 20),
            const SizedBox(width: 8),
            const Text('Payment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          _paymentBadge(order.paymentMethod),
        ],
      ),
    );
  }

  Widget _paymentBadge(String method) {
    final label = method.toLowerCase() == 'cod'
        ? 'Cash on Delivery'
        : method.toLowerCase() == 'upi'
            ? 'UPI'
            : 'Card';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.5)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFFA500))),
    );
  }

  Widget _buildSummaryCard() {
    const deliveryFee = 30.0;
    final subtotal = order.totalAmount - deliveryFee;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _summaryRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _summaryRow('Delivery Fee', '₹${deliveryFee.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text('₹${order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFA500))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    ],
  );

  int _stepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'processing': return 1;
      case 'shipped': return 2;
      case 'delivered': return 3;
      default: return 0;
    }
  }

}
