import 'package:equatable/equatable.dart';

enum CheckoutStatus { idle, placing, success, error }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final String selectedPayment;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.idle,
    this.selectedPayment = 'cod',
    this.errorMessage,
  });

  bool get isPlacing => status == CheckoutStatus.placing;

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? selectedPayment,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, selectedPayment, errorMessage];
}
