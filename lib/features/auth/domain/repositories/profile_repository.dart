import 'dart:io';
import 'package:kindy/features/auth/domain/entities/profile_entities.dart';

/// Абстрактный класс репозитория профиля пользователя
abstract class ProfileRepository {
  /// Получение профиля пользователя по ID
  Future<UserProfile> getUserProfile(int userId);

  /// Обновление профиля пользователя
  Future<UserProfile> updateUserProfile(UserProfile profile);

  /// Получение ID текущего пользователя из хранилища
  Future<int?> getCurrentUserId();

  /// Сохранение ID текущего пользователя
  Future<void> saveCurrentUserId(int userId);

  /// Получение текущего профиля пользователя
  Future<UserProfile?> getCurrentUserProfile();

  /// Загрузка аватара пользователя
  Future<bool> uploadAvatar(int userId, File avatarFile);

  /// Получение URL аватара пользователя
  String getAvatarUrl(int userId);
}
