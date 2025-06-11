import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kindy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kindy/features/auth/data/repositories/profile_repository_impl.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';
import 'package:kindy/features/auth/domain/controllers/profile_controller.dart';
import 'package:kindy/features/auth/domain/repositories/auth_repository.dart';
import 'package:kindy/features/auth/domain/repositories/profile_repository.dart';

/// Фабрика для создания экземпляров модуля аутентификации
class AuthInjection {
  static AuthRepository? _authRepository;
  static ProfileRepository? _profileRepository;
  static AuthController? _authController;

  /// Инициализация модуля аутентификации
  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    final client = http.Client();

    _authRepository = AuthRepositoryImpl(
      client: client,
      preferences: preferences,
    );

    _profileRepository = ProfileRepositoryImpl(
      client: client,
      preferences: preferences,
      authRepository: _authRepository!,
    );

    _authController = AuthController(repository: _authRepository!);
  }

  /// Получение экземпляра репозитория аутентификации
  static AuthRepository get authRepository {
    if (_authRepository == null) {
      throw Exception(
        'AuthRepository не инициализирован. Вызовите AuthInjection.init()',
      );
    }
    return _authRepository!;
  }

  /// Получение экземпляра репозитория профиля
  static ProfileRepository get profileRepository {
    if (_profileRepository == null) {
      throw Exception(
        'ProfileRepository не инициализирован. Вызовите AuthInjection.init()',
      );
    }
    return _profileRepository!;
  }

  /// Получение экземпляра контроллера аутентификации
  static AuthController get authController {
    if (_authController == null) {
      throw Exception(
        'AuthController не инициализирован. Вызовите AuthInjection.init()',
      );
    }
    return _authController!;
  }

  /// Провайдеры для модуля аутентификации
  static List<provider.ChangeNotifierProvider> get providers {
    return [
      provider.ChangeNotifierProvider<AuthController>.value(
        value: authController,
      ),
    ];
  }

  /// Переопределения провайдеров для Riverpod
  static List<Override> get riverpodOverrides {
    return [
      profileRepositoryProvider.overrideWith((ref) => profileRepository),
      authControllerProvider.overrideWith(
        (ref) => AuthController(repository: authRepository),
      ),
    ];
  }
}

/// Provider для Shared Preferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'Provider должен быть переопределен перед использованием',
  );
});

/// Provider для HTTP-клиента
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Provider для репозитория аутентификации
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepositoryImpl(client: client, preferences: prefs);
});

/// Provider для репозитория профиля
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return ProfileRepositoryImpl(
    client: client,
    preferences: prefs,
    authRepository: authRepository,
  );
});

/// Provider для контроллера аутентификации
final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final controller = AuthController(repository: repository);

  // Слушаем изменения состояния авторизации и очищаем профиль при выходе
  controller.addListener(() {
    if (controller.state == AuthState.unauthenticated) {
      // Очищаем данные профиля при выходе из системы
      try {
        ref.read(profileControllerProvider.notifier).clearProfile();
      } catch (e) {
        print('Ошибка при очистке профиля: $e');
      }
    }
  });

  return controller;
});

/// Функция для инициализации зависимостей
Future<ProviderContainer> initializeDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWith((ref) => prefs)],
  );

  // Инициализация контроллеров
  container.read(authControllerProvider);

  return container;
}
