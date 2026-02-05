import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/auth_api_service.dart';
import 'package:aura_project/fratuers/profile_test/logic/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  final AuthApiService _apiService = AuthApiService();

  void logout() async {
    emit(LogoutLoading());

    try {
      await _apiService.logout().timeout(const Duration(seconds: 3));
      print("✅ Server logout success");
    } catch (e) {
      print(
        "⚠️ Server logout failed (Network error), but forcing local logout. Error: $e",
      );
    } finally {
      await LocalStorage.clearToken();

      emit(LogoutSuccess());
    }
  }
}
