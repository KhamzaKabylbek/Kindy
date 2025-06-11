// Модели для запросов и ответов API аутентификации

// Запрос на регистрацию родителя
class ParentRegisterRequest {
  final String fio;
  final String iin;
  final String email;
  final String password;
  final String confirmPassword;

  ParentRegisterRequest({
    required this.fio,
    required this.iin,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'fio': fio,
      'iin': iin,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

// Запрос на вход
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

// Ответ после успешного входа
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final String sessionState;
  final String scope;
  final int userId;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    required this.sessionState,
    required this.scope,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Извлекаем ID пользователя из JWT токена или используем значение по умолчанию
    int userId = json['userId'] ?? 0;

    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
      tokenType: json['token_type'] ?? 'Bearer',
      sessionState: json['session_state'] ?? '',
      scope: json['scope'] ?? '',
      userId: userId,
    );
  }
}

// Детали пользователя
class UserDetails {
  final String id;
  final String email;
  final String role;
  final String? name;

  UserDetails({
    required this.id,
    required this.email,
    required this.role,
    this.name,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'role': role, 'name': name};
  }
}

// Запрос на отправку кода восстановления пароля
class RequestResetCodeRequest {
  final String email;

  RequestResetCodeRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

// Запрос на проверку кода восстановления
class VerifyResetCodeRequest {
  final String email;
  final int resetCode;

  VerifyResetCodeRequest({required this.email, required this.resetCode});

  Map<String, dynamic> toJson() {
    return {'email': email, 'resetCode': resetCode};
  }
}

// Запрос на сброс пароля
class ResetPasswordRequest {
  final String email;
  final int resetCode;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.email,
    required this.resetCode,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'resetCode': resetCode,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

// Ответ об ошибке
class ApiError {
  final String message;
  final int statusCode;

  ApiError({required this.message, required this.statusCode});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] ?? 'Неизвестная ошибка',
      statusCode: json['statusCode'] ?? 500,
    );
  }

  factory ApiError.defaultError() {
    return ApiError(
      message: 'Произошла ошибка при подключении к серверу',
      statusCode: 500,
    );
  }
}
