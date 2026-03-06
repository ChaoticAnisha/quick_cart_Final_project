import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../../../cart/presentation/viewmodel/cart_viewmodel.dart';
import '../viewmodel/checkout_viewmodel.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).user;
    if (user != null) _nameCtrl.text = user.name;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartState = ref.read(cartViewModelProvider);
    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Your cart is empty'),
            backgroundColor: Colors.red),
      );
      return;
    }

    final address =
        '${_nameCtrl.text.trim()}, ${_phoneCtrl.text.trim()}, '
        '${_addressCtrl.text.trim()}, ${_cityCtrl.text.trim()} '
        '- ${_pincodeCtrl.text.trim()}';

    final order = await ref
        .read(checkoutViewModelProvider.notifier)
        .placeOrder(deliveryAddress: address);

    if (!mounted) return;

    if (order != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.orderConfirmation,
        arguments: order,
      );
    } else {
      final error = ref.read(checkoutViewModelProvider).errorMessage ??
          'Failed to place order';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final cartVM = ref.read(cartViewModelProvider.notifier);
    final checkoutState = ref.watch(checkoutViewModelProvider);
    final subtotal = cartVM.totalAmount;
    final total = subtotal;
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
                child: Form(
                  key: _formKey,
                  child: isTablet
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildFormSection(checkoutState.selectedPayment),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: _buildSummarySection(
                                  cartState, subtotal, total),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormSection(checkoutState.selectedPayment),
                            const SizedBox(height: 24),
                            _buildSummarySection(cartState, subtotal, total),
                            const SizedBox(height: 20),
                          ],
                        ),
                ),
              ),
            ),
            _buildBottomBar(total, checkoutState.isPlacing),
          ],
        ),
      ),
    );
  }

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
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          const Text('Checkout',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFormSection(String selectedPayment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Delivery Address', Icons.location_on_outlined),
        const SizedBox(height: 12),
        _field(_nameCtrl, 'Full Name', Icons.person_outline, required: true),
        const SizedBox(height: 12),
        _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined,
            required: true, keyboard: TextInputType.phone),
        const SizedBox(height: 12),
        _field(_addressCtrl, 'Full Address', Icons.home_outlined,
            required: true, maxLines: 2),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _field(_cityCtrl, 'City', Icons.location_city_outlined,
                  required: true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _field(
                  _pincodeCtrl, 'Pincode', Icons.pin_drop_outlined,
                  required: true, keyboard: TextInputType.number),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _sectionTitle('Payment Method', Icons.payment_outlined),
        const SizedBox(height: 12),
        _buildPaymentOptions(selectedPayment),
      ],
    );
  }

  Widget _buildSummarySection(cartState, double subtotal, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Order Summary', Icons.receipt_long_outlined),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            children: [
              ...cartState.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.productName} × ${item.quantity}',
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )),
              Divider(color: Colors.grey.shade200),
              _sumRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
                    child: const Text('FREE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFA500)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double total, bool isPlacing) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: isPlacing ? null : _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFA500),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
          ),
          icon: isPlacing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white)))
              : const Icon(Icons.check_circle_outline, color: Colors.white),
          label: Text(
            isPlacing
                ? 'Placing Order...'
                : 'Place Order — ₹${total.toStringAsFixed(0)}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFA500), size: 20),
        const SizedBox(width: 8),
        Text(title,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFFA500), size: 20),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFFFA500), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required
          ? (val) =>
              (val == null || val.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }

  Widget _buildPaymentOptions(String selectedPayment) {
    return Column(
      children: [
        _paymentCard(
          value: 'cod',
          label: 'Cash on Delivery',
          desc: 'Pay when your order is delivered',
          icon: Icons.payments_outlined,
          activeColor: const Color(0xFFFFA500),
          activeBg: const Color(0xFFFFF8DC),
          selectedPayment: selectedPayment,
        ),
        const SizedBox(height: 10),
        _paymentCard(
          value: 'khalti',
          label: 'Khalti',
          desc: 'Pay securely with Khalti digital wallet',
          icon: Icons.account_balance_wallet_rounded,
          activeColor: const Color(0xFF5C2D91),
          activeBg: const Color(0xFFF3EBF9),
          badge: _khaltiLogo(),
          selectedPayment: selectedPayment,
        ),
      ],
    );
  }

  Widget _khaltiLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF5C2D91),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'KHALTI',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _paymentCard({
    required String value,
    required String label,
    required String desc,
    required IconData icon,
    required Color activeColor,
    required Color activeBg,
    required String selectedPayment,
    Widget? badge,
  }) {
    final isSelected = selectedPayment == value;
    return GestureDetector(
      onTap: () =>
          ref.read(checkoutViewModelProvider.notifier).selectPayment(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? activeColor.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.15)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: isSelected ? activeColor : Colors.grey.shade500,
                  size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isSelected ? activeColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              badge,
            ],
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Icon(Icons.check_circle_rounded,
                      key: const ValueKey('checked'), color: activeColor)
                  : Icon(Icons.radio_button_unchecked,
                      key: const ValueKey('unchecked'),
                      color: Colors.grey.shade300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sumRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade600, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      );
}
