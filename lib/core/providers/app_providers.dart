import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  final result = await connectivity.checkConnectivity();
  yield !result.contains(ConnectivityResult.none);

  await for (final result in connectivity.onConnectivityChanged) {
    yield !result.contains(ConnectivityResult.none);
  }
});
