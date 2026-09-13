class PriceFormatter {
  static String format(double price) {
    // Format as Bangladeshi Taka (৳)
    return '৳${price % 1 == 0 ? price.toInt() : price.toStringAsFixed(2)}';
  }
}
