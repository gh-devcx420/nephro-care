import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final allowDeleteAllProvider = StateProvider<bool>((ref) {
  return true;
});
final allowEditPastEntriesProvider = StateProvider<bool>((ref) {
  return false;
});
final allowDeletePastEntriesProvider = StateProvider<bool>((ref) {
  return false;
});

final remindersActiveProvider = StateProvider<bool>((ref) {
  return true;
});

class FluidLimitNotifier extends StateNotifier<int> {
  FluidLimitNotifier() : super(750) {
    _loadFluidLimit();
  }

  Future<void> _loadFluidLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLimit = prefs.getInt('fluidLimit') ?? 750;
    state = savedLimit;
  }

  Future<void> setFluidLimit(int newLimit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fluidLimit', newLimit);
    state = newLimit;
  }
}

final fluidLimitProvider =
    StateNotifierProvider<FluidLimitNotifier, int>((ref) {
  return FluidLimitNotifier();
});
