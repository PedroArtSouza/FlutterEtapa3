class Validadores {
  static String? textoObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Este campo é obrigatório e não pode conter apenas espaços.';
    }
    return null;
  }

  static String? quantidade(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe uma quantidade inteira maior ou igual a zero.';
    }
    final texto = valor.trim();
    if (!RegExp(r'^\d+$').hasMatch(texto) || int.tryParse(texto) == null) {
      return 'A quantidade deve ser um número inteiro maior ou igual a zero (sem letras, decimais ou negativos).';
    }
    return null;
  }
}
