import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kindy/features/auth/domain/entities/auth_entities.dart';
import 'package:kindy/features/auth/domain/entities/profile_entities.dart';
import 'package:kindy/features/auth/domain/repositories/profile_repository.dart';
import 'package:kindy/features/auth/domain/repositories/auth_repository.dart';

/// Константа для хранения ID пользователя
const String USER_ID_KEY = 'current_user_id';

/// Имплементация репозитория профиля
class ProfileRepositoryImpl implements ProfileRepository {
  final String baseUrl = 'http://194.67.82.16:30062/profile/api/user';
  final String avatarUploadUrl = 'http://194.67.82.16:8084/api/user';
  final http.Client _client;
  final SharedPreferences _preferences;
  final AuthRepository _authRepository;

  // Кэш профиля для оптимизации запросов
  UserProfile? _cachedProfile;
  int? _cachedUserId;

  ProfileRepositoryImpl({
    required http.Client client,
    required SharedPreferences preferences,
    required AuthRepository authRepository,
  }) : _client = client,
       _preferences = preferences,
       _authRepository = authRepository;

  @override
  Future<UserProfile> getUserProfile(int userId) async {
    try {
      // Проверяем, изменился ли ID пользователя с момента последнего запроса
      if (_cachedProfile != null && _cachedUserId == userId) {
        print('Возвращаем кэшированный профиль для userId: $userId');
        return _cachedProfile!;
      }

      final token = await _authRepository.getAccessToken();

      if (token == null || token.isEmpty) {
        throw ApiError(
          message: 'Отсутствует токен авторизации. Пожалуйста, войдите снова',
          statusCode: 401,
        );
      }

      print('Запрос профиля для userId: $userId');
      print('URL: $baseUrl/$userId');

      final response = await _client.get(
        Uri.parse('$baseUrl/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Код ответа: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final profile = UserProfile.fromJson(jsonData);

        // Кэшируем полученный профиль
        _cachedProfile = profile;
        _cachedUserId = userId;

        return profile;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw ApiError(
          message:
              errorResponse['message'] ??
              'Ошибка получения профиля: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('Ошибка при получении профиля: $e');
      if (e is ApiError) {
        throw e;
      }
      throw ApiError(
        message: 'Ошибка при получении профиля: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      final token = await _authRepository.getAccessToken();

      if (token == null || token.isEmpty) {
        throw ApiError(
          message: 'Отсутствует токен авторизации. Пожалуйста, войдите снова',
          statusCode: 401,
        );
      }

      final response = await _client.put(
        Uri.parse('$baseUrl/${profile.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final updatedProfile = UserProfile.fromJson(jsonData);

        // Обновляем кэш
        _cachedProfile = updatedProfile;
        _cachedUserId = updatedProfile.id;

        return updatedProfile;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw ApiError(
          message: errorResponse['message'] ?? 'Ошибка обновления профиля',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) {
        throw e;
      }
      throw ApiError(
        message: 'Ошибка при обновлении профиля: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<int?> getCurrentUserId() async {
    // Получаем ID пользователя из AuthRepository
    return _authRepository.getUserId();
  }

  @override
  Future<void> saveCurrentUserId(int userId) async {
    // Сохраняем ID пользователя с помощью AuthRepository
    await _authRepository.saveUserId(userId);

    // Очищаем кэш при смене пользователя
    if (_cachedUserId != userId) {
      _cachedProfile = null;
      _cachedUserId = null;
    }
  }

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final userId = await getCurrentUserId();
      print('getCurrentUserProfile: ID пользователя из хранилища: $userId');

      if (userId == null || userId <= 0) {
        throw ApiError(
          message: 'ID пользователя не найден или некорректен',
          statusCode: 400,
        );
      }

      return getUserProfile(userId);
    } catch (e) {
      print('Ошибка в getCurrentUserProfile: $e');
      rethrow;
    }
  }

  @override
  Future<bool> uploadAvatar(int userId, File avatarFile) async {
    try {
      final token = await _authRepository.getAccessToken();

      if (token == null || token.isEmpty) {
        throw ApiError(
          message: 'Отсутствует токен авторизации. Пожалуйста, войдите снова',
          statusCode: 401,
        );
      }

      // Создаем multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$avatarUploadUrl/$userId/avatar'),
      );

      // Добавляем заголовок авторизации
      request.headers['Authorization'] = 'Bearer $token';

      // Добавляем файл аватара
      request.files.add(
        await http.MultipartFile.fromPath('file', avatarFile.path),
      );

      print('Отправка аватара для userId: $userId');
      print('URL: $avatarUploadUrl/$userId/avatar');

      // Отправляем запрос
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Код ответа при загрузке аватара: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Сбрасываем кэш профиля, чтобы при следующем запросе получить обновленные данные
        _cachedProfile = null;
        return true;
      } else {
        print('Ошибка при загрузке аватара: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Исключение при загрузке аватара: $e');
      return false;
    }
  }

  @override
  String getAvatarUrl(int userId) {
    // Добавляем timestamp для обхода кэширования изображения
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$baseUrl/$userId/avatar?t=$timestamp';
  }
}
