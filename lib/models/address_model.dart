/// Represents a delivery address returned by GET /api/addresses.
///
/// Laravel response shape:
/// {
///   "id": 5,
///   "label": "Home",
///   "full_address": "123 Main St, Dhaka",
///   "lat": 23.8103,
///   "lng": 90.4125,
///   "is_default": true
/// }
class AddressModel {
  final int id;
  final String label;
  final String fullAddress;
  final double? lat;
  final double? lng;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.lat,
    this.lng,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int,
      label: json['label'] as String? ?? 'Address',
      fullAddress: json['full_address'] as String? ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? ''),
      lng: double.tryParse(json['lng']?.toString() ?? ''),
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  String get addressLine1 => fullAddress;

  Map<String, dynamic> toJson() => {
        'label': label,
        'full_address': fullAddress,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
      };
}
