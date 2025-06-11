import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindy/features/auth/domain/controllers/profile_controller.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';
import 'package:kindy/features/auth/domain/entities/profile_entities.dart';
import 'package:kindy/features/auth/auth_injection.dart';

/// Страница профиля пользователя
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _fioController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fioController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).refreshProfile();
    });
  }

  @override
  void dispose() {
    _fioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    final profileState = ref.read(profileControllerProvider);
    if (profileState.profile != null) {
      _fioController.text = profileState.profile!.fio;
      _emailController.text = profileState.profile!.email ?? '';
      _phoneController.text = profileState.profile!.phone ?? '';
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final controller = ref.read(profileControllerProvider.notifier);
        await controller.uploadAvatar(file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при выборе изображения: $e')),
      );
    }
  }

  void _checkForAuthError(String? error) {
    // Проверяем, нужно ли перенаправить на страницу входа
    if (error != null &&
        (error.contains('токен') || error.contains('авторизации'))) {
      // Показываем уведомление
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сессия истекла. Пожалуйста, войдите снова.'),
          duration: Duration(seconds: 3),
        ),
      );

      // Задержка перед переходом на страницу входа
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/login');

        // Используем ChangeNotifier напрямую
        AuthInjection.authController.logout();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    // Проверяем ошибку авторизации
    _checkForAuthError(profileState.error);

    if (profileState.profile != null && _fioController.text.isEmpty) {
      _updateControllers();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          profileState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : profileState.error != null && profileState.profile == null
              ? _buildErrorState(context, profileState.error!)
              : _buildProfileForm(context, profileState),
    );
  }

  Widget _buildProfileForm(BuildContext context, ProfileState profileState) {
    final avatarUrl = profileState.avatarUrl;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Аватар пользователя
          Center(child: _buildAvatarSection(avatarUrl)),
          const SizedBox(height: 24),

          if (profileState.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                profileState.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          // Поле ФИО
          TextFormField(
            controller: _fioController,
            decoration: const InputDecoration(
              labelText: 'ФИО',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите ваше ФИО';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Поле Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите ваш email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Пожалуйста, введите корректный email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Поле телефона
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Телефон',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите ваш телефон';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Кнопка сохранения
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child:
                profileState.isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                    : const Text('Сохранить'),
          ),

          // Кнопка обновления профиля
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              ref.read(profileControllerProvider.notifier).refreshProfile();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Обновить профиль'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(String? avatarUrl) {
    final profileState = ref.watch(profileControllerProvider);

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue.shade200,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child:
                  profileState.isUploadingAvatar
                      ? const CircularProgressIndicator()
                      : avatarUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: _pickAndUploadImage,
                ),
              ),
            ),
          ],
        ),
        if (profileState.avatarUploadSuccess)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Аватар успешно обновлен',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    // Если ошибка связана с авторизацией, показываем специальное сообщение
    final bool isAuthError =
        error.contains('токен') || error.contains('авторизации');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAuthError ? Icons.lock : Icons.error_outline,
            size: 64,
            color: isAuthError ? Colors.orange : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            isAuthError ? 'Требуется авторизация' : 'Ошибка загрузки профиля',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (isAuthError) {
                Navigator.of(context).pushReplacementNamed('/login');
              } else {
                ref.read(profileControllerProvider.notifier).refreshProfile();
              }
            },
            child: Text(isAuthError ? 'Войти' : 'Попробовать снова'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    final profileState = ref.read(profileControllerProvider);
    if (_formKey.currentState!.validate() && profileState.profile != null) {
      final updatedProfile = profileState.profile!.copyWith(
        fio: _fioController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      ref
          .read(profileControllerProvider.notifier)
          .updateProfile(updatedProfile);
    }
  }
}
