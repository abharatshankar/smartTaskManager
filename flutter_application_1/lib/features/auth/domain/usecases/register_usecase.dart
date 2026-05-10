import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);
  Future<void> call(String username, String email, String password) => repository.register(username: username, email: email, password: password);
}
