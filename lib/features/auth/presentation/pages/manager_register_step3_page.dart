import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app_kindergarten/core/constants/app_colors.dart';
import 'package:super_app_kindergarten/core/utils/screen_util.dart';
import 'package:super_app_kindergarten/shared/widgets/adaptive_widgets.dart';

class ManagerRegisterStep3Page extends StatefulWidget {
  final Map<String, dynamic>? previousData;

  const ManagerRegisterStep3Page({super.key, this.previousData});

  @override
  State<ManagerRegisterStep3Page> createState() =>
      _ManagerRegisterStep3PageState();
}

class _ManagerRegisterStep3PageState extends State<ManagerRegisterStep3Page> {
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _settlementController = TextEditingController();
  final _streetController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _regionController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _settlementController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _handleComplete() {
    // Валидация полей
    if (_regionController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите регион');
      return;
    }

    if (_cityController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите город');
      return;
    }

    if (_districtController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите район');
      return;
    }

    if (_settlementController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите населенный пункт');
      return;
    }

    if (_streetController.text.trim().isEmpty) {
      _showErrorSnackBar('Пожалуйста, введите улицу');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Объединяем все данные
    final finalData = {
      ...widget.previousData ?? {},
      'region': _regionController.text.trim(),
      'city': _cityController.text.trim(),
      'district': _districtController.text.trim(),
      'settlement': _settlementController.text.trim(),
      'street': _streetController.text.trim(),
    };

    // Симулируем регистрацию
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Показываем сообщение об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Регистрация руководителя успешно завершена!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Переходим в dashboard
      context.go('/dashboard');
    });
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
                //   right: -50,
                //   child: Container(
                //     width: 142,
                //     height: 178,
                //     decoration: const BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage('assets/images/image221.png'),
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
                      mobile: 550.0,
                      tablet: 620.0,
                      desktop: 680.0,
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
                              mobile: 20.0,
                              tablet: 24.0,
                              desktop: 28.0,
                            ),
                          ),

                          // Выбор ролей (показываем выбранную роль)
                          _buildRoleSelector(),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 20.0,
                              tablet: 24.0,
                              desktop: 28.0,
                            ),
                          ),

                          // Поля ввода
                          Expanded(
                            child: Column(
                              children: [
                                _buildInputField(_regionController, 'Регион'),
                                _buildInputField(_cityController, 'Город'),
                                _buildInputField(_districtController, 'Район'),
                                _buildInputField(
                                  _settlementController,
                                  'Населенный пункт',
                                ),
                                _buildInputField(_streetController, 'Улица'),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: ScreenUtil.adaptiveValue(
                              mobile: 20.0,
                              tablet: 24.0,
                              desktop: 28.0,
                            ),
                          ),

                          // Кнопка "Завершить регистрацию"
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
                              onPressed: _isLoading ? null : _handleComplete,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.figmaGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                              ),
                              child:
                                  _isLoading
                                      ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        'Завершить',
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
                            onTap: () => context.go('/register/manager/step2'),
                            child: Text(
                              'Вернуться назад',
                              style: TextStyle(
                                fontSize: ScreenUtil.adaptiveValue(
                                  mobile: 10.0,
                                  tablet: 12.0,
                                  desktop: 14.0,
                                ),
                                color: AppColors.figmaTextSecondary,
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
                height: 720,
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

                      const SizedBox(height: 30),

                      _buildRoleSelector(),

                      const SizedBox(height: 25),

                      Expanded(
                        child: Column(
                          children: [
                            _buildInputField(_regionController, 'Регион'),
                            _buildInputField(_cityController, 'Город'),
                            _buildInputField(_districtController, 'Район'),
                            _buildInputField(
                              _settlementController,
                              'Населенный пункт',
                            ),
                            _buildInputField(_streetController, 'Улица'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: 320,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleComplete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.figmaGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            elevation: 0,
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Завершить',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () => context.go('/register/manager/step2'),
                        child: const Text(
                          'Вернуться назад',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF84898D),
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
        Expanded(child: _buildRoleButton('Воспитатель', false)),
        SizedBox(width: 8),
        Expanded(child: _buildRoleButton('Руководитель', true)),
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
