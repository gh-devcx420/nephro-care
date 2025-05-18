import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final allowDeleteAllProvider = StateProvider<bool>((ref) {
  return true;
});

final fluidLimitProvider = StateProvider<int>((ref) {
  return 750;
});
