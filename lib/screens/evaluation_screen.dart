import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static const _destinatario = 'gutierrezpablo121@gmail.com';

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final raw = await rootBundle.loadString('assets/data/evaluation.json');
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

  String _buildResultText() {
    final buffer = StringBuffer();
    buffer.writeln('=== Evaluación Beta — Library Anime ===\n');
    for (final section in _sections) {
      buffer.writeln('── ${section.name} ──');
      for (final q in section.questions) {
        final stars = '★' * q.valor.round() + '☆' * (5 - q.valor.round());
        buffer.writeln(q.titulo);
        buffer.writeln(
            'Calificación: $stars (${q.valor.toStringAsFixed(0)}/5)\n');
      }
    }
    final total = _sections
        .expand((s) => s.questions)
        .fold(0.0, (sum, q) => sum + q.valor);
    final count = _sections.expand((s) => s.questions).length;
    final avg = count > 0 ? (total / count).toStringAsFixed(1) : '0.0';
    buffer.writeln('Promedio general: $avg / 5.0');
    return buffer.toString();
  }

  Future<void> _sendResults(AppLocalizations l) async {
    final texto = _buildResultText();
    const asunto = 'Evaluación Beta — Library Anime';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _destinatario,
      query: _encodeQuery({'subject': asunto, 'body': texto}),
    );

    try {
      final launched =
          await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      if (launched) {
        setState(() => _submitted = true);
      } else {
        _showError(l);
      }
    } catch (_) {
      _showError(l);
    }
  }

  void _showError(AppLocalizations l) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.evalEmailError),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) =>
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
    final l = AppLocalizations.of(context)!;

    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (_submitted) return _buildThanks(l);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l.evalTitle, style: AppTextStyles.headline3),
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
                      Text(l.evalBanner, style: AppTextStyles.headline3),
                      const SizedBox(height: 4),
                      Text(l.evalBannerDesc, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _LiveAverage(avg: _overallAvg, label: l.evalAverage),
          const SizedBox(height: 24),

          for (final section in _sections) ...[
            _SectionHeader(title: section.name),
            const SizedBox(height: 12),
            for (final q in section.questions)
              _QuestionCard(
                question: q,
                starHint: l.evalStarHint,
                onChanged: (val) => setState(() => q.valor = val),
              ),
            const SizedBox(height: 8),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _sendResults(l),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.send_rounded, color: Colors.white),
        label: Text(l.evalSend,
            style: AppTextStyles.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildThanks(AppLocalizations l) => Scaffold(
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
                Text(l.evalThanks, style: AppTextStyles.headline1),
                const SizedBox(height: 8),
                Text(
                  l.evalThanksDesc,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.evalBack),
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
  final String label;
  const _LiveAverage({required this.avg, required this.label});

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
                Text(label, style: AppTextStyles.label),
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

// ── Card de pregunta ───────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final _Question question;
  final String starHint;
  final ValueChanged<double> onChanged;
  const _QuestionCard(
      {required this.question,
      required this.starHint,
      required this.onChanged});

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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              question.valor == 0
                  ? starHint
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

// ── JSON por defecto ────────────────────────────────────────────

const String _defaultJson = '''
{
  "usabilidad": [
    {"titulo": "Pregunta 1: ¿Qué tan fácil fue navegar a través de la aplicación?", "valor": 0, "min": "0 estrellas: Fue muy difícil.", "max": "5 estrellas: Fue extremadamente fácil."},
    {"titulo": "Pregunta 2: ¿Pudiste completar tus tareas sin problemas?", "valor": 0, "min": "0 estrellas: No pude completar las tareas.", "max": "5 estrellas: Pude completarlas de forma rápida."},
    {"titulo": "Pregunta 3: ¿Cómo calificas la interfaz gráfica?", "valor": 0, "min": "0 estrellas: La interfaz es poco clara.", "max": "5 estrellas: La interfaz es clara y atractiva."}
  ],
  "contenido": [
    {"titulo": "Pregunta 4: ¿El contenido fue útil para ti?", "valor": 0, "min": "0 estrellas: No fue relevante.", "max": "5 estrellas: Fue muy útil."},
    {"titulo": "Pregunta 5: ¿El contenido se adapta a tus expectativas?", "valor": 0, "min": "0 estrellas: No cumplió mis expectativas.", "max": "5 estrellas: Las superó completamente."},
    {"titulo": "Pregunta 6: ¿El contenido está presentado de manera clara?", "valor": 0, "min": "0 estrellas: Está mal estructurado.", "max": "5 estrellas: Muy bien presentado."}
  ],
  "compartir": [
    {"titulo": "Pregunta 7: ¿Qué tan probable es que recomiendes la app?", "valor": 0, "min": "0 estrellas: No la recomendaría.", "max": "5 estrellas: Definitivamente la recomendaría."},
    {"titulo": "Pregunta 8: ¿Cómo te sentirías al compartirla?", "valor": 0, "min": "0 estrellas: No me sentiría cómodo.", "max": "5 estrellas: Me sentiría muy cómodo."},
    {"titulo": "Pregunta 9: ¿Crees que sería útil para personas cercanas?", "valor": 0, "min": "0 estrellas: No creo que sea útil.", "max": "5 estrellas: Estoy seguro que sería muy útil."}
  ]
}
''';
