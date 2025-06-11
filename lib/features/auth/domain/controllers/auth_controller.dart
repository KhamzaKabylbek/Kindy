import 'package:flutter/material.dart';
import 'package:kindy/features/auth/domain/entities/auth_entities.dart';
import 'package:kindy/features/auth/domain/repositories/auth_repository.dart';

/// Состояния аутентификации
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Состояния восстановления пароля
enum PasswordResetState {
  initial,
  codeSent,
  codeVerified,
  passwordChanged,
  error,
}

/// Контроллер аутентификации
class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  PasswordResetState _resetState = PasswordResetState.initial;
  PasswordResetState get resetState => _resetState;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;

  UserDetails? _userDetails;
  UserDetails? get userDetails => _userDetails;

  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;

  bool _isProcessingReset = false;
  bool get isProcessingReset => _isProcessingReset;

  String? _resetEmail;
  String? get resetEmail => _resetEmail;

  int? _resetCode;
  int? get resetCode => _resetCode;

  AuthController({required AuthRepository repository})
    : _repository = repository {
    checkAuthStatus();
  }

  /// Проверка статуса аутентификации
  Future<void> checkAuthStatus() async {
    _state = AuthState.loading;
    notifyListeners();

    final isLoggedIn = await _repository.isUserLoggedIn();
    print(
      'AuthController: Проверка состояния авторизации: ${isLoggedIn ? 'авторизован' : 'не авторизован'}',
    );

    if (isLoggedIn) {
      // Если пользователь авторизован, загружаем данные пользователя
      final userId = await _repository.getUserId();
      print('AuthController: ID пользователя: $userId');

      // Проверка наличия сохраненных данных о роли пользователя
      final savedEmail = await _repository.getSavedEmail();
      print('AuthController: Сохраненный email: $savedEmail');

      // Получаем сохраненную роль (приоритетный источник)
      final savedRole = await _repository.getSavedRole();
      print('AuthController: Сохраненная роль: $savedRole');

      String role;
      String name;

      // Если роль сохранена явно, используем её
      if (savedRole != null && savedRole.isNotEmpty) {
        role = savedRole;
        name = savedRole == 'TEACHER' ? 'Анна Ивановна' : 'Родитель';
        print('AuthController: Используем сохраненную роль: $role');
      }
      // Иначе пытаемся определить по email
      else if (savedEmail == 'teacher@test.com') {
        print('AuthController: Установка роли TEACHER при проверке (по email)');
        role = 'TEACHER';
        name = 'Анна Ивановна';

        // Сохраняем роль для следующих проверок
        await _repository.saveRole(role);
      } else {
        print(
          'AuthController: Установка роли PARENT при проверке (по умолчанию)',
        );
        role = 'PARENT';
        name = 'Родитель';

        // Сохраняем роль для следующих проверок
        await _repository.saveRole(role);
      }

      _userDetails = UserDetails(
        id: userId?.toString() ?? '0',
        email: savedEmail ?? '',
        role: role,
        name: name,
      );

      print(
        'AuthController: userDetails после проверки: ${_userDetails?.toJson()}',
      );
      _state = AuthState.authenticated;
    } else {
      _userDetails = null;
      _state = AuthState.unauthenticated;
    }

    notifyListeners();
  }

  /// Регистрация родителя
  Future<bool> registerParent({
    required String lastName,
    required String firstName,
    required String iin,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isRegistering = true;
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Формирование полного ФИО
      final fio = '$lastName $firstName';

      final request = ParentRegisterRequest(
        fio: fio,
        iin: iin,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      final result = await _repository.registerParent(request);
      _isRegistering = false;
      _state = AuthState.unauthenticated;
      notifyListeners();
      return result;
    } catch (e) {
      _isRegistering = false;
      _state = AuthState.error;
      _errorMessage =
          e is ApiError ? e.message : 'Произошла ошибка при регистрации';
      notifyListeners();
      return false;
    }
  }

  /// Авторизация пользователя
  Future<bool> login({required String email, required String password}) async {
    _state = AuthState.loading;
    _errorMessage = null;

    // Сначала выходим из текущей сессии, если такая есть
    await _repository.logout();
    _loginResponse = null;
    _userDetails = null;

    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);

      _loginResponse = await _repository.login(request);

      // Сохраняем email пользователя
      await _repository.saveEmail(email);
      print('AuthController: Email сохранен: $email');

      // Безопасный вывод токена
      print('AuthController: Успешный вход');
      if (_loginResponse?.accessToken != null &&
          _loginResponse!.accessToken.isNotEmpty) {
        print(
          'AuthController: Полученный токен: ${_loginResponse!.accessToken.substring(0, _loginResponse!.accessToken.length > 20 ? 20 : _loginResponse!.accessToken.length)}...',
        );
      } else {
        print('AuthController: Токен не получен или пустой');
      }

      // Получаем ID пользователя из репозитория, так как он не содержится в ответе API
      final userId = await _repository.getUserId();
      print('AuthController: ID пользователя: $userId');

      // Устанавливаем тестовые данные пользователя
      String role;
      String name;

      if (email.toLowerCase() == 'teacher@test.com') {
        print('AuthController: Установка роли TEACHER');
        role = 'TEACHER';
        name = 'Анна Ивановна';

        // Явно сохраняем роль для избежания ошибок при перезагрузке страницы
        await _repository.saveRole(role);
      } else if (email.toLowerCase() == 'manager@test.com') {
        print('AuthController: Установка роли MANAGER');
        role = 'MANAGER';
        name = 'Алия Каримовна';

        // Явно сохраняем роль для избежания ошибок при перезагрузке страницы
        await _repository.saveRole(role);
      } else {
        print('AuthController: Установка роли PARENT');
        role = 'PARENT';
        name = 'Родитель';

        // Явно сохраняем роль для избежания ошибок при перезагрузке страницы
        await _repository.saveRole(role);
      }

      _userDetails = UserDetails(
        id: userId.toString(),
        email: email,
        role: role,
        name: name,
      );

      print(
        'AuthController: userDetails после входа: ${_userDetails?.toJson()}',
      );

      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _loginResponse = null;
      _userDetails = null;
      _state = AuthState.error;
      _errorMessage =
          e is ApiError
              ? e.message
              : 'Произошла ошибка при входе. Пожалуйста, повторите попытку позже.';
      notifyListeners();
      return false;
    }
  }

  /// Запрос кода восстановления пароля
  Future<bool> requestResetCode({required String email}) async {
    _isProcessingReset = true;
    _resetState = PasswordResetState.initial;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = RequestResetCodeRequest(email: email);

      final result = await _repository.requestResetCode(request);
      if (result) {
        _resetEmail = email;
        _resetState = PasswordResetState.codeSent;
      }

      _isProcessingReset = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isProcessingReset = false;
      _resetState = PasswordResetState.error;
      _errorMessage =
          e is ApiError ? e.message : 'Произошла ошибка при отправке кода';
      notifyListeners();
      return false;
    }
  }

  /// Проверка кода восстановления
  Future<bool> verifyResetCode({required int code}) async {
    if (_resetEmail == null) {
      _errorMessage = 'Не указан email для восстановления пароля';
      return false;
    }

    _isProcessingReset = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = VerifyResetCodeRequest(
        email: _resetEmail!,
        resetCode: code,
      );

      final result = await _repository.verifyResetCode(request);
      if (result) {
        _resetCode = code;
        _resetState = PasswordResetState.codeVerified;
      }

      _isProcessingReset = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isProcessingReset = false;
      _resetState = PasswordResetState.error;
      _errorMessage = e is ApiError ? e.message : 'Неверный код подтверждения';
      notifyListeners();
      return false;
    }
  }

  /// Сброс пароля
  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (_resetEmail == null || _resetCode == null) {
      _errorMessage = 'Не указаны данные для восстановления пароля';
      return false;
    }

    _isProcessingReset = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = ResetPasswordRequest(
        email: _resetEmail!,
        resetCode: _resetCode!,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      final result = await _repository.resetPassword(request);
      if (result) {
        _resetState = PasswordResetState.passwordChanged;
        // Очищаем данные для восстановления
        _resetEmail = null;
        _resetCode = null;
      }

      _isProcessingReset = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isProcessingReset = false;
      _resetState = PasswordResetState.error;
      _errorMessage =
          e is ApiError ? e.message : 'Произошла ошибка при сбросе пароля';
      notifyListeners();
      return false;
    }
  }

  /// Очистка состояния восстановления пароля
  void clearResetState() {
    _resetState = PasswordResetState.initial;
    _resetEmail = null;
    _resetCode = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Выход из системы
  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    await _repository.logout();
    await _repository.saveEmail(null);
    await _repository.saveRole(null);

    _loginResponse = null;
    _userDetails = null;
    _state = AuthState.unauthenticated;

    notifyListeners();
  }
}
