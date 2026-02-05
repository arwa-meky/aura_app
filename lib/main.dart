import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/dio_factory.dart';
import 'package:aura_project/core/router/app_router.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/services/notification_hleper.dart';
import 'package:aura_project/core/services/notification_service.dart';
import 'package:aura_project/core/style/themes.dart';
import 'package:aura_project/fratuers/bluetooth/logic/bluetooth_cubit.dart';
import 'package:aura_project/fratuers/bluetooth/model/health_reading_model.dart';
import 'package:aura_project/fratuers/calendar/model/event_model.dart';
import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:aura_project/fratuers/trends/model/history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await LocalStorage.init();
  await Hive.initFlutter();
  Hive.registerAdapter(HealthReadingModelAdapter());
  Hive.registerAdapter(EventModelAdapter());
  await Hive.openBox<EventModel>('events_box');
  Hive.registerAdapter(HistoryItemAdapter());
  await Hive.openBox<HistoryItem>('health_history');
  DioFactory.init();
  await NotificationService().init();
  await NotificationHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BluetoothCubit()),
        BlocProvider(create: (context) => ProfileCubit()..initProfile()),
      ],
      child: const AuraApp(),
    ),
  );
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura Health Monitor',
      theme: AppThemes.theme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter().onGenerateRoute,
      initialRoute: Routes.splash,
    );
  }
}
