import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/tasks/data/datasources/task_remote_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/usecases/create_task_usecase.dart';
import 'features/tasks/domain/usecases/delete_task_usecase.dart';
import 'features/tasks/domain/usecases/get_analytics_usecase.dart';
import 'features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'features/tasks/domain/usecases/update_task_usecase.dart';
import 'features/tasks/presentation/bloc/task_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  const tokenStorage = TokenStorage(storage);
  final apiClient = ApiClient(tokenStorage);

  final authRepository = AuthRepositoryImpl(
    remoteDataSource:
        AuthRemoteDataSource(apiClient: apiClient, tokenStorage: tokenStorage),
  );
  final taskRepository = TaskRepositoryImpl(
    remoteDataSource: TaskRemoteDataSource(apiClient: apiClient),
  );

  runApp(SmartTaskManagerApp(
      authRepository: authRepository, taskRepository: taskRepository));
}

class SmartTaskManagerApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final TaskRepositoryImpl taskRepository;

  const SmartTaskManagerApp(
      {super.key, required this.authRepository, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: taskRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(
              loginUseCase: LoginUseCase(authRepository),
              registerUseCase: RegisterUseCase(authRepository),
              logoutUseCase: LogoutUseCase(authRepository),
              getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
            )..checkSession(),
          ),
          BlocProvider(
            create: (_) => TaskCubit(
              getTasksUseCase: GetTasksUseCase(taskRepository),
              createTaskUseCase: CreateTaskUseCase(taskRepository),
              updateTaskUseCase: UpdateTaskUseCase(taskRepository),
              deleteTaskUseCase: DeleteTaskUseCase(taskRepository),
              getAnalyticsUseCase: GetAnalyticsUseCase(taskRepository),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Task Manager',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF4F5FE8)),
            scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}
