import 'package:adyshkin_pcs/requests/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/routes.dart';
import 'common/widgets/new_bottom_bar.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Обязательно для Firebase
  await Firebase.initializeApp(); // Инициализация Firebase
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Обработка фонового уведомления
  print('Background message received: ${message.notification?.title}');
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()), // Добавляем AuthService
        ChangeNotifierProvider(create: (_) => PageManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chill-guy PC Configurator',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Initializer(), // Начальная точка приложения
      ),
    );
  }
}

// Начальный виджет, определяющий, какой экран отображать
class Initializer extends StatefulWidget {
  const Initializer({Key? key}) : super(key: key);

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  bool _isInitializing = true;

  Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('User denied permission');
    }
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.initialize(); // Проверяем сохраненный токен
    setState(() {
      _isInitializing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final authService = Provider.of<AuthService>(context);
    if (!authService.isAuthenticated) {
      return const LoginScreen(); // Если пользователь не авторизован, показываем экран входа
    }

    return const MainParentBuilder(); // Если пользователь авторизован, показываем основное приложение
  }
}

// Основной родительский виджет для приложения
class MainParentBuilder extends StatefulWidget {
  const MainParentBuilder({super.key});

  @override
  State<MainParentBuilder> createState() => _MainParentBuilderState();
}

class _MainParentBuilderState extends State<MainParentBuilder> {
  @override
  Widget build(BuildContext context) {
    final PageRouter router = PageRouter();
    final currentPage = Provider.of<PageManager>(context).currentPage;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          router.pages[currentPage],
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: NewBottomBar(
              backgroundColor: theme.colorScheme.surface,
              height: 70,
              icons: const [
                Icons.home_outlined,
                Icons.search,
                Icons.favorite_border,
                Icons.person_2_outlined,
              ],
              onPageSelected: (pageIndex) {
                Provider.of<PageManager>(context, listen: false).setPage(pageIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
