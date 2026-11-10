import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'pages/materiais_page.dart';
import 'repositories/material_repository.dart';
import 'services/database_service.dart';
import 'viewmodels/material_viewmodel.dart';

final viewModel = MaterialViewModel(MaterialRepository(DatabaseService()));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(builder: (context) => const CentralApp()));
}

class CentralApp extends StatelessWidget {
  const CentralApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Central de materiais',
    locale: DevicePreview.locale(context),
    builder: DevicePreview.appBuilder,
    theme: ThemeData(useMaterial3: true,
      colorSchemeSeed: const Color(0xFF215C47)),
    home: MateriaisPage(viewModel: viewModel),
  );
}
