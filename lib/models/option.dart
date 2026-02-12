class Option {
  final int id;
  final String text;

  Option({required this.id, required this.text});
}

/// Categories for practice mode
enum QuestionCategory {
  senales('Señales de Tránsito', '🚦'),
  circulacion('Circulación', '🚗'),
  multas('Multas y Sanciones', '⚖️'),
  seguridad('Seguridad Vial', '🛡️'),
  vehiculo('Vehículo y Documentos', '📋'),
  prioridades('Prioridades y Accidentes', '🚨');

  final String label;
  final String emoji;

  const QuestionCategory(this.label, this.emoji);
}

class Question {
  final int id;
  final String text;
  final List<Option> options;
  final int correctOptionId;
  final String? imagePath;
  final QuestionCategory category;
  final String? explanation;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionId,
    this.imagePath,
    required this.category,
    this.explanation,
  });

  /// Devuelve las opciones en desorden, incluyendo siempre la correcta
  List<Option> getShuffledOptions({int maxOptions = 4}) {
    // Si pedimos todas o más opciones de las disponibles, solo hacemos shuffle
    if (maxOptions >= options.length) {
      List<Option> shuffled = List.from(options);
      shuffled.shuffle();
      return shuffled;
    }

    // Encontrar la opción correcta
    Option correct = options.firstWhere((o) => o.id == correctOptionId);

    // Crear lista sin la opción correcta
    List<Option> others =
        options.where((o) => o.id != correctOptionId).toList();

    // Hacer shuffle de las otras opciones
    others.shuffle();

    // Tomar maxOptions - 1 de las otras opciones
    List<Option> selected = others.take(maxOptions - 1).toList();

    // Agregar la opción correcta
    selected.add(correct);

    // Hacer shuffle final para que la correcta no siempre esté al final
    selected.shuffle();

    return selected;
  }
}
