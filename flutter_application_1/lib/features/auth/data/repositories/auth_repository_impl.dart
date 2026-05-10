import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login({required String email, required String password}) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<void> register({required String username, required String email, required String password}) {
    return remoteDataSource.register(username, email, password);
  }

  @override
  Future<UserEntity> me() => remoteDataSource.me();

  @override
  Future<void> logout() => remoteDataSource.logout();
}
