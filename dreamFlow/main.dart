import 'package:flutter/material.dart';
import 'iframe_util.dart';
import 'iframe_util.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/providers/cart_provider.dart';
import 'package:dreamflow/providers/auth_provider.dart';
import 'package:dreamflow/screens/home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  dfInitMessageListener();
  dfInitMessageListener();
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar para telas grandes
  if (kIsWeb) {
    // Ajustar tamanho de janela mínimo para web
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Sweet Cake',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        builder: (context, child) {
          // Aplicando escala para telas maiores
          return MediaQuery(
            // Ajustar textos para serem mais legíveis em tamanhos maiores de tela
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: kIsWeb ? 1.1 : 1.0,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}