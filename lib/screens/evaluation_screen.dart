import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// ── Modelos ────────────────────────────────────────────────────

class _Question {
  final String titulo;
  double valor;
  final String min;
  final String max;

  _Question({
    required this.titulo,
    required this.valor,
    required this.min,
    required this.max,
  });

  factory _Question.fromJson(Map<String, dynamic> json) => _Question(
        titulo: json['titulo'] as String,
        valor: (json['valor'] as num).toDouble(),
        min: json['min'] as String,
        max: json['max'] as String,
      );
}

class _Section {
  final String name;
  final List<_Question> questions;
  _Section({required this.name, required this.questions});
}

// ── Pantalla principal ─────────────────────────────────────────

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  List<_Section> _sections = [];
  bool _loading = true;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    // Carga el JSON desde assets; si falla usa el JSON hardcodeado
    try {
      final raw =
          await rootBundle.loadString('assets/data/evaluation.json');
      _parseJson(raw);
    } catch (_) {
      _parseJson(_defaultJson);
    }
    setState(() => _loading = false);
  }

  void _parseJson(String raw) {
    final Map<String, dynamic> data = json.decode(raw);
    _sections = data.entries.map((e) {
      final list = (e.value as List)
          .map((q) => _Question.fromJson(q as Map<String, dynamic>))
          .toList();
      return _Section(name: _sectionLabel(e.key), questions: list);
    }).toList();
  }

  String _sectionLabel(String key) {
    const labels = {
      'usabilidad': 'Usabilidad',
      'contenido': 'Contenido',
      'compartir': 'Recomendación',
    };
    return labels[key] ?? key;
  }

  // ── Enviar por email ───────────────────────────────────────
  Future<void> _sendResults() async {
    final buffer = StringBuffer();
    buffer.writeln('=== Evaluación Beta — Library Anime ===\n');

    for (final section in _sections) {
      buffer.writeln('── ${section.name} ──');
      for (final q in section.questions) {
        final stars = '★' * q.valor.round() + '☆' * (5 - q.valor.round());
        buffer.writeln('${q.titulo}');
        buffer.writeln('Calificación: $stars (${q.valor.toStringAsFixed(0)}/5)\n');
      }
    }

    final total = _sections
        .expand((s) => s.questions)
        .fold(0.0, (sum, q) => sum + q.valor);
    final count = _sections.expand((s) => s.questions).length;
    final avg = count > 0 ? (total / count).toStringAsFixed(1) : '0.0';
    buffer.writeln('Promedio general: $avg / 5.0');

    final String textoFinal = buffer.toString();
    
    // ── PRIMERA FORMA (CORREGIDA PARA MOSTRAR DESTINATARIO) ──
    final String tuCorreo = 'gutierrezpablo121@gmail.com'; //
    final String asunto = 'Evaluación Beta — Library Anime';

    // Construimos la URI separando el correo (path) de las variables (query)
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: tuCorreo, // Esto asegura que aparezca en el campo "Para:"
      query: encodeQueryParameters(<String, String>{
        'subject': asunto,
        'body': textoFinal,
      }),
    );

    try {
      // PLAN A: Intentar abrir la aplicación de correo por defecto del sistema
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        setState(() => _submitted = true);
      } else {
        // PLAN B: Si el dispositivo no tiene app de correo configurada, usa Compartir
        await _fallbackShare(textoFinal);
      }
    } catch (_) {
      // Si ocurre un error inesperado, también ofrece Compartir como respaldo
      await _fallbackShare(textoFinal);
    }
  }
  Future<void> _fallbackShare(String texto) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se detectó app de correo. Elige cómo enviarlo:'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    // Abre el menú nativo (WhatsApp, Copiar, etc.) usando la sintaxis correcta de share_plus
    await Share.share(
      texto,
      subject: 'Evaluación Beta — Library Anime',
    );
    
    setState(() => _submitted = true);
  }

  // Codificador para que el texto se procese bien en la URL del correo
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  double get _overallAvg {
    final all = _sections.expand((s) => s.questions).toList();
    if (all.isEmpty) return 0;
    return all.fold(0.0, (s, q) => s + q.valor) / all.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_submitted) return _buildThanks();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Evaluación Beta', style: AppTextStyles.headline3),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          // ── Banner ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1040), AppColors.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.rate_review_rounded,
                      color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Beta Testing', style: AppTextStyles.headline3),
                      const SizedBox(height: 4),
                      Text(
                        'Ayúdanos a mejorar Library Anime con tu opinión.',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Promedio en vivo ─────────────────────────────────
          _LiveAverage(avg: _overallAvg),
          const SizedBox(height: 24),

          // ── Secciones ────────────────────────────────────────
          for (final section in _sections) ...[
            _SectionHeader(title: section.name),
            const SizedBox(height: 12),
            for (final q in section.questions)
              _QuestionCard(
                question: q,
                onChanged: (val) => setState(() => q.valor = val),
              ),
            const SizedBox(height: 8),
          ],
        ],
      ),

      // ── FAB enviar ───────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendResults,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.send_rounded, color: Colors.white),
        label: Text('Enviar evaluación',
            style: AppTextStyles.button.copyWith(color: Colors.white)),
      ),
    );
  }

  // ── Pantalla de gracias ──────────────────────────────────────
  Widget _buildThanks() => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withValues(alpha: 0.15),
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 48),
                ),
                const SizedBox(height: 24),
                Text('¡Gracias!', style: AppTextStyles.headline1),
                const SizedBox(height: 8),
                Text(
                  'Tu evaluación fue enviada correctamente.\nTu feedback nos ayuda a mejorar.',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

// ── Promedio en vivo ───────────────────────────────────────────

class _LiveAverage extends StatelessWidget {
  final double avg;
  const _LiveAverage({required this.avg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            avg.toStringAsFixed(1),
            style: AppTextStyles.headline1.copyWith(
              color: AppColors.warning,
              fontSize: 40,
            ),
          ),
          const SizedBox(width: 4),
          Text('/ 5.0', style: AppTextStyles.bodySmall),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Promedio actual', style: AppTextStyles.label),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: avg / 5.0,
                    backgroundColor: AppColors.surfaceVariant,
                    color: AppColors.warning,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card de pregunta con estrellas ─────────────────────────────

class _QuestionCard extends StatelessWidget {
  final _Question question;
  final ValueChanged<double> onChanged;
  const _QuestionCard({required this.question, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.titulo, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          // Estrellas interactivas
          Row(
            children: List.generate(5, (i) {
              final starVal = (i + 1).toDouble();
              return GestureDetector(
                onTap: () => onChanged(starVal),
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    question.valor >= starVal
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: question.valor >= starVal
                        ? AppColors.warning
                        : AppColors.textDisabled,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Descripción del extremo seleccionado
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              question.valor == 0
                  ? 'Toca las estrellas para calificar'
                  : question.valor <= 2
                      ? question.min
                      : question.max,
              key: ValueKey(question.valor),
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textDisabled),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.headline3),
        ],
      );
}

// ── JSON por defecto (si no existe assets/data/evaluation.json) ─

const String _defaultJson = '''
{
  "usabilidad": [
    {
      "titulo": "Pregunta 1: ¿Qué tan fácil fue navegar a través de la aplicación?",
      "valor": 0,
      "min": "0 estrellas: Fue muy difícil encontrar las funcionalidades, la navegación fue confusa.",
      "max": "5 estrellas: Fue extremadamente fácil, la navegación es intuitiva y sin complicaciones."
    },
    {
      "titulo": "Pregunta 2: ¿Pudiste completar tus tareas en la aplicación sin problemas?",
      "valor": 0,
      "min": "0 estrellas: No pude completar las tareas, fue frustrante.",
      "max": "5 estrellas: Pude completar todas las tareas de forma rápida y eficiente."
    },
    {
      "titulo": "Pregunta 3: ¿Cómo calificas la interfaz gráfica en términos de diseño y claridad?",
      "valor": 0,
      "min": "0 estrellas: La interfaz es poco clara y difícil de entender.",
      "max": "5 estrellas: La interfaz es clara, atractiva y facilita el uso."
    }
  ],
  "contenido": [
    {
      "titulo": "Pregunta 4: ¿El contenido de la aplicación fue útil para ti?",
      "valor": 0,
      "min": "0 estrellas: El contenido no fue relevante ni útil.",
      "max": "5 estrellas: El contenido fue muy útil y relevante para mis necesidades."
    },
    {
      "titulo": "Pregunta 5: ¿Qué tan bien el contenido se adapta a tus expectativas?",
      "valor": 0,
      "min": "0 estrellas: El contenido no cumplió con mis expectativas.",
      "max": "5 estrellas: El contenido superó completamente mis expectativas."
    },
    {
      "titulo": "Pregunta 6: ¿El contenido está presentado de manera clara y comprensible?",
      "valor": 0,
      "min": "0 estrellas: El contenido está mal estructurado o es confuso.",
      "max": "5 estrellas: El contenido está muy bien presentado y es fácil de comprender."
    }
  ],
  "compartir": [
    {
      "titulo": "Pregunta 7: ¿Qué tan probable es que recomiendes esta aplicación?",
      "valor": 0,
      "min": "0 estrellas: No la recomendaría en absoluto.",
      "max": "5 estrellas: Definitivamente la recomendaría."
    },
    {
      "titulo": "Pregunta 8: ¿Cómo te sentirías al compartir esta app con alguien más?",
      "valor": 0,
      "min": "0 estrellas: No me sentiría cómodo compartiéndola.",
      "max": "5 estrellas: Me sentiría muy cómodo compartiéndola."
    },
    {
      "titulo": "Pregunta 9: ¿Crees que esta aplicación podría ser útil para personas cercanas?",
      "valor": 0,
      "min": "0 estrellas: No creo que sea útil para otras personas.",
      "max": "5 estrellas: Estoy seguro de que sería muy útil para personas cercanas."
    }
  ]
}
''';