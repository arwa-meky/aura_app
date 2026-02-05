import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  DeviceCubit() : super(DeviceState());

  static DeviceCubit get(context) => BlocProvider.of(context);

  void toggleConnection() async {
    if (state.status == ConnectionStatus.connected) {
      emit(state.copyWith(status: ConnectionStatus.disconnected));
    } else {
      emit(state.copyWith(status: ConnectionStatus.connecting));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: ConnectionStatus.connected));
    }
  }

  void toggleHeartRate(bool value) =>
      emit(state.copyWith(isHeartRateEnabled: value));
  void toggleBloodOxygen(bool value) =>
      emit(state.copyWith(isBloodOxygenEnabled: value));
  void toggleActivity(bool value) =>
      emit(state.copyWith(isActivityEnabled: value));
  void toggleGps(bool value) => emit(state.copyWith(isGpsEnabled: value));
  void toggleAutoSync(bool value) =>
      emit(state.copyWith(isAutoSyncEnabled: value));
  void toggleSos(bool value) => emit(state.copyWith(isSosEnabled: value));
  void toggleFallDetection(bool value) =>
      emit(state.copyWith(isFallDetectionEnabled: value));

  void resetWatch() {
    emit(state.copyWith(status: ConnectionStatus.disconnected));
    //
  }
}
