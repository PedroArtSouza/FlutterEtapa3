# Revisão – Fila de impressão

## Correção escolhida: marcação individual

- **Arquivo:** `lib/repositories/impressao_repository.dart`
- **Método:** `alternarImpressao`
- **Causa:** a consulta de atualização usava `where: 'id <> ?'`, ou seja, alterava todos os documentos, menos o selecionado.
- **Solução:** troquei a condição para `where: 'id = ?'`, usando o ID do documento escolhido. Assim, apenas ele tem o campo `impresso` atualizado e a mudança fica salva no SQLite.

## Outras mudanças

- Ajustei a listagem para `id ASC` (ordem de chegada).
- Corrigi a validação para aceitar somente inteiros maiores que zero.
- Corrigi a quantidade de folhas para `paginas * copias`.
- Corrigi o filtro **Pendentes** para buscar `impresso == 0`.
- Ativei o DevicePreview no `main.dart` e usei `Wrap` nos botões do formulário para evitar cortes em telas estreitas.

## Conferência no Chrome

Os resultados esperados com **Restaurar amostras** são:

| Documento | Páginas | Cópias | Folhas | Impresso |
| --- | ---: | ---: | ---: | --- |
| Roteiro do evento | 4 | 3 | 12 | Não |
| Cartaz da oficina | 2 | 5 | 10 | Não |
| Lista de presença | 1 | 2 | 2 | Sim |

Resumo: **3 documentos / 24 folhas**. Filtro Pendentes: **Roteiro do evento** e **Cartaz da oficina**.

**Testes manuais a fazer no seu computador:** conferir os dois tamanhos de celular no DevicePreview, rejeitar zero no cadastro/edição, alternar impressão individualmente, atualizar a página para conferir persistência e testar cadastro, edição e exclusão. Não marquei esses testes como executados porque não tenho Flutter/Chrome disponível neste ambiente.
