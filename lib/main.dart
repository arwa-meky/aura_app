import 'package:aura_project/core/helpers/local_storage.dart';
import 'package:aura_project/core/networking/dio_factory.dart';
import 'package:aura_project/core/router/app_router.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  DioFactory.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const AuraApp());
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
