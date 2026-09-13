/// Represents a promotional banner card on the Home Screen.
class BannerModel {
  final int id;
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;
  final String bgColor;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
    required this.bgColor,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      buttonText: json['button_text'] as String? ?? 'Order Now',
      imageUrl: json['image_url'] as String? ?? '',
      bgColor: json['bg_color'] as String? ?? '#FF4757',
    );
  }
}
