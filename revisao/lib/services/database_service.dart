import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// Infraestrutura pronta para a atividade. Não usa dart:io nem path_provider.
// No Chrome, o banco é persistido no armazenamento da origem (IndexedDB).
class DatabaseService {
  Database? _database;
  Future<Database>? _abertura;

  Future<Database> get database {
    if (_database != null) return Future.value(_database!);
    return _abertura ??= _abrir();
  }

  Future<Database> _abrir() async {
    try {
      final db = await databaseFactoryFfiWeb.openDatabase(
        'central_materiais_alunos_v1.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, versao) async {
            await db.execute(
              'CREATE TABLE materiais ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'nome TEXT NOT NULL, '
              'nome_normalizado TEXT NOT NULL UNIQUE, '
              'categoria TEXT NOT NULL, '
              'quantidade INTEGER NOT NULL, '
              'minimo INTEGER NOT NULL)',
            );
            final iniciais = <Map<String, Object?>>[
              {'nome': 'Microfone', 'nome_normalizado': 'microfone',
                'categoria': 'Áudio', 'quantidade': 4, 'minimo': 2},
              {'nome': 'Cabo HDMI', 'nome_normalizado': 'cabo hdmi',
                'categoria': 'Vídeo', 'quantidade': 2, 'minimo': 3},
              {'nome': 'Extensão', 'nome_normalizado': 'extensão',
                'categoria': 'Elétrica', 'quantidade': 0, 'minimo': 2},
              {'nome': 'Caixa de som', 'nome_normalizado': 'caixa de som',
                'categoria': 'Áudio', 'quantidade': 3, 'minimo': 1},
            ];
            for (final material in iniciais) {
              await db.insert('materiais', material);
            }
          },
        ),
      );
      _database = db;
      return db;
    } catch (_) {
      _abertura = null;
      rethrow;
    }
  }
}
