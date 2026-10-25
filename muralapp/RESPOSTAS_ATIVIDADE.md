# Comentários em Tempo Real — Respostas

**1. Como o Firebase identifica quem escreveu determinado comentário?**  
O Firebase Authentication identifica o usuário autenticado pelo `uid`, obtido por `FirebaseAuth.instance.currentUser!.uid`. Esse valor é salvo no campo `autorId` de cada comentário. O nome vem do documento do usuário no Firestore.

**2. Como relacionar um comentário a uma publicação específica?**  
Os comentários são armazenados na subcoleção `publicacoes/{publicacaoId}/comentarios`. Além disso, cada comentário salva o campo `publicacaoId`. A página recebe o identificador do post selecionado e consulta só essa subcoleção.

**3. Por que utilizamos StreamBuilder para mostrar os comentários?**  
Porque o `StreamBuilder` acompanha o fluxo de snapshots do Cloud Firestore e reconstrói a lista toda vez que há mudanças, sem exigir atualização manual.

**4. Como garantir que os comentários apareçam automaticamente em contas diferentes?**  
As contas acessam o mesmo projeto Firebase e escutam a mesma subcoleção da publicação com `.snapshots()`. Quando uma conta adiciona um comentário, o Firestore envia a atualização em tempo real para as outras contas que estão acompanhando aquela discussão.

## Teste manual obrigatório

1. Configure no console Firebase as regras de `firestore.rules` (Firestore Database → Regras → Publicar).
2. Inicie o app com `flutter pub get` e `flutter run` (o Firebase já deve estar configurado para o seu projeto).
3. Entre em duas sessões com contas diferentes e abra a mesma publicação nas duas.
4. Envie comentários e confirme que aparecem automaticamente nas duas telas.
5. Abra uma publicação diferente e confira que seus comentários ficam separados.
6. Verifique que o botão de excluir só aparece nos próprios comentários. Confira também que a regra do Firestore bloqueia exclusões feitas por outras contas.

**Atenção:** as regras do Firestore devem ser publicadas no projeto Firebase usado pelo aplicativo. Adicionar o arquivo ao repositório não as aplica automaticamente. Um teste com duas contas reais exige executar o aplicativo conectado ao Firebase.
