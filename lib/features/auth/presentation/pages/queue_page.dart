import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app_kindergarten/core/constants/app_colors.dart';
import 'package:super_app_kindergarten/core/constants/app_dimensions.dart';
import 'package:super_app_kindergarten/core/constants/app_text_styles.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  int _currentStep = 0;
  final _childNameController = TextEditingController();
  final _childBirthController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _childNameController.dispose();
    _childBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Постановка в очередь'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(child: _buildCurrentStepContent()),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.padding16,
        horizontal: AppDimensions.padding24,
      ),
      color: AppColors.backgroundPrimary,
      child: Row(
        children: [
          _buildStepIndicator(0, 'Данные ребенка', _currentStep >= 0),
          _buildSeparator(_currentStep >= 1),
          _buildStepIndicator(1, 'Документы', _currentStep >= 1),
          _buildSeparator(_currentStep >= 2),
          _buildStepIndicator(2, 'Подтверждение', _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primary : Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : Colors.grey.shade600,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(bool isActive) {
    return Container(
      width: 30,
      height: 2,
      color: isActive ? AppColors.primary : Colors.grey.shade300,
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildChildInfoStep();
      case 1:
        return _buildDocumentsStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return Container();
    }
  }

  Widget _buildChildInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.padding24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Данные ребенка', style: AppTextStyles.h2),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            'Введите информацию о ребенке для постановки в очередь',
            style: AppTextStyles.body2,
          ),
          const SizedBox(height: AppDimensions.padding24),
          TextField(
            controller: _childNameController,
            decoration: InputDecoration(
              labelText: 'ФИО ребенка',
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          GestureDetector(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 7),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  _childBirthController.text =
                      '${pickedDate.day}.${pickedDate.month}.${pickedDate.year}';
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: _childBirthController,
                decoration: InputDecoration(
                  labelText: 'Дата рождения',
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.padding24),
          _buildDropdown('Выберите детский сад', [
            'Балдаурен',
            'Солнышко',
            'Радость',
          ]),
          const SizedBox(height: AppDimensions.spacingMedium),
          _buildDropdown('Выберите группу', ['Младшая', 'Средняя', 'Старшая']),
          const SizedBox(height: AppDimensions.padding40),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
            child: Text('Продолжить', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          icon: const Icon(Icons.arrow_drop_down),
          items:
              items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (String? newValue) {},
        ),
      ),
    );
  }

  Widget _buildDocumentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.padding24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Загрузка документов', style: AppTextStyles.h2),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            'Загрузите необходимые документы для постановки в очередь',
            style: AppTextStyles.body2,
          ),
          const SizedBox(height: AppDimensions.padding24),
          _buildDocumentUploadCard('Свидетельство о рождении'),
          const SizedBox(height: AppDimensions.spacingMedium),
          _buildDocumentUploadCard('Удостоверение личности родителя'),
          const SizedBox(height: AppDimensions.spacingMedium),
          _buildDocumentUploadCard('Медицинская справка'),
          const SizedBox(height: AppDimensions.padding40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 0;
                    });
                  },
                  child: const Text('Назад'),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 2;
                    });
                  },
                  child: const Text('Продолжить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadCard(String title) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    'Перетащите файл или',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('выберите на устройстве'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.padding24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Подтверждение заявки', style: AppTextStyles.h2),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            'Проверьте введенные данные перед отправкой заявки',
            style: AppTextStyles.body2,
          ),
          const SizedBox(height: AppDimensions.padding24),
          _buildConfirmationCard(),
          const SizedBox(height: AppDimensions.spacingXLarge),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 1;
                    });
                  },
                  child: const Text('Назад'),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showSuccessDialog();
                  },
                  child: const Text('Отправить заявку'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.padding24),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'ФИО ребенка',
            _childNameController.text.isNotEmpty
                ? _childNameController.text
                : 'Иванов Иван Иванович',
          ),
          const Divider(),
          _buildInfoRow(
            'Дата рождения',
            _childBirthController.text.isNotEmpty
                ? _childBirthController.text
                : '01.01.2019',
          ),
          const Divider(),
          _buildInfoRow('Детский сад', 'Балдаурен'),
          const Divider(),
          _buildInfoRow('Группа', 'Младшая'),
          const Divider(),
          _buildInfoRow('Документы', '3 файла загружено'),
          const Divider(),
          _buildInfoRow(
            'Дата подачи',
            '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body2),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: AppDimensions.iconSizeHuge,
              ),
              const SizedBox(height: AppDimensions.spacingMedium),
              Text(
                'Заявка успешно отправлена!',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingSmall),
              Text(
                'Ваш номер в очереди: 42\nСтатус заявки можно отслеживать в личном кабинете',
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.padding24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to dashboard
                    context.go('/dashboard');
                  },
                  child: const Text('Вернуться на главную'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
