import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

/// Manual address entry screen.
///
/// Replaces the Google Maps picker so the app works without a Maps API key.
/// The user simply types their address label and full address text.
class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({Key? key}) : super(key: key);

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _labelController =
      TextEditingController(text: 'Home');
  final TextEditingController _addressController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);

    final saved = await addressProvider.saveAddress(
      label: _labelController.text.trim(),
      fullAddress: _addressController.text.trim(),
      lat: null,
      lng: null,
      isDefault: true,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (saved != null) {
      Navigator.pop(context, saved);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(addressProvider.error ?? 'Failed to save address.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Delivery Address')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon header
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter where you want your order delivered.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Label field
              TextFormField(
                controller: _labelController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Label',
                  hintText: 'e.g. Home, Office, Parents House',
                  prefixIcon: Icon(Icons.label_rounded),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter a label' : null,
              ),
              const SizedBox(height: 16),

              // Full address field
              TextFormField(
                controller: _addressController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Full Address',
                  hintText:
                      'e.g. 123 Main Street, Dhaka 1200, Bangladesh',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.home_rounded),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter your full address'
                    : null,
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Save Address',
                isLoading: _isSaving,
                onPressed: _saveAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
