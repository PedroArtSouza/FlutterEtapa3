import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComentarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _comentarios(String publicacaoId) =>
      _db.collection('publicacoes').doc(publicacaoId).collection('comentarios');

  // O listener mantém todas as contas atualizadas automaticamente.
  Stream<QuerySnapshot<Map<String, dynamic>>> acompanhar(String publicacaoId) {
    return _comentarios(publicacaoId).orderBy('data').snapshots();
  }

  Future<void> comentar(String publicacaoId, String texto) async {
    final usuario = _auth.currentUser;
    if (usuario == null) throw StateError('Entre na sua conta para comentar.');
    final mensagem = texto.trim();
    if (mensagem.isEmpty || mensagem.length > 500) {
      throw ArgumentError('O comentário deve conter de 1 a 500 caracteres.');
    }
    final perfil = await _db.collection('usuarios').doc(usuario.uid).get();
    final nome = (perfil.data()?['nome'] as String?)?.trim();
    await _comentarios(publicacaoId).add({
      'texto': mensagem,
      'autorNome': (nome == null || nome.isEmpty) ? (usuario.email ?? 'Usuário') : nome,
      'autorId': usuario.uid,
      'publicacaoId': publicacaoId,
      'data': FieldValue.serverTimestamp(),
    });
  }

  Future<void> excluir(String publicacaoId, String comentarioId) async {
    final usuario = _auth.currentUser;
    if (usuario == null) throw StateError('Faça login para excluir comentários.');
    // A regra do Firestore também bloqueia exclusões de outros usuários.
    await _comentarios(publicacaoId).doc(comentarioId).delete();
  }
}
