import 'package:flutter/material.dart';
import '../models/material_evento.dart';
import '../utils/validadores.dart';
import '../viewmodels/material_viewmodel.dart';

// A interface está pronta. Complete os TODOs indicados em ATIVIDADE.md.
class MateriaisPage extends StatefulWidget {
  final MaterialViewModel viewModel;
  const MateriaisPage({super.key, required this.viewModel});
  @override
  State<MateriaisPage> createState() => _MateriaisPageState();
}

class _MateriaisPageState extends State<MateriaisPage> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _categoria = TextEditingController();
  final _quantidade = TextEditingController();
  final _minimo = TextEditingController();
  int? _idEmEdicao;
  bool _ocupado = true;
  String? _falhaInicial;
  MaterialViewModel get vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _carregarInicial();
  }

  Future<void> _carregarInicial() async {
    setState(() { _ocupado = true; _falhaInicial = null; });
    try {
      await vm.carregar();
    } catch (erro) {
      if (mounted) setState(() => _falhaInicial = erro.toString());
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _categoria.dispose();
    _quantidade.dispose();
    _minimo.dispose();
    vm.dispose();
    super.dispose();
  }

  void _limpar() {
    _idEmEdicao = null;
    _nome.clear(); _categoria.clear(); _quantidade.clear(); _minimo.clear();
    _formulario.currentState?.reset();
  }

  void _avisar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _executar(Future<void> Function() acao) async {
    if (_ocupado) return;
    setState(() => _ocupado = true);
    try {
      await acao();
    } on FormatException catch (erro) {
      if (mounted) _avisar(erro.message);
    } on UnimplementedError {
      if (mounted) _avisar('Esta operação faz parte da atividade. Consulte ATIVIDADE.md.');
    } catch (erro) {
      if (mounted) _avisar('Não foi possível concluir a operação: $erro');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _salvar() async {
    if (!_formulario.currentState!.validate()) return;
    await _executar(() async {
      await vm.salvar(id: _idEmEdicao, nome: _nome.text,
        categoria: _categoria.text, quantidade: _quantidade.text, minimo: _minimo.text);
      if (!mounted) return;
      _limpar();
      _avisar('Material salvo.');
    });
  }

  void _editar(MaterialEvento material) {
    setState(() {
      _idEmEdicao = material.id;
      _nome.text = material.nome;
      _categoria.text = material.categoria;
      _quantidade.text = material.quantidade.toString();
      _minimo.text = material.minimo.toString();
    });
  }

  Future<void> _excluir(MaterialEvento material) async {
    final confirmou = await showDialog<bool>(context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('Excluir material?'),
        content: Text('Excluir ${material.nome}? Os outros materiais serão mantidos.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogo, false),
            child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(dialogo, true),
            child: const Text('Excluir')),
        ],
      ));
    if (confirmou != true || !mounted) return;
    await _executar(() async {
      await vm.excluir(material.id!);
      if (!mounted) return;
      if (_idEmEdicao == material.id) _limpar();
      _avisar('Material excluído.');
    });
  }

  Widget _campo(TextEditingController controller, String titulo,
    {bool numerico = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(controller: controller,
      decoration: InputDecoration(labelText: titulo, border: const OutlineInputBorder()),
      keyboardType: numerico ? TextInputType.number : TextInputType.text,
      validator: numerico ? Validadores.quantidade : Validadores.textoObrigatorio),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Central de materiais'), actions: [
      IconButton(tooltip: 'Recarregar do banco', onPressed: _ocupado ? null : _carregarInicial,
        icon: const Icon(Icons.refresh)),
    ]),
    body: _falhaInicial != null ? Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Não foi possível abrir o banco.'),
        const SizedBox(height: 8), SelectableText(_falhaInicial!),
        const SizedBox(height: 16),
        FilledButton(onPressed: _carregarInicial, child: const Text('Tentar novamente')),
      ]),
    )) : AbsorbPointer(absorbing: _ocupado, child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_ocupado) const LinearProgressIndicator(),
          Text(_idEmEdicao == null ? 'Cadastrar material' : 'Editar material',
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Form(key: _formulario, child: Column(children: [
            _campo(_nome, 'Nome'),
            _campo(_categoria, 'Categoria'),
            _campo(_quantidade, 'Quantidade disponível', numerico: true),
            _campo(_minimo, 'Quantidade mínima', numerico: true),
            Row(children: [
              FilledButton(onPressed: _salvar,
                child: Text(_idEmEdicao == null ? 'Cadastrar' : 'Salvar alterações')),
              if (_idEmEdicao != null) ...[
                const SizedBox(width: 8),
                TextButton(onPressed: () => setState(_limpar), child: const Text('Cancelar')),
              ],
            ]),
          ])),
          const SizedBox(height: 28),
          const Divider(),
          AnimatedBuilder(animation: vm, builder: (context, _) {
            final materiais = vm.materiais;
            if (materiais.isEmpty) return const Padding(padding: EdgeInsets.all(24),
              child: Text('Nenhum material cadastrado.'));
            return Column(children: materiais.map((material) => Card(
              child: Padding(padding: const EdgeInsets.all(14), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(material.nome, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Categoria: ${material.categoria}'),
                  Text('Disponível: ${material.quantidade} | Mínimo: ${material.minimo}'),
                  const SizedBox(height: 8),
                  Text(material.situacao, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton.icon(onPressed: () => _editar(material),
                      icon: const Icon(Icons.edit), label: const Text('Editar')),
                    TextButton.icon(onPressed: () => _excluir(material),
                      icon: const Icon(Icons.delete_outline), label: const Text('Excluir')),
                  ]),
                ],
              )),
            )).toList());
          }),
        ]),
      )),
    )),
  );
}
