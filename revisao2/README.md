# Como executar

Com Flutter e Google Chrome instalados, extraia o ZIP e abra um terminal na
pasta do projeto, onde está o arquivo `pubspec.yaml`.

Instale as dependências:

```sh
flutter pub get
```

Execute no Chrome:

```sh
flutter run -d chrome --web-port=8080
```

Para encerrar, pressione `Ctrl+C` no terminal.

## Revisão da atividade

O DevicePreview já está habilitado em modo de desenvolvimento. Depois de abrir o projeto no Chrome, use seus controles para selecionar dois celulares diferentes. O banco permanece sendo o SQLite com o worker e o WASM da pasta `web`.

As correções feitas e a explicação para a entrega estão no `REVISAO.md`.
