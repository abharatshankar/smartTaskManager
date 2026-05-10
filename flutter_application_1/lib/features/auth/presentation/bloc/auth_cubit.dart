import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({required this.loginUseCase, required this.registerUseCase, required this.logoutUseCase, required this.getCurrentUserUseCase}) : super(const AuthState());

  Future<void> checkSession() async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    try {
      final user = await getCurrentUserUseCase();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user, message: null));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated, message: null));
    }
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    try {
      final user = await loginUseCase(email, password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user, message: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
      emit(state.copyWith(status: AuthStatus.unauthenticated, message: null));
    }
  }

  Future<void> register(String username, String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    try {
      await registerUseCase(username, email, password);
      emit(state.copyWith(status: AuthStatus.unauthenticated, message: 'Registration successful'));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
