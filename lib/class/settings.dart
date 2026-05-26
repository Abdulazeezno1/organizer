import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings {
  const Settings({required this.savingsGoal, required this.emergencyReserve});

  final double savingsGoal;
  final double emergencyReserve;

  Settings copyWith({double? savingsGoal, double? emergencyReserve}) {
    return Settings(
      savingsGoal: savingsGoal ?? this.savingsGoal,
      emergencyReserve: emergencyReserve ?? this.emergencyReserve,
    );
  }
}

class SettingsNotifier extends Notifier<Settings> {
  @override
  Settings build() {
    return const Settings(savingsGoal: 0.0, emergencyReserve: 0.0);
  }

  void updateSavingsGoal(double value) {
    state = state.copyWith(savingsGoal: value);
  }

  void updateEmergencyReserve(double value) {
    state = state.copyWith(emergencyReserve: value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);
