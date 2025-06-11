import 'package:kindy/features/auth/domain/entities/auth_entities.dart';

/// Интерфейс репозитория для работы с аутентификацией
abstract class AuthRepository {
  /// Регистрация родителя
  Future<bool> registerParent(ParentRegisterRequest request);

  /// Авторизация пользователя
  Future<LoginResponse> login(LoginRequest request);

  /// Выход из аккаунта
  Future<void> logout();

  /// Запрос кода восстановления пароля
  Future<bool> requestResetCode(RequestResetCodeRequest request);

  /// Проверка кода восстановления
  Future<bool> verifyResetCode(VerifyResetCodeRequest request);

  /// Сброс пароля
  Future<bool> resetPassword(ResetPasswordRequest request);

  /// Проверка статуса авторизации
  Future<bool> isUserLoggedIn();

  /// Сохранение токенов авторизации
  Future<void> saveAuthTokens(String accessToken, String refreshToken);

  /// Получение токена доступа
  Future<String?> getAccessToken();

  /// Получение токена обновления
  Future<String?> getRefreshToken();

  /// Сохранение ID пользователя
  Future<void> saveUserId(int userId);

  /// Получение ID пользователя
  Future<int?> getUserId();

  /// Сохранение email пользователя
  Future<void> saveEmail(String? email);

  /// Получение сохраненного email пользователя
  Future<String?> getSavedEmail();

  /// Сохранение роли пользователя
  Future<void> saveRole(String? role);

  /// Получение сохраненной роли пользователя
  Future<String?> getSavedRole();
}
