import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app_kindergarten/core/constants/app_colors.dart';
import 'package:super_app_kindergarten/core/utils/screen_util.dart';
import 'package:super_app_kindergarten/shared/widgets/adaptive_widgets.dart';

class TeacherRegisterStep1Page extends StatefulWidget {
  const TeacherRegisterStep1Page({super.key});

  @override
  State<TeacherRegisterStep1Page> createState() =>
      _TeacherRegisterStep1PageState();
}

class _TeacherRegisterStep1PageState extends State<TeacherRegisterStep1Page> {
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _iinController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _iinController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleNext() {
    // Валидация полей
    if (_lastNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите фамилию');
      return;
    }

    if (_firstNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите имя');
      return;
    }

    if (_iinController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите ИИН');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите почту');
      return;
    }

    // Переход на следующий шаг с данными
    final data = {
      'lastName': _lastNameController.text.trim(),
      'firstName': _firstNameController.text.trim(),
      'iin': _iinController.text.trim(),
      'email': _emailController.text.trim(),
    };

    context.go('/register/teacher/step2', extra: data);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.warning),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.figmaPastelGradient,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: AdaptiveLayout(
            // Мобильная версия
            mobile: Stack(
              children: [
                // Фоновое изображение
                // Positioned(
                //   bottom: -50,
                //   left: -30,
                //   child: Container(
                //     width: 146,
                //     height: 213,
                //     decoration: const BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage('assets/images/image225.png'),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),

                // Основной контент
                Center(
                  child: Container(
                    width: ScreenUtil.adaptiveValue(
                      mobile: 340.0,
                      tablet: 450.0,
                      desktop: 500.0,
                    ),
                    height: ScreenUtil.adaptiveValue(
                      mobile: 510.0,
                      tablet: 580.0,
                      desktop: 630.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        ScreenUtil.adaptiveValue(
                          mobile: 28.0,
                          tablet: 32.0,
                          desktop: 36.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Заголовок
                          Text(
                            'РЕГИСТРАЦИЯ',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: ScreenUtil.adaptiveValue(
                                mobile: 22.0,
                                tablet: 26.0,
                                desktop: 30.0,
                              ),
                              fontWeight: FontWeight.bold,
                              color: AppColors.figmaGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 33.0,
                              tablet: 38.0,
                              desktop: 42.0,
                            ),
                          ),

                          // Выбор ролей (показываем выбранную роль)
                          _buildRoleSelector(),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 28.0,
                              tablet: 32.0,
                              desktop: 36.0,
                            ),
                          ),

                          // Поля ввода
                          Expanded(
                            child: Column(
                              children: [
                                _buildInputField(
                                  _lastNameController,
                                  'Фамилия',
                                ),
                                _buildInputField(_firstNameController, 'Имя'),
                                _buildInputField(_iinController, 'ИИН'),
                                _buildInputField(_emailController, 'Почта'),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 30.0,
                              tablet: 35.0,
                              desktop: 40.0,
                            ),
                          ),

                          // Кнопка "Далее"
                          SizedBox(
                            width: ScreenUtil.adaptiveValue(
                              mobile: 250.0,
                              tablet: 280.0,
                              desktop: 310.0,
                            ),
                            height: ScreenUtil.adaptiveValue(
                              mobile: 32.0,
                              tablet: 38.0,
                              desktop: 42.0,
                            ),
                            child: ElevatedButton(
                              onPressed: _handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.figmaGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Далее',
                                style: TextStyle(
                                  fontSize: ScreenUtil.adaptiveValue(
                                    mobile: 16.0,
                                    tablet: 18.0,
                                    desktop: 20.0,
                                  ),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 16.0,
                              tablet: 20.0,
                              desktop: 24.0,
                            ),
                          ),

                          // Кнопка "Вернуться назад"
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Text(
                              'Вернуться назад',
                              style: TextStyle(
                                fontSize: ScreenUtil.adaptiveValue(
                                  mobile: 10.0,
                                  tablet: 12.0,
                                  desktop: 14.0,
                                ),
                                color: AppColors.figmaTextSecondary.withOpacity(
                                  0.5,
                                ),
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Планшетная версия
            tablet: Center(
              child: Container(
                width: 550,
                height: 680,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text(
                        'РЕГИСТРАЦИЯ',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.figmaGreen,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      _buildRoleSelector(),

                      const SizedBox(height: 30),

                      Expanded(
                        child: Column(
                          children: [
                            _buildInputField(_lastNameController, 'Фамилия'),
                            _buildInputField(_firstNameController, 'Имя'),
                            _buildInputField(_iinController, 'ИИН'),
                            _buildInputField(_emailController, 'Почта'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: 320,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.figmaGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Далее',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: const Text(
                          'Вернуться назад',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0x8084898D),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        Expanded(child: _buildRoleButton('Родитель', false)),
        SizedBox(width: 8),
        Expanded(child: _buildRoleButton('Воспитатель', true)),
        SizedBox(width: 8),
        Expanded(child: _buildRoleButton('Руководитель', false)),
      ],
    );
  }

  Widget _buildRoleButton(String label, bool isSelected) {
    return Container(
      width: double.infinity,
      height: ScreenUtil.adaptiveValue(
        mobile: 28.0,
        tablet: 32.0,
        desktop: 36.0,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.figmaGreen : Colors.transparent,
        border: Border.all(color: AppColors.figmaGreen, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 13.0,
              tablet: 15.0,
              desktop: 17.0,
            ),
            color: isSelected ? Colors.white : AppColors.figmaGreen,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String placeholder,
  ) {
    return Container(
      width: ScreenUtil.adaptiveValue(
        mobile: 250.0,
        tablet: 320.0,
        desktop: 360.0,
      ),
      height: ScreenUtil.adaptiveValue(
        mobile: 38.0,
        tablet: 44.0,
        desktop: 50.0,
      ),
      margin: EdgeInsets.only(
        bottom: ScreenUtil.adaptiveValue(
          mobile: 12.0,
          tablet: 16.0,
          desktop: 20.0,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.figmaInputBackground,
        borderRadius: BorderRadius.circular(9),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: ScreenUtil.adaptiveValue(
            mobile: 14.0,
            tablet: 16.0,
            desktop: 18.0,
          ),
          color: AppColors.figmaTextSecondary,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: ScreenUtil.adaptiveValue(
              mobile: 14.0,
              tablet: 16.0,
              desktop: 18.0,
            ),
            color: AppColors.figmaTextSecondary.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil.adaptiveValue(
              mobile: 12.0,
              tablet: 16.0,
              desktop: 20.0,
            ),
            vertical: ScreenUtil.adaptiveValue(
              mobile: 8.0,
              tablet: 10.0,
              desktop: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
