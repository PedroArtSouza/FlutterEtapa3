import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/comentario_service.dart';

class ComentariosPage extends StatefulWidget {
  final String publicacaoId;
  final String autorNome;
  final String textoPublicacao;

  const ComentariosPage({
    super.key,
    required this.publicacaoId,
    required this.autorNome,
    required this.textoPublicacao,
  });

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final TextEditingController _texto = TextEditingController();
  final ComentarioService _service = ComentarioService();
  bool _enviando = false;

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  void _avisar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _enviar() async {
    if (_enviando || _texto.text.trim().isEmpty) return;
    setState(() => _enviando = true);
    try {
      await _service.comentar(widget.publicacaoId, _texto.text);
      if (!mounted) return;
      _texto.clear();
      FocusScope.of(context).unfocus();
    } catch (erro) {
      if (mounted) _avisar('Não foi possível comentar: $erro');
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _excluir(String comentarioId) async {
    try {
      await _service.excluir(widget.publicacaoId, comentarioId);
    } catch (erro) {
      if (mounted) _avisar('Não foi possível excluir: $erro');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Comentários')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(widget.autorNome),
                  subtitle: Text(widget.textoPublicacao),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Discussão', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _service.acompanhar(widget.publicacaoId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar comentários: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final comentarios = snapshot.data!.docs;
                    if (comentarios.isEmpty) {
                      return const Center(child: Text('Nenhum comentário ainda. Seja o primeiro!'));
                    }
                    return ListView.builder(
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        final doc = comentarios[index];
                        final comentario = doc.data();
                        final meuComentario = comentario['autorId'] == uid;
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                            title: Text(comentario['autorNome'] ?? 'Usuário'),
                            subtitle: Text(comentario['texto'] ?? ''),
                            trailing: meuComentario
                                ? IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Excluir meu comentário',
                                    onPressed: () => _excluir(doc.id),
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _texto,
                          maxLength: 500,
                          minLines: 1,
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Escreva um comentário...',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          onSubmitted: (_) => _enviar(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Enviar comentário',
                        onPressed: _enviando ? null : _enviar,
                        icon: _enviando
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
