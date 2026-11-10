import 'package:flutter/foundation.dart';
import '../models/material_evento.dart';
import '../repositories/material_repository.dart';
import '../utils/validadores.dart';

// A ViewModel coordena regras, persistência e atualização da interface.
class MaterialViewModel extends ChangeNotifier {
  final MaterialRepository repository;
  List<MaterialEvento> _materiais = [];
  List<MaterialEvento> get materiais => List.unmodifiable(_materiais);
  MaterialViewModel(this.repository);

  Future<void> carregar() async {
    _materiais = await repository.listar();
    notifyListeners();
  }

  Future<void> salvar({int? id, required String nome,
    required String categoria, required String quantidade,
    required String minimo}) async {
    // A regra também é conferida aqui, caso a operação seja chamada fora da tela.
    for (final campo in [nome, categoria]) {
      final erro = Validadores.textoObrigatorio(campo);
      if (erro != null) throw FormatException(erro);
    }
    for (final campo in [quantidade, minimo]) {
      final erro = Validadores.quantidade(campo);
      if (erro != null) throw FormatException(erro);
    }
    final unidades = int.tryParse(quantidade.trim());
    final limite = int.tryParse(minimo.trim());
    // Proteção para manter o app utilizável enquanto as validações são completadas.
    if (unidades == null || limite == null) {
      throw const FormatException('As quantidades devem ser números inteiros.');
    }
    if (await repository.existeNome(nome, ignorarId: id)) {
      throw const FormatException('Já existe um material com esse nome.');
    }
    final material = MaterialEvento(id: id, nome: nome.trim(),
      categoria: categoria.trim(), quantidade: unidades, minimo: limite);
    if (id == null) {
      await repository.inserir(material);
    } else {
      await repository.atualizar(material);
    }
    await carregar();
  }

  Future<void> excluir(int id) async {
    await repository.excluir(id);
    await carregar();
  }
}
