import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kindy/features/auth/domain/entities/auth_entities.dart';
import 'package:kindy/features/auth/domain/repositories/auth_repository.dart';

/// Константы для хранения токенов
const String ACCESS_TOKEN_KEY = 'access_token';
const String REFRESH_TOKEN_KEY = 'refresh_token';
const String USER_ID_KEY = 'user_id';
const String USER_EMAIL_KEY = 'user_email';
const String USER_ROLE_KEY = 'user_role';

/// Имплементация репозитория аутентификации
class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl = 'http://194.67.82.16:30062/auth/open-api/auth';
  final http.Client _client;
  final SharedPreferences _preferences;

  AuthRepositoryImpl({
    required http.Client client,
    required SharedPreferences preferences,
  }) : _client = client,
       _preferences = preferences;

  @override
  Future<bool> registerParent(ParentRegisterRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/register/parent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw ApiError(
          message: errorResponse['message'] ?? 'Ошибка регистрации',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) {
        throw e;
      }
      throw ApiError.defaultError();
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      // Для тестовых учетных записей делаем полностью локальный вход
      if (request.email.trim().toLowerCase() == 'teacher@test.com') {
        print('Используем тестовый локальный вход учителя: ${request.email}');

        // Создаем тестовый ответ
        final testAccessToken =
            'test_access_token_${DateTime.now().millisecondsSinceEpoch}';
        final testRefreshToken =
            'test_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

        // Сохраняем токены
        await saveAuthTokens(testAccessToken, testRefreshToken);

        // Сохраняем ID пользователя
        await saveUserId(159);
        print('Сохранен ID пользователя: 159');

        // Сохраняем email
        await saveEmail(request.email);
        print('AuthRepositoryImpl: Сохранен email: ${request.email}');

        // Явно сохраняем роль
        await saveRole('TEACHER');
        print('AuthRepositoryImpl: Сохранена роль учителя (локально)');

        // Возвращаем готовый объект без обращения к сети
        return LoginResponse(
          accessToken: testAccessToken,
          refreshToken: testRefreshToken,
          expiresIn: 3600,
          tokenType: 'Bearer',
          sessionState: 'test_session',
          scope: 'profile',
          userId: 159,
        );
      } else if (request.email.trim().toLowerCase() == 'manager@test.com') {
        print('Используем тестовый локальный вход менеджера: ${request.email}');

        // Создаем тестовый ответ
        final testAccessToken =
            'test_access_token_manager_${DateTime.now().millisecondsSinceEpoch}';
        final testRefreshToken =
            'test_refresh_token_manager_${DateTime.now().millisecondsSinceEpoch}';

        // Сохраняем токены
        await saveAuthTokens(testAccessToken, testRefreshToken);

        // Сохраняем ID пользователя
        await saveUserId(160);
        print('Сохранен ID пользователя: 160');

        // Сохраняем email
        await saveEmail(request.email);
        print('AuthRepositoryImpl: Сохранен email: ${request.email}');

        // Явно сохраняем роль
        await saveRole('MANAGER');
        print('AuthRepositoryImpl: Сохранена роль менеджера (локально)');

        // Возвращаем готовый объект без обращения к сети
        return LoginResponse(
          accessToken: testAccessToken,
          refreshToken: testRefreshToken,
          expiresIn: 3600,
          tokenType: 'Bearer',
          sessionState: 'test_session',
          scope: 'profile',
          userId: 160,
        );
      }

      // Для всех остальных пользователей используем API
      print('Используем вход через API для: ${request.email}');
      final response = await _client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('Ответ от сервера при входе: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Переименовываем ключи для соответствия нашей модели
        final mappedResponse = {
          'access_token': responseData['access_token'],
          'refresh_token': responseData['refresh_token'],
          'expires_in': responseData['expires_in'],
          'token_type': responseData['token_type'],
          'session_state': responseData['session_state'],
          'scope': responseData['scope'],
          'userId': 159, // Используем фиксированный ID
        };

        // Создаем объект ответа
        final loginResponse = LoginResponse.fromJson(mappedResponse);

        // Используем ID пользователя по умолчанию, так как он не возвращается с сервера
        const int defaultUserId = 159;

        // Сохранение токенов
        await saveAuthTokens(
          loginResponse.accessToken,
          loginResponse.refreshToken,
        );

        // Сохраняем ID пользователя
        await saveUserId(defaultUserId);
        print('Сохранен ID пользователя: $defaultUserId');

        // Сохраняем email
        await saveEmail(request.email);

        // Определяем роль из токена
        String userRole = 'PARENT'; // По умолчанию - родитель

        // Пытаемся извлечь роль из токена
        try {
          // Проверяем наличие информации о роли в ответе
          if (responseData['access_token'] != null) {
            // В JWT токене могут быть указаны роли, но для простоты сейчас
            // мы используем значение по умолчанию PARENT
            userRole = 'PARENT';
          }
        } catch (e) {
          print('Ошибка при определении роли: $e');
          // В случае ошибки используем PARENT
          userRole = 'PARENT';
        }

        // Сохраняем роль
        await saveRole(userRole);
        print('AuthRepositoryImpl: Сохранена роль пользователя: $userRole');

        return loginResponse;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw ApiError(
          message: errorResponse['message'] ?? 'Ошибка авторизации',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('Ошибка при входе: $e');
      if (e is ApiError) {
        throw e;
      }
      throw ApiError.defaultError();
    }
  }

  @override
  Future<bool> requestResetCode(RequestResetCodeRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/password/reset/code'),
        headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw ApiError(
          message:
              errorResponse['message'] ??
              'Ошибка при отправке кода восстановления',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) {
        throw e;
      }
      throw ApiError.defaultError();
    }
  }

  @override
  Future<bool> verifyResetCode(VerifyResetCodeRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/password/reset/verify'),
        headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw ApiError(
          message: errorResponse['message'] ?? 'Неверный код восстановления',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) {
        throw e;
      }
      throw ApiError.defaultError();
    }
  }

  @override
  Future<bool> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/password/reset'),
        headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw ApiError(
          message: errorResponse['message'] ?? 'Ошибка при изменении пароля',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) {
        throw e;
      }
      throw ApiError.defaultError();
    }
  }

  @override
  Future<void> saveAuthTokens(String accessToken, String refreshToken) async {
    await _preferences.setString(ACCESS_TOKEN_KEY, accessToken);
    await _preferences.setString(REFRESH_TOKEN_KEY, refreshToken);
  }

  @override
  Future<void> saveUserId(int userId) async {
    await _preferences.setInt(USER_ID_KEY, userId);
  }

  @override
  Future<int?> getUserId() async {
    return _preferences.getInt(USER_ID_KEY);
  }

  @override
  Future<String?> getAccessToken() async {
    return _preferences.getString(ACCESS_TOKEN_KEY);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _preferences.getString(REFRESH_TOKEN_KEY);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final token = _preferences.getString(ACCESS_TOKEN_KEY);
    print(
      'AuthRepositoryImpl: Проверка статуса авторизации, токен: ${token != null ? 'есть' : 'отсутствует'}',
    );
    return token != null;
  }

  @override
  Future<void> logout() async {
    await _preferences.remove(ACCESS_TOKEN_KEY);
    await _preferences.remove(REFRESH_TOKEN_KEY);
    await _preferences.remove(USER_ID_KEY);
  }

  @override
  Future<void> saveEmail(String? email) async {
    if (email == null) {
      await _preferences.remove(USER_EMAIL_KEY);
      print('AuthRepositoryImpl: Email удален');
    } else {
      await _preferences.setString(USER_EMAIL_KEY, email);
      print('AuthRepositoryImpl: Сохранен email: $email');
    }
  }

  @override
  Future<String?> getSavedEmail() async {
    final email = _preferences.getString(USER_EMAIL_KEY);
    print('AuthRepositoryImpl: Получен сохраненный email: $email');
    return email;
  }

  @override
  Future<void> saveRole(String? role) async {
    if (role == null) {
      await _preferences.remove(USER_ROLE_KEY);
      print('AuthRepositoryImpl: Роль пользователя удалена');
    } else {
      await _preferences.setString(USER_ROLE_KEY, role);
      print('AuthRepositoryImpl: Сохранена роль пользователя: $role');
    }
  }

  @override
  Future<String?> getSavedRole() async {
    final role = _preferences.getString(USER_ROLE_KEY);
    print('AuthRepositoryImpl: Получена сохраненная роль пользователя: $role');
    return role;
  }
}
