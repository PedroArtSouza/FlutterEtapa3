import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'pages/impressao_page.dart';
import 'providers/impressao_provider.dart';
import 'repositories/impressao_repository.dart';
import 'services/database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => ChangeNotifierProvider(
      // Inicia a consulta quando o provider é criado.
      create: (_) => ImpressaoProvider(
        ImpressaoRepository(DatabaseService()),
      )..iniciar(),
      child: const ImpressaoApp(),
    ),
  ));
}

class ImpressaoApp extends StatelessWidget {
  const ImpressaoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: DevicePreview.locale(context),
    builder: DevicePreview.appBuilder,
    title: 'Fila de impressão',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const ImpressaoPage(),
  );
}
