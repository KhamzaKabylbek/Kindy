import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kindy/core/constants/app_colors.dart';
import 'package:kindy/core/constants/app_dimensions.dart';
import 'package:kindy/core/constants/app_text_styles.dart';
import 'package:kindy/core/utils/screen_util.dart';
import 'package:kindy/shared/widgets/adaptive_widgets.dart';
import 'package:provider/provider.dart';
import 'package:kindy/features/auth/domain/controllers/auth_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int _activeChildIndex = 0;

  final List<Map<String, dynamic>> _children = [
    {'name': 'Асанали', 'age': 5, 'group': 'Старшая группа'},
    {'name': 'Айнура', 'age': 4, 'group': 'Средняя группа'},
    {'name': 'Ерасыл', 'age': 3, 'group': 'Младшая группа'},
  ];

  @override
  void initState() {
    super.initState();
    print('DashboardPage: initState вызван');

    // Отложим проверку пользователя до построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserRole();
    });
  }

  void _checkUserRole() {
    // Проверяем текущего пользователя и его роль
    final authController = Provider.of<AuthController>(context, listen: false);
    print(
      'DashboardPage: Роль пользователя: ${authController.userDetails?.role}',
    );
    print(
      'DashboardPage: Данные пользователя: ${authController.userDetails?.toJson()}',
    );

    // Если роль - учитель, но мы попали на dashboard родителя
    if (authController.userDetails?.role == 'TEACHER') {
      print('DashboardPage: ВНИМАНИЕ! Учитель оказался на странице родителя!');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;
    final maxWidth = isDesktop ? 1100.0 : (isTablet ? 800.0 : double.infinity);
    final horizontalPadding = isDesktop ? 48.0 : (isTablet ? 32.0 : 0.0);

    Widget content = _buildBody();
    if (!isDesktop) {
      content = SafeArea(child: SingleChildScrollView(child: content));
    } else {
      content = Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SingleChildScrollView(child: content),
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    // Для больших экранов (планшеты и десктопы) показываем двухпанельный интерфейс
    if (ScreenUtil.isLargeScreen() || ScreenUtil.isMediumScreen()) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Боковая навигация
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppColors.backgroundPrimary,
            selectedIconTheme: IconThemeData(color: AppColors.primary),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            selectedLabelTextStyle: TextStyle(color: AppColors.primary),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Главная'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.child_care_outlined),
                selectedIcon: Icon(Icons.child_care),
                label: Text('Мои дети'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.apps_outlined),
                selectedIcon: Icon(Icons.apps),
                label: Text('Сервисы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Профиль'),
              ),
            ],
          ),
          // Вертикальный разделитель
          const VerticalDivider(width: 1, thickness: 1),
          // Основной контент
          Expanded(
            child: Builder(
              builder: (context) {
                switch (_selectedIndex) {
                  case 0:
                    return _buildHomeTab();
                  case 1:
                    return _buildChildrenTab();
                  case 2:
                    return _buildServicesTab();
                  case 3:
                    return _buildProfileTab();
                  default:
                    return _buildHomeTab();
                }
              },
            ),
          ),
        ],
      );
    }

    // Для мобильных устройств используем обычный стек с нижней навигацией
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildChildrenTab();
      case 2:
        return _buildServicesTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildBottomNavigationBar() {
    // На больших экранах используем боковую навигацию вместо нижней
    if (ScreenUtil.isLargeScreen()) {
      return const SizedBox.shrink(); // Не показываем нижнюю навигацию на больших экранах
    }

    // На средних экранах увеличиваем размеры иконок и подписей
    final double iconSize = ScreenUtil.adaptiveValue(
      mobile: 24.0,
      tablet: 30.0,
      desktop: 30.0,
    );

    final double labelFontSize = ScreenUtil.adaptiveValue(
      mobile: 12.0,
      tablet: 14.0,
      desktop: 14.0,
    );

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundPrimary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      iconSize: iconSize,
      selectedFontSize: labelFontSize,
      unselectedFontSize: labelFontSize - 2,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.child_care_outlined),
          activeIcon: Icon(Icons.child_care),
          label: 'Мои дети',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apps_outlined),
          activeIcon: Icon(Icons.apps),
          label: 'Сервисы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppDimensions.spacingMedium),
            _buildNewsSection(),
            const SizedBox(height: AppDimensions.spacingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.padding16,
        horizontal: AppDimensions.padding16,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kindy.kz',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Comic Sans MS',
                  ),
                ),
                Text(
                  'Детский сад «Балдаурен»',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.primary,
            onPressed: () {
              // Показываем диалог с уведомлениями
              _showNotificationsDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Новый метод для отображения диалога с уведомлениями
  void _showNotificationsDialog(BuildContext context) {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: AppColors.primary),
                      SizedBox(width: 10),
                      AdaptiveText('Уведомления', style: AppTextStyles.h3),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1),
                // Уведомление о родительском собрании
                InkWell(
                  onTap: () {
                    // Действие при нажатии на уведомление
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AdaptiveText(
                                'Родительское собрание',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AdaptiveText(
                                'Завтра, 18:00, актовый зал',
                                style: AppTextStyles.body2,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
                // Дополнительные уведомления можно добавить здесь
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: TextButton(
                    onPressed: () {
                      // Переход ко всем уведомлениям
                      Navigator.pop(context);
                    },
                    child: Text('Показать все уведомления'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  String _getAgeText(int age) {
    // Russian grammar for years
    if (age % 10 == 1 && age % 100 != 11) {
      return 'год';
    } else if ((age % 10 == 2 || age % 10 == 3 || age % 10 == 4) &&
        (age % 100 < 10 || age % 100 >= 20)) {
      return 'года';
    } else {
      return 'лет';
    }
  }

  Widget _buildNewsSection() {
    final double horizontalPadding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacingMedium = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );

    // Пример данных новостей
    final List<Map<String, dynamic>> newsItems = [
      {
        'id': '1',
        'authorName': 'Ясли-сад "Лаяна"',
        'avatarUrl': '', // Пустая строка, будем использовать первую букву
        'timestamp': 'сегодня в 10:25',
        'content':
            'Рады сообщить: в нашем садике открывается шахматный кружок для детей старших групп! 🎉\nШахматы помогают развивать внимание, мышление и усидчивость — и всё это в игровой форме.',
        'imageUrl': 'assets/images/Image3.png',
        'likes': 26,
        'comments': 11,
        'hasLiked': false,
      },
      {
        'id': '2',
        'authorName': 'Детский сад "Балдаурен"',
        'avatarUrl': '',
        'timestamp': 'вчера в 15:40',
        'content':
            'Сегодня в нашем саду прошел день открытых дверей! Благодарим всех родителей, которые смогли присутствовать и познакомиться с нашими воспитателями и программой обучения.',
        'imageUrl': 'assets/images/news_open_day.jpg',
        'likes': 42,
        'comments': 8,
        'hasLiked': true,
      },
      {
        'id': '3',
        'authorName': 'Детский сад "Балдаурен"',
        'avatarUrl': '',
        'timestamp': '3 дня назад',
        'content':
            'Приглашаем всех детей и родителей на утренник "Осенний бал", который состоится 20 сентября в 10:00. Будет много интересных конкурсов, песен и танцев!',
        'imageUrl': 'assets/images/news_autumn.jpg',
        'likes': 38,
        'comments': 15,
        'hasLiked': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [AdaptiveText('Новости', style: AppTextStyles.h3)],
          ),
        ),
        SizedBox(height: spacingMedium),

        // Список новостей в стиле Instagram
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsItems.length,
          itemBuilder: (context, index) {
            final newsItem = newsItems[index];
            return _buildNewsItem(
              authorName: newsItem['authorName'],
              avatarUrl: newsItem['avatarUrl'],
              timestamp: newsItem['timestamp'],
              content: newsItem['content'],
              imageUrl: newsItem['imageUrl'],
              likes: newsItem['likes'],
              comments: newsItem['comments'],
              hasLiked: newsItem['hasLiked'],
              onLikePressed: () {
                // Обработка лайка
                setState(() {
                  final item = newsItems.firstWhere(
                    (item) => item['id'] == newsItem['id'],
                  );
                  item['hasLiked'] = !item['hasLiked'];
                  item['likes'] =
                      item['hasLiked'] ? item['likes'] + 1 : item['likes'] - 1;
                });
              },
              onCommentPressed: () {
                // Открыть комментарии
                _showCommentsDialog(context, newsItem);
              },
            );
          },
        ),
      ],
    );
  }

  // Виджет отдельного элемента новости
  Widget _buildNewsItem({
    required String authorName,
    required String avatarUrl,
    required String timestamp,
    required String content,
    required String imageUrl,
    required int likes,
    required int comments,
    required bool hasLiked,
    required VoidCallback onLikePressed,
    required VoidCallback onCommentPressed,
  }) {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double spacingSmall = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingSmall,
    );

    return Card(
      margin: EdgeInsets.symmetric(horizontal: padding, vertical: spacingSmall),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка с автором и временем
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    authorName.substring(0, 1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        timestamp,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Показать дополнительные опции
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),

          // Содержимое новости
          if (content.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Text(
                content,
                style: TextStyle(fontSize: 16),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Кнопка "Посмотреть больше" для длинного текста
          if (content.length > 100)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: TextButton(
                onPressed: () {
                  // Показать полный текст
                },
                child: Text('Показать больше...'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

          // Изображение
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: EdgeInsets.all(padding),
                constraints: BoxConstraints(
                  maxHeight: 200, // Ограничиваем высоту изображения
                ),
                width: double.infinity,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey.shade400,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Лайки и комментарии
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                Text(
                  '$likes лайков',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: spacing),
                Text(
                  '$comments комментариев',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onLikePressed,
                  icon: Icon(
                    hasLiked ? Icons.favorite : Icons.favorite_border,
                    color: hasLiked ? Colors.red : Colors.grey,
                  ),
                  label: Text(
                    'Нравится',
                    style: TextStyle(
                      color: hasLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                  style: TextButton.styleFrom(minimumSize: Size(0, 40)),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onCommentPressed,
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey,
                  ),
                  label: const Text(
                    'Комментировать',
                    style: TextStyle(color: Colors.grey),
                  ),
                  style: TextButton.styleFrom(minimumSize: Size(0, 40)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Диалог для показа комментариев
  void _showCommentsDialog(
    BuildContext context,
    Map<String, dynamic> newsItem,
  ) {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    // Пример комментариев
    final List<Map<String, dynamic>> commentsList = [
      {
        'authorName': 'Анна Смирнова',
        'text': 'Отличная новость! Мой сын обязательно запишется.',
        'timestamp': '1 час назад',
      },
      {
        'authorName': 'Марат Асанов',
        'text': 'А для каких групп будет доступен кружок?',
        'timestamp': '45 минут назад',
      },
      {
        'authorName': 'Администратор',
        'text': 'Для старшей и подготовительной групп. Набор ограничен.',
        'timestamp': '30 минут назад',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Комментарии (${newsItem['comments']})',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: commentsList.length,
                    itemBuilder: (context, index) {
                      final comment = commentsList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            comment['authorName'].substring(0, 1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              comment['authorName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              comment['timestamp'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(comment['text']),
                        dense: true,
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Напишите комментарий...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: AppColors.primary),
                        onPressed: () {
                          // Отправить комментарий
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildServicesTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double spacingLarge = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingLarge,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );

    // Список сервисов (удалены пункты "Чат" и "Фотогалерея")
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Встать в очередь',
        'icon': Icons.queue,
        'description':
            'Встать в электронную очередь для приёма или выдачи ребёнка',
      },
      {
        'title': 'Меню питания',
        'icon': Icons.restaurant_menu,
        'description': 'Просмотр ежедневного меню и рациона питания',
      },
      {
        'title': 'Расписание',
        'icon': Icons.calendar_today,
        'description': 'Расписание занятий и мероприятий',
      },
      {
        'title': 'Загрузить фото',
        'icon': Icons.photo_camera,
        'description': 'Загрузка фотографий с мероприятий',
      },
      {
        'title': 'Оплата услуг',
        'icon': Icons.payment,
        'description': 'Оплата детского сада и дополнительных занятий',
      },
      {
        'title': 'Медицинская карта',
        'icon': Icons.healing,
        'description': 'Доступ к медицинской информации и прививкам',
      },
      {
        'title': 'Онлайн-камеры',
        'icon': Icons.videocam,
        'description': 'Просмотр видеотрансляции из группы',
      },
      {
        'title': 'Электронные справки',
        'icon': Icons.description,
        'description': 'Заказ и получение справок онлайн',
      },
    ];

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Сервисы', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Электронные сервисы для родителей и детей',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              separatorBuilder: (context, index) => SizedBox(height: spacing),
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceCard(
                  title: service['title'],
                  icon: service['icon'],
                  description: service['description'],
                );
              },
            ),
          ],
        ),
      ),

      // Планшетный и десктопный вид - карточки в сетке
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Сервисы', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Электронные сервисы для родителей и детей',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil.isLargeScreen() ? 3 : 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceCard(
                  title: service['title'],
                  icon: service['icon'],
                  description: service['description'],
                  isGrid: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required IconData icon,
    required String description,
    bool isGrid = false,
  }) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double iconSize = AppDimensions.getAdaptiveIconSize(30);

    void navigateToService() {
      if (title == 'Встать в очередь') {
        Navigator.of(context).pushNamed('/queue-status');
      } else {
        // Для других сервисов можно добавить свою логику навигации
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Сервис "$title" будет доступен в ближайшее время'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      child: InkWell(
        onTap: navigateToService,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child:
              isGrid
                  // Вид для сетки (планшет/десктоп)
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(padding * 0.7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(height: padding * 0.5),
                      AdaptiveText(
                        title,
                        style: AppTextStyles.h3,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: padding * 0.3),
                      AdaptiveText(
                        description,
                        style: AppTextStyles.body2.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                  // Вид для списка (мобильный)
                  : Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(padding * 0.7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdaptiveText(title, style: AppTextStyles.h3),
                            SizedBox(height: padding * 0.3),
                            AdaptiveText(
                              description,
                              style: AppTextStyles.body2.copyWith(
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildChildrenTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double spacingLarge = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingLarge,
    );

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Мои дети', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Выберите ребенка для управления его профилем, просмотра дневника и других действий.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _children.length,
              separatorBuilder: (context, index) => SizedBox(height: spacing),
              itemBuilder: (context, index) {
                final child = _children[index];
                return _buildChildDetailCard(
                  name: child['name'] as String,
                  age: child['age'] as int,
                  group: child['group'] as String,
                  isActive: index == _activeChildIndex,
                  onTap: () {
                    setState(() {
                      _activeChildIndex = index;
                    });

                    Navigator.of(
                      context,
                    ).pushNamed('/child-profile', arguments: _children[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),

      // Планшетный и десктопный вид - карточки в 2-3 колонки
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Мои дети', style: AppTextStyles.h2),
            SizedBox(height: spacing),
            const AdaptiveText(
              'Выберите ребенка для управления его профилем, просмотра дневника и других действий.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: spacingLarge),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtil.isLargeScreen() ? 3 : 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: _children.length,
              itemBuilder: (context, index) {
                final child = _children[index];
                return _buildChildGridCard(
                  name: child['name'] as String,
                  age: child['age'] as int,
                  group: child['group'] as String,
                  isActive: index == _activeChildIndex,
                  onTap: () {
                    setState(() {
                      _activeChildIndex = index;
                    });

                    Navigator.of(
                      context,
                    ).pushNamed('/child-profile', arguments: _children[index]);
                  },
                );
              },
            ),
            // Кнопка добавления нового ребенка для больших экранов
            SizedBox(height: spacingLarge),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to add child form
                },
                icon: const Icon(Icons.add),
                label: const Text('Добавить ребенка'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding * 1.5,
                    vertical: padding * 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildDetailCard({
    required String name,
    required int age,
    required String group,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding12,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingSmall,
    );
    final double avatarRadius = ScreenUtil.adaptiveValue(
      mobile: 25.0,
      tablet: 35.0,
      desktop: 40.0,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side:
            isActive
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
      ),
      elevation: isActive ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  name.substring(0, 1),
                  style: TextStyle(
                    fontSize: avatarRadius * 0.7,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primary : Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AdaptiveText(
                      name,
                      style: AppTextStyles.body1.copyWith(
                        color:
                            isActive
                                ? AppColors.primary
                                : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    AdaptiveText(
                      '$age ${_getAgeText(age)}',
                      style: AppTextStyles.body3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AdaptiveText(
                      group,
                      style: AppTextStyles.body3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: AppDimensions.getAdaptiveIconSize(20),
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Новый метод для отображения карточки ребенка в сетке (для больших экранов)
  Widget _buildChildGridCard({
    required String name,
    required int age,
    required String group,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius16,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double avatarRadius = ScreenUtil.adaptiveValue(
      mobile: 40.0,
      tablet: 45.0,
      desktop: 50.0,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side:
            isActive
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
      ),
      elevation: isActive ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Expanded(
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    name.substring(0, 1),
                    style: TextStyle(
                      fontSize: avatarRadius * 0.8,
                      fontWeight: FontWeight.bold,
                      color:
                          isActive ? AppColors.primary : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppDimensions.getAdaptivePadding(
                  AppDimensions.spacingSmall,
                ),
              ),
              Flexible(
                child: AdaptiveText(
                  name,
                  style: AppTextStyles.h3.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                    fontSize: ScreenUtil.adaptiveValue(
                      mobile: 18.0,
                      tablet: 20.0,
                      desktop: 22.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: AdaptiveText(
                  '$age ${_getAgeText(age)}',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: AdaptiveText(
                  group,
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: AppDimensions.getAdaptivePadding(
                  AppDimensions.spacingSmall,
                ),
              ),
              ElevatedButton(
                onPressed: onTap,
                child: const Text('Посмотреть'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppColors.primary : null,
                  foregroundColor: isActive ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );
    final double spacing = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingMedium,
    );
    final double spacingLarge = AppDimensions.getAdaptivePadding(
      AppDimensions.spacingLarge,
    );
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double avatarRadius = ScreenUtil.adaptiveValue(
      mobile: 50.0,
      tablet: 70.0,
      desktop: 90.0,
    );

    return AdaptiveLayout(
      // Мобильный вид - вертикальный список
      mobile: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            SizedBox(height: spacingLarge),
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                'ХК',
                style: TextStyle(
                  fontSize: avatarRadius * 0.6,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: spacing),
            AdaptiveText(
              'Хамза Кабылбек',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            AdaptiveText(
              'kabylbek@gmail.com',
              style: AppTextStyles.body1.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingLarge),
            _buildProfileMenuCard(),
            SizedBox(height: spacing),
            _buildSettingsCard(),
            SizedBox(height: spacing),
            _buildLogoutButton(),
            SizedBox(height: spacingLarge),
          ],
        ),
      ),

      // Планшетный и десктопный вид - двухколоночный макет
      tablet: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Левая колонка - информация о пользователе
            Expanded(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      SizedBox(height: spacing),
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          'ХК',
                          style: TextStyle(
                            fontSize: avatarRadius * 0.6,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      AdaptiveText(
                        'Хамза Кабылбек',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                      AdaptiveText(
                        'kabylbek@gmail.com',
                        style: AppTextStyles.body1.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      const Divider(),
                      _buildStatItem('Детей в системе', '3'),
                      _buildStatItem('Дата регистрации', '01.09.2023'),
                      _buildStatItem('Статус', 'Активен'),
                      SizedBox(height: spacing),
                      ElevatedButton(
                        onPressed: () {
                          // Edit profile
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Редактировать профиль'),
                      ),
                      SizedBox(height: spacing),
                      OutlinedButton(
                        onPressed: () async {
                          // Получаем контроллер авторизации
                          final authController = Provider.of<AuthController>(
                            context,
                            listen: false,
                          );

                          // Выполняем выход
                          await authController.logout();

                          // Переходим на страницу входа
                          if (!mounted) return;
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/login', (route) => false);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Выйти'),
                      ),
                      SizedBox(height: spacing),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing),
            // Правая колонка - настройки и меню
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildProfileMenuCard(),
                  SizedBox(height: spacing),
                  _buildSettingsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuCard() {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Личные данные',
        'icon': Icons.person_outline,
        'onTap': () => Navigator.of(context).pushNamed('/profile'),
      },
      {
        'title': 'Мои документы',
        'icon': Icons.folder_outlined,
        'onTap': () {
          // Будет добавлено позже
        },
      },
      {
        'title': 'История оплат',
        'icon': Icons.receipt_long_outlined,
        'onTap': () {
          // Будет добавлено позже
        },
      },
      {
        'title': 'Помощь',
        'icon': Icons.help_outline,
        'onTap': () {
          // Будет добавлено позже
        },
      },
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Личный кабинет', style: AppTextStyles.h3),
            ...menuItems.map(
              (item) => _buildMenuTile(
                title: item['title'],
                icon: item['icon'],
                onTap: item['onTap'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    final double borderRadius = AppDimensions.getAdaptiveRadius(
      AppDimensions.radius12,
    );
    final double padding = AppDimensions.getAdaptivePadding(
      AppDimensions.padding16,
    );

    final List<Map<String, dynamic>> settingsItems = [
      {
        'title': 'Уведомления',
        'icon': Icons.notifications_outlined,
        'onTap': () {
          // Будет добавлено позже
        },
      },
      {
        'title': 'Язык приложения',
        'icon': Icons.language_outlined,
        'onTap': () {
          // Будет добавлено позже
        },
      },
      {
        'title': 'Смена пароля',
        'icon': Icons.lock_outline,
        'onTap': () {
          // Будет добавлено позже
        },
      },
      {
        'title': 'Конфиденциальность',
        'icon': Icons.security_outlined,
        'onTap': () {
          // Будет добавлено позже
        },
      },
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText('Настройки', style: AppTextStyles.h3),
            ...settingsItems.map(
              (item) => _buildMenuTile(
                title: item['title'],
                icon: item['icon'],
                onTap: item['onTap'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final double iconSize = AppDimensions.getAdaptiveIconSize(24);

    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: iconSize),
      title: AdaptiveText(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AdaptiveText(
            label,
            style: AppTextStyles.body2.copyWith(color: Colors.grey),
          ),
          AdaptiveText(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () async {
        // Получаем контроллер авторизации
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );

        // Выполняем выход
        await authController.logout();

        // Переходим на страницу входа
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black87,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text('Выйти из аккаунта'),
    );
  }
}
