import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/price_formatter.dart';
import '../widgets/custom_button.dart';
import 'main_wrapper_screen.dart';
import 'order_history_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final double totalAmount;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Animated Success Icon ────────────────────────────────
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 58)),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Title ────────────────────────────────────────────────
              const Text(
                'Order Placed! 🍽️',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your food is being prepared.\nGet ready for a delicious delivery!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // ── Order Info Box ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Order ID',
                      value: '#$orderId',
                      valueStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                    const Divider(height: 20),
                    _InfoRow(
                      label: 'Est. Delivery',
                      value: '30–45 min',
                      valueStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGreen),
                    ),
                    const Divider(height: 20),
                    _InfoRow(
                      label: 'Total Paid',
                      value: PriceFormatter.format(totalAmount),
                      valueStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // ── Track Order Button ───────────────────────────────────
              CustomButton(
                text: 'Track My Order',
                icon: Icons.delivery_dining_rounded,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen()),
                  );
                },
              ),
              const SizedBox(height: 14),

              // ── Back to Menu Button ──────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.restaurant_menu_rounded,
                      color: AppColors.primary, size: 20),
                  label: const Text(
                    'Browse More Food',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const MainWrapperScreen(initialIndex: 0)),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;

  const _InfoRow(
      {required this.label,
      required this.value,
      required this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14)),
        Text(value, style: valueStyle),
      ],
    );
  }
}
