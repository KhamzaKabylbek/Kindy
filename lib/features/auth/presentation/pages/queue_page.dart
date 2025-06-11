import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/constants/app_text_styles.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';

enum ApplicationStatus {
  acceptedToCompetition('Принят на конкурс', AppColors.primary),
  placeReserved('Место забронировано', Colors.green),
  cancelled('Аннулировано', Colors.red),
  successful('Успешно', Colors.blue);

  const ApplicationStatus(this.displayName, this.color);
  final String displayName;
  final Color color;
}

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  int _currentStep = 0;

  // Контроллеры для полей
  final _childNameController = TextEditingController();
  final _childIinController = TextEditingController();
  final _childBirthYearController = TextEditingController();

  // Выбранные значения
  String? _selectedCity;
  String? _selectedKindergarten;
  String? _selectedGroup;

  // Данные для выпадающих списков
  final Map<String, List<String>> _kindergartensByCity = {
    'Алматы': ['Балдаурен №1', 'Солнышко №2', 'Радость №3', 'Ақбота №4'],
    'Астана': ['Жұлдыз №1', 'Бөбек №2', 'Ақылды бала №3'],
    'Шымкент': ['Гүлдер №1', 'Балапан №2', 'Ертегі №3'],
  };

  final List<String> _cities = ['Алматы', 'Астана', 'Шымкент'];
  final List<String> _groups = [
    'Младшая группа (2-3 года)',
    'Средняя группа (3-4 года)',
    'Старшая группа (4-5 года)',
    'Подготовительная группа (5-6 лет)',
  ];

  @override
  void initState() {
    super.initState();
    // Проверяем авторизацию пользователя
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      if (authController.state != AuthState.authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Необходимо войти в систему'),
            backgroundColor: AppColors.warning,
          ),
        );
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _childIinController.dispose();
    _childBirthYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Постановка в очередь'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
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
          _buildStepIndicator(0, 'Общая информация', _currentStep >= 0),
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
              fontSize: 11,
              color: isActive ? AppColors.primary : Colors.grey.shade600,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
        return _buildGeneralInfoStep();
      case 1:
        return _buildDocumentsStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return Container();
    }
  }

  Widget _buildGeneralInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.padding24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Общая информация', style: AppTextStyles.h2),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            'Заполните информацию о ребенке для постановки в очередь',
            style: AppTextStyles.body2,
          ),
          const SizedBox(height: AppDimensions.padding24),

          // ФИО ребенка
          TextField(
            controller: _childNameController,
            decoration: const InputDecoration(
              labelText: 'ФИО ребенка',
              hintText: 'Иванов Иван Иванович',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),

          // ИИН
          TextField(
            controller: _childIinController,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: const InputDecoration(
              labelText: 'ИИН ребенка',
              hintText: '123456789012',
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(),
              counterText: '',
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),

          // Год рождения
          TextField(
            controller: _childBirthYearController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: 'Год рождения ребенка',
              hintText: '2020',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
              counterText: '',
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),

          // Населенный пункт
          _buildDropdown('Населенный пункт', _cities, _selectedCity, (
            String? value,
          ) {
            setState(() {
              _selectedCity = value;
              _selectedKindergarten = null; // Сбрасываем выбор детского сада
            });
          }),
          const SizedBox(height: AppDimensions.spacingMedium),

          // Дошкольная организация
          _buildDropdown(
            'Дошкольная организация',
            _selectedCity != null
                ? _kindergartensByCity[_selectedCity!] ?? []
                : [],
            _selectedKindergarten,
            (String? value) {
              setState(() {
                _selectedKindergarten = value;
              });
            },
            enabled: _selectedCity != null,
          ),
          const SizedBox(height: AppDimensions.spacingMedium),

          // Группа
          _buildDropdown('Год (Группа)', _groups, _selectedGroup, (
            String? value,
          ) {
            setState(() {
              _selectedGroup = value;
            });
          }),

          const SizedBox(height: AppDimensions.padding40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _canProceedToNextStep()
                      ? () {
                        setState(() {
                          _currentStep = 1;
                        });
                      }
                      : null,
              child: Text('Продолжить', style: AppTextStyles.buttonText),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceedToNextStep() {
    return _childNameController.text.isNotEmpty &&
        _childIinController.text.length == 12 &&
        _childBirthYearController.text.length == 4 &&
        _selectedCity != null &&
        _selectedKindergarten != null &&
        _selectedGroup != null;
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged, {
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: enabled ? Colors.grey.shade400 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding12,
            vertical: AppDimensions.padding16,
          ),
        ),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: enabled ? onChanged : null,
        isExpanded: true,
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

          _buildDocumentUploadCard('Свидетельство о рождении ребенка'),
          const SizedBox(height: AppDimensions.spacingMedium),
          _buildDocumentUploadCard('Удостоверение личности родителя/опекуна'),
          const SizedBox(height: AppDimensions.spacingMedium),
          _buildDocumentUploadCard('Справка о составе семьи'),

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
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                // Text(
                //   'Перетащите файл или',
                //   style: TextStyle(color: Colors.grey.shade600),
                // ),
                TextButton(
                  onPressed: () {
                    // TODO: Реализовать выбор файла
                  },
                  child: const Text('выберите на устройстве'),
                ),
              ],
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
                  child: const Text('Отправить'),
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
          _buildInfoRow('ФИО ребенка', _childNameController.text),
          const Divider(),
          _buildInfoRow('ИИН', _childIinController.text),
          const Divider(),
          _buildInfoRow('Год рождения', _childBirthYearController.text),
          const Divider(),
          _buildInfoRow('Населенный пункт', _selectedCity ?? ''),
          const Divider(),
          _buildInfoRow('Дошкольная организация', _selectedKindergarten ?? ''),
          const Divider(),
          _buildInfoRow('Группа', _selectedGroup ?? ''),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: AppTextStyles.body2)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                'Ваш номер в очереди: 42',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingSmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.padding12,
                  vertical: AppDimensions.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: ApplicationStatus.acceptedToCompetition.color
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  border: Border.all(
                    color: ApplicationStatus.acceptedToCompetition.color,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Статус: ${ApplicationStatus.acceptedToCompetition.displayName}',
                  style: TextStyle(
                    color: ApplicationStatus.acceptedToCompetition.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSmall),
              Text(
                'Статус заявки можно отслеживать в личном кабинете',
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.padding24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
