import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kindy/features/auth/domain/entities/auth_entities.dart';
import 'package:kindy/features/auth/domain/entities/profile_entities.dart';
import 'package:kindy/features/auth/domain/repositories/profile_repository.dart';

/// Состояние профиля пользователя
@immutable
class ProfileState {
  final bool isLoading;
  final UserProfile? profile;
  final String? error;
  final bool isUploadingAvatar;
  final bool avatarUploadSuccess;
  final String? avatarUrl;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.error,
    this.isUploadingAvatar = false,
    this.avatarUploadSuccess = false,
    this.avatarUrl,
  });

  /// Создание копии с новыми значениями
  ProfileState copyWith({
    bool? isLoading,
    UserProfile? profile,
    String? error,
    bool? isUploadingAvatar,
    bool? avatarUploadSuccess,
    String? avatarUrl,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      avatarUploadSuccess: avatarUploadSuccess ?? this.avatarUploadSuccess,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

/// Контроллер профиля
class ProfileController extends StateNotifier<ProfileState> {
  final ProfileRepository _profileRepository;
  int? _currentUserId;

  ProfileController({required ProfileRepository repository})
    : _profileRepository = repository,
      super(const ProfileState()) {
    _fetchCurrentProfile();
  }

  /// Получение текущего профиля пользователя
  Future<void> _fetchCurrentProfile() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final userId = await _profileRepository.getCurrentUserId();
      print('Получен ID пользователя: $userId');

      // Если ID пользователя изменился или не определен, сбрасываем состояние
      if (_currentUserId != userId) {
        _currentUserId = userId;
        state = const ProfileState(isLoading: true);
      }

      if (userId == null || userId <= 0) {
        state = state.copyWith(
          isLoading: false,
          profile: null,
          error: 'ID пользователя не найден или некорректен',
          avatarUrl: null,
        );
        return;
      }

      final profile = await _profileRepository.getUserProfile(userId);
      if (profile != null) {
        final avatarUrl = _profileRepository.getAvatarUrl(profile.id);
        state = state.copyWith(
          isLoading: false,
          profile: profile,
          error: null,
          avatarUrl: avatarUrl,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          profile: null,
          error: 'Не удалось получить профиль пользователя',
          avatarUrl: null,
        );
      }
    } catch (e) {
      final errorMessage =
          e is ApiError
              ? e.message
              : 'Ошибка при получении профиля: ${e.toString()}';
      state = state.copyWith(
        isLoading: false,
        profile: null,
        error: errorMessage,
        avatarUrl: null,
      );
    }
  }

  /// Обновление профиля пользователя
  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final result = await _profileRepository.updateUserProfile(updatedProfile);

      // Обновляем аватарURL с временной меткой для предотвращения кэширования
      final avatarUrl = _profileRepository.getAvatarUrl(result.id);

      state = state.copyWith(
        isLoading: false,
        profile: result,
        avatarUrl: avatarUrl,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка при обновлении профиля: ${e.toString()}',
      );
    }
  }

  /// Загрузка аватара пользователя
  Future<void> uploadAvatar(File avatarFile) async {
    try {
      if (state.profile == null) {
        state = state.copyWith(
          error: 'Невозможно загрузить аватар: профиль не загружен',
        );
        return;
      }

      state = state.copyWith(
        isUploadingAvatar: true,
        error: null,
        avatarUploadSuccess: false,
      );

      final userId = state.profile!.id;
      final success = await _profileRepository.uploadAvatar(userId, avatarFile);

      if (success) {
        // Обновляем URL аватара с новой временной меткой
        final avatarUrl = _profileRepository.getAvatarUrl(userId);

        state = state.copyWith(
          isUploadingAvatar: false,
          avatarUploadSuccess: true,
          avatarUrl: avatarUrl,
        );

        // Обновляем профиль, чтобы получить последние данные
        await refreshProfile();
      } else {
        state = state.copyWith(
          isUploadingAvatar: false,
          avatarUploadSuccess: false,
          error: 'Не удалось загрузить аватар',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUploadingAvatar: false,
        avatarUploadSuccess: false,
        error: 'Ошибка при загрузке аватара: ${e.toString()}',
      );
    }
  }

  /// Обновление профиля пользователя
  Future<void> refreshProfile() async {
    await _fetchCurrentProfile();
  }

  /// Получение URL аватара для текущего пользователя
  String? getAvatarUrl() {
    if (state.profile == null) return null;
    return state.avatarUrl;
  }

  /// Очистка данных профиля (например, при выходе из системы)
  void clearProfile() {
    _currentUserId = null;
    state = const ProfileState();
  }
}

/// Provider для контроллера профиля
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return ProfileController(repository: repository);
    });

/// Provider для репозитория профиля
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  throw UnimplementedError('Репозиторий профиля должен быть переопределен');
});
