import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/constants/app_text_styles.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';

enum ApplicationStatus {
  acceptedToCompetition(
    'Принят на конкурс',
    AppColors.primary,
    Icons.assignment_turned_in,
  ),
  placeReserved('Место забронировано', Colors.green, Icons.bookmark),
  cancelled('Аннулировано', Colors.red, Icons.cancel),
  successful('Успешно', Colors.blue, Icons.check_circle);

  const ApplicationStatus(this.displayName, this.color, this.icon);
  final String displayName;
  final Color color;
  final IconData icon;
}

class QueueApplication {
  final String id;
  final String childName;
  final String childIin;
  final String birthYear;
  final String city;
  final String kindergarten;
  final String group;
  final ApplicationStatus status;
  final DateTime applicationDate;
  final int queueNumber;
  final String? note;

  const QueueApplication({
    required this.id,
    required this.childName,
    required this.childIin,
    required this.birthYear,
    required this.city,
    required this.kindergarten,
    required this.group,
    required this.status,
    required this.applicationDate,
    required this.queueNumber,
    this.note,
  });
}

class QueueStatusPage extends StatefulWidget {
  const QueueStatusPage({super.key});

  @override
  State<QueueStatusPage> createState() => _QueueStatusPageState();
}

class _QueueStatusPageState extends State<QueueStatusPage> {
  // Пример данных заявок
  final List<QueueApplication> _applications = [
    QueueApplication(
      id: '1',
      childName: 'Иванов Иван Иванович',
      childIin: '123456789012',
      birthYear: '2020',
      city: 'Алматы',
      kindergarten: 'Балдаурен №1',
      group: 'Младшая группа (2-3 года)',
      status: ApplicationStatus.acceptedToCompetition,
      applicationDate: DateTime(2024, 1, 15),
      queueNumber: 42,
      note: 'Заявка принята на рассмотрение',
    ),
    QueueApplication(
      id: '2',
      childName: 'Петрова Анна Сергеевна',
      childIin: '987654321098',
      birthYear: '2019',
      city: 'Астана',
      kindergarten: 'Жұлдыз №1',
      group: 'Средняя группа (3-4 года)',
      status: ApplicationStatus.placeReserved,
      applicationDate: DateTime(2023, 12, 10),
      queueNumber: 15,
      note: 'Место забронировано до 25.01.2024',
    ),
    QueueApplication(
      id: '3',
      childName: 'Сидоров Петр Александрович',
      childIin: '456789123456',
      birthYear: '2021',
      city: 'Шымкент',
      kindergarten: 'Гүлдер №1',
      group: 'Младшая группа (2-3 года)',
      status: ApplicationStatus.cancelled,
      applicationDate: DateTime(2024, 1, 5),
      queueNumber: 78,
      note: 'Документы не предоставлены в срок',
    ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус заявок'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/queue'),
            tooltip: 'Подать новую заявку',
          ),
        ],
      ),
      body:
          _applications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.padding16),
                itemCount: _applications.length,
                itemBuilder: (context, index) {
                  return _buildApplicationCard(_applications[index]);
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: AppDimensions.iconSizeHuge,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          Text(
            'Нет поданных заявок',
            style: AppTextStyles.h3.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            'Подайте заявку на постановку в очередь',
            style: AppTextStyles.body2.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: AppDimensions.padding24),
          ElevatedButton.icon(
            onPressed: () => context.go('/queue'),
            icon: const Icon(Icons.add),
            label: const Text('Подать заявку'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(QueueApplication application) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с именем ребенка и статусом
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(application.childName, style: AppTextStyles.h3),
                      const SizedBox(height: AppDimensions.spacingTiny),
                      Text(
                        'ИИН: ${application.childIin}',
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(application.status),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingMedium),

            // Информация о заявке
            Container(
              padding: const EdgeInsets.all(AppDimensions.padding12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Год рождения', application.birthYear),
                  _buildInfoRow('Населенный пункт', application.city),
                  _buildInfoRow('Детский сад', application.kindergarten),
                  _buildInfoRow('Группа', application.group),
                  _buildInfoRow(
                    'Номер в очереди',
                    application.queueNumber.toString(),
                  ),
                  _buildInfoRow(
                    'Дата подачи',
                    '${application.applicationDate.day}.${application.applicationDate.month}.${application.applicationDate.year}',
                  ),
                ],
              ),
            ),

            // Примечание, если есть
            if (application.note != null) ...[
              const SizedBox(height: AppDimensions.spacingMedium),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.padding12),
                decoration: BoxDecoration(
                  color: application.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  border: Border.all(
                    color: application.status.color.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: application.status.color,
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Expanded(
                      child: Text(
                        application.note!,
                        style: AppTextStyles.body2.copyWith(
                          color: application.status.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Кнопки действий
            const SizedBox(height: AppDimensions.spacingMedium),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showApplicationDetails(application),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Подробнее'),
                  ),
                ),
                if (application.status ==
                    ApplicationStatus.acceptedToCompetition) ...[
                  const SizedBox(width: AppDimensions.spacingSmall),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _uploadDocuments(application),
                      icon: const Icon(Icons.upload_file, size: 16),
                      label: const Text('Документы'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ApplicationStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.padding8,
        vertical: AppDimensions.spacingTiny,
      ),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        border: Border.all(color: status.color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: status.color),
          const SizedBox(width: AppDimensions.spacingTiny),
          Text(
            status.displayName,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicationDetails(QueueApplication application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius16),
        ),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(AppDimensions.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Row(
                      children: [
                        Expanded(
                          child: Text('Детали заявки', style: AppTextStyles.h3),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const Divider(),

                    // Содержимое
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailSection('Информация о ребенке', [
                              _buildDetailRow('ФИО', application.childName),
                              _buildDetailRow('ИИН', application.childIin),
                              _buildDetailRow(
                                'Год рождения',
                                application.birthYear,
                              ),
                            ]),

                            const SizedBox(height: AppDimensions.spacingMedium),

                            _buildDetailSection('Информация о детском саде', [
                              _buildDetailRow(
                                'Населенный пункт',
                                application.city,
                              ),
                              _buildDetailRow(
                                'Детский сад',
                                application.kindergarten,
                              ),
                              _buildDetailRow('Группа', application.group),
                            ]),

                            const SizedBox(height: AppDimensions.spacingMedium),

                            _buildDetailSection('Статус заявки', [
                              _buildDetailRow(
                                'Текущий статус',
                                application.status.displayName,
                              ),
                              _buildDetailRow(
                                'Номер в очереди',
                                application.queueNumber.toString(),
                              ),
                              _buildDetailRow(
                                'Дата подачи',
                                '${application.applicationDate.day}.${application.applicationDate.month}.${application.applicationDate.year}',
                              ),
                            ]),

                            if (application.note != null) ...[
                              const SizedBox(
                                height: AppDimensions.spacingMedium,
                              ),
                              _buildDetailSection('Примечание', [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(
                                    AppDimensions.padding12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: application.status.color.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radius8,
                                    ),
                                  ),
                                  child: Text(
                                    application.note!,
                                    style: AppTextStyles.body2,
                                  ),
                                ),
                              ]),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.padding12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingTiny),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _uploadDocuments(QueueApplication application) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Загрузка документов'),
            content: Text(
              'Для завершения процесса постановки в очередь необходимо загрузить документы в течение 3 рабочих дней.\n\nЗаявка: ${application.childName}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Реализовать загрузку документов
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Функция загрузки документов будет реализована',
                      ),
                    ),
                  );
                },
                child: const Text('Загрузить'),
              ),
            ],
          ),
    );
  }
}
