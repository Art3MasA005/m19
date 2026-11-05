String formatCalories(double value) {
  final precise = value.toStringAsPrecision(12);
  if (precise.contains('e')) return precise;
  final raw = precise.contains('.')
      ? precise
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '')
      : precise;
  final parts = raw.split('.');
  final digits = parts.first;
  final sign = digits.startsWith('-') ? '-' : '';
  final number = sign.isEmpty ? digits : digits.substring(1);
  final grouped = number.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '$sign$grouped${parts.length > 1 ? '.${parts.last}' : ''}';
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
