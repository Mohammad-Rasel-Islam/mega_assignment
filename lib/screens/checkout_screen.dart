import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/address_model.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';
import '../utils/constants.dart';
import '../utils/price_formatter.dart';
import '../widgets/address_card.dart';
import '../widgets/custom_button.dart';
import 'map_picker_screen.dart';
import 'order_confirmation_screen.dart';

/// Checkout screen — lets the user pick a delivery address and place their order.
///
/// Address selection: pick from saved addresses (GET /api/addresses) OR
/// add a new one via the map picker (POST /api/addresses).
/// Placing order: POST /api/orders → clear local cart → navigate to confirmation.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isPlacingOrder = false;
  int? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final addrProv = context.read<AddressProvider>();
      await addrProv.fetchAddresses();
      // Pre-select the default address
      if (addrProv.defaultAddress != null) {
        setState(() {
          _selectedAddressId = addrProv.defaultAddress!.id;
        });
      }
    });
  }

  Future<void> _handlePlaceOrder() async {
    if (_selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or add a delivery address.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    final addressProvider = context.read<AddressProvider>();
    final cartProvider = context.read<CartProvider>();
    final totalAmount = cartProvider.total;

    final orderId = await addressProvider.placeOrder(_selectedAddressId!);

    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    if (orderId != null) {
      // Clear local cart state on success
      cartProvider.clearLocalCart();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
            orderId: orderId.toString(),
            totalAmount: totalAmount,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(addressProvider.error ?? 'Failed to place order.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _openMapPicker() async {
    final savedAddress = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );
    if (savedAddress != null && mounted) {
      setState(() => _selectedAddressId = savedAddress.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final addressProvider = context.watch<AddressProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Address Section ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                TextButton.icon(
                  onPressed: _openMapPicker,
                  icon: const Icon(Icons.add_location_alt_rounded,
                      size: 18, color: AppColors.primary),
                  label: const Text('Add Address',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (addressProvider.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              )
            else if (addressProvider.addresses.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.location_off_rounded,
                        size: 36, color: AppColors.textSecondary),
                    const SizedBox(height: 8),
                    const Text(
                      'No saved delivery address yet.',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _openMapPicker,
                      icon:
                          const Icon(Icons.add_location_alt_rounded),
                      label: const Text('Add Delivery Address'),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: addressProvider.addresses.map((addr) {
                  return AddressCard(
                    address: addr,
                    isSelected: _selectedAddressId == addr.id,
                    onTap: () =>
                        setState(() => _selectedAddressId = addr.id),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            // ── Order Summary ────────────────────────────────────────
            const Text(
              'Order Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ...cartProvider.cartItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            '${item.quantity}x',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary),
                            ),
                          ),
                          Text(
                            PriceFormatter.format(item.totalPrice),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                      label: 'Subtotal',
                      value: PriceFormatter.format(cartProvider.subtotal)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payment',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                      Text(
                        PriceFormatter.format(cartProvider.total),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Place Order Button ────────────────────────────────────
            CustomButton(
              text:
                  'Place Order (${PriceFormatter.format(cartProvider.total)})',
              isLoading: _isPlacingOrder,
              onPressed: _handlePlaceOrder,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary)),
        Text(value),
      ],
    );
  }
}
