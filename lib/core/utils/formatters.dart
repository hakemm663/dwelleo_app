import 'package:intl/intl.dart';

/// Shared display formatters (core — reusable across features).
abstract final class Formatters {
  static final NumberFormat _grouped = NumberFormat.decimalPattern('en');

  /// e.g. `SAR 1,300,000`. Returns `—` for null.
  static String price(num? value, {String currency = 'SAR'}) =>
      value == null ? '—' : '$currency ${_grouped.format(value)}';

  /// Grouped number only, e.g. `1,300,000` (pair with the SAR icon).
  static String priceValue(num? value) =>
      value == null ? '—' : _grouped.format(value);

  /// e.g. `275 m²`.
  static String area(num? value) =>
      value == null ? '—' : '${_grouped.format(value)} m²';

  static String count(num? value) =>
      value == null ? '—' : _grouped.format(value);
}
