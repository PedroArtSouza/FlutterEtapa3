# Revisão 1 — Central de Materiais

Nome: Pedro Artur de Souza Araujo
Turma: 3A2

## Registro dos testes

Os resultados esperados abaixo foram conferidos por inspeção das regras implementadas. **A execução no Chrome ainda deve ser realizada no computador com Flutter instalado**; marque os resultados encontrados depois de testar na interface.

| Teste | Resultado esperado | Resultado encontrado |
|---|---|---|
| Nome vazio/espaços | Rejeitar e exibir mensagem de campo obrigatório | Pendente de teste no Chrome |
| Quantidade negativa | Rejeitar e informar que deve ser inteiro não negativo | Pendente de teste no Chrome |
| Quantidade decimal | Rejeitar e informar que deve ser inteiro não negativo | Pendente de teste no Chrome |
| Nome repetido com maiúsculas/espaços | Impedir duplicidade | Pendente de teste no Chrome |
| Edição mantendo o próprio nome | Permitir salvar | Pendente de teste no Chrome |
| Edição para o nome de outro material | Impedir duplicidade | Pendente de teste no Chrome |
| Cadastro com atualização automática | Aparecer na lista sem recarregar manualmente | Pendente de teste no Chrome |
| Edição persistida após recarregar | Manter os novos valores no SQLite | Pendente de teste no Chrome |
| Cancelamento da exclusão | Manter o registro | Pendente de teste no Chrome |
| Exclusão individual | Remover apenas o material escolhido | Pendente de teste no Chrome |
| Quantidade zero e mínimo zero | Sem estoque | Pendente de teste no Chrome |
| Quantidade abaixo do mínimo | Estoque baixo | Pendente de teste no Chrome |
| Quantidade igual ao mínimo (maior que zero) | Estoque adequado | Pendente de teste no Chrome |


**Validação escolhida:** quantidade disponível e quantidade mínima devem ser números inteiros maiores ou iguais a zero.

**Arquivo e método:** `lib/utils/validadores.dart`, método estático `Validadores.quantidade(String? valor)`.

**Por que esse local é adequado?** A classe `Validadores` concentra as regras de entrada, permitindo que a interface (`materiais_page.dart`) e a ViewModel (`material_viewmodel.dart`) reutilizem a mesma validação. Isso evita regras duplicadas, facilita a manutenção e impede que valores inválidos sejam enviados ao repositório. O método recusa campos vazios, letras, valores negativos, decimais e números que não cabem no tipo `int`.

## Como executar

1. Abra a pasta que contém `pubspec.yaml` no VS Code.
2. Execute `flutter pub get`.
3. Confira `web/sqlite3.wasm` e `web/sqflite_sw.js` (ambos incluídos).
4. Execute `flutter run -d chrome --web-port=8080`.
5. Realize os testes e substitua os resultados pendentes pelos resultados observados.
