import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/content_type.dart';
import '../cubit/recorder_cubit.dart';
import '../cubit/recorder_state.dart';

class RecorderScreen extends StatelessWidget {
  final String? contentItemId;
  final ContentType? initialType;
  final String? phraseText; // текст для чтения вслух

  const RecorderScreen({
    super.key,
    this.contentItemId,
    this.initialType,
    this.phraseText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecorderCubit(
        recorder: AudioRecorder(),
        player: AudioPlayer(),
        saveItem: sl(),
        attachAudio: sl(),
        preparePath: sl(),
        deleteAudio: sl(),
      )..init(),
      child: _RecorderView(
        contentItemId: contentItemId,
        initialType: initialType ??
            const ContentType.affirmation(
                category: AffirmationCategory.confidence),
        phraseText: phraseText,
      ),
    );
  }
}

class _RecorderView extends StatefulWidget {
  final String? contentItemId;
  final ContentType initialType;
  final String? phraseText;

  const _RecorderView({
    this.contentItemId,
    required this.initialType,
    this.phraseText,
  });

  @override
  State<_RecorderView> createState() => _RecorderViewState();
}

class _RecorderViewState extends State<_RecorderView> {
  final _titleCtrl = TextEditingController();
  final _textCtrl = TextEditingController();
  late ContentType _selectedType;

  bool get _isEditing => widget.contentItemId != null;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    if (widget.phraseText != null) {
      _textCtrl.text = widget.phraseText!;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecorderCubit, RecorderState>(
      listener: (context, state) {
        if (state is RecorderSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Запись сохранена'),
              backgroundColor: AppColors.teal,
              duration: Duration(seconds: 2),
            ),
          );
          context.pop();
        }
        if (state is RecorderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(_isEditing ? 'Перезаписать' : 'Новая запись'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Форма — только для новых
                  if (!_isEditing) ...[
                    _TypeSelector(
                      selected: _selectedType,
                      onChanged: (t) => setState(() => _selectedType = t),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Название'),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Текст фразы — всегда показываем
                  if (widget.phraseText != null || !_isEditing) ...[
                    _PhraseCard(
                      text: widget.phraseText ?? _textCtrl.text,
                      type: _selectedType,
                      isEditing: !_isEditing,
                      controller: _isEditing ? null : _textCtrl,
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Waveform
                  _Waveform(state: state),
                  const SizedBox(height: 8),

                  // Таймер
                  Center(child: _ElapsedTimer(state: state)),
                  const SizedBox(height: 32),

                  // Кнопки управления записью
                  _RecordControls(
                    state: state,
                    onRecord: () =>
                        context.read<RecorderCubit>().startRecording(),
                    onStop: () =>
                        context.read<RecorderCubit>().stopRecording(),
                    onPlay: () => context.read<RecorderCubit>().playback(),
                    onStopPlay: () =>
                        context.read<RecorderCubit>().stopPlayback(),
                    onReset: () => context.read<RecorderCubit>().reset(),
                  ),

                  const SizedBox(height: 24),

                  // Кнопка сохранить
                  if (state is RecorderStopped)
                    _SaveButton(
                      onSave: () => context.read<RecorderCubit>().save(
                        title: _titleCtrl.text.isNotEmpty
                            ? _titleCtrl.text
                            : 'Без названия',
                        text: _textCtrl.text.isNotEmpty
                            ? _textCtrl.text
                            : (widget.phraseText ?? ''),
                        type: _selectedType,
                        existingItemId: widget.contentItemId,
                      ),
                    ),

                  if (state is RecorderSaving)
                    const Center(child: CircularProgressIndicator()),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Phrase card ──────────────────────────────────────────────────────────────

class _PhraseCard extends StatelessWidget {
  final String text;
  final ContentType type;
  final bool isEditing;
  final TextEditingController? controller;

  const _PhraseCard({
    required this.text,
    required this.type,
    required this.isEditing,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final color = type is AffirmationContent ? AppColors.affirmation : AppColors.lucid;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                type is AffirmationContent
                    ? Icons.self_improvement
                    : Icons.visibility_outlined,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                'Прочитай вслух:',
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isEditing && controller != null)
            TextField(
              controller: controller,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w300,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                hintText: 'Я спокоен и уверен в себе...',
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            )
          else
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w300,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Type selector ────────────────────────────────────────────────────────────

class _TypeSelector extends StatelessWidget {
  final ContentType selected;
  final ValueChanged<ContentType> onChanged;
  const _TypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isAffirmation = selected is AffirmationContent;
    return Row(
      children: [
        _TypeChip(
          label: 'Аффирмация',
          color: AppColors.affirmation,
          isSelected: isAffirmation,
          onTap: () => onChanged(const ContentType.affirmation(
              category: AffirmationCategory.confidence)),
        ),
        const SizedBox(width: 8),
        _TypeChip(
          label: 'Триггер',
          color: AppColors.lucid,
          isSelected: !isAffirmation,
          onTap: () => onChanged(const ContentType.lucidTrigger(
              technique: TriggerTechnique.mild)),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(color: isSelected ? color : AppColors.border),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Waveform ─────────────────────────────────────────────────────────────────

class _Waveform extends StatelessWidget {
  final RecorderState state;
  const _Waveform({required this.state});

  @override
  Widget build(BuildContext context) {
    final isRecording = state is RecorderRecording;
    final isPlaying = state is RecorderPlaying;
    final amplitude = isRecording
        ? (state as RecorderRecording).amplitude
        : (isPlaying ? 0.4 : 0.0);

    return SizedBox(
      height: 72,
      child: CustomPaint(
        size: const Size(double.infinity, 72),
        painter: _WaveformPainter(
          amplitude: amplitude,
          isActive: isRecording || isPlaying,
          color: isRecording
              ? AppColors.dream
              : isPlaying
                  ? AppColors.teal
                  : AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double amplitude;
  final bool isActive;
  final Color color;

  _WaveformPainter({
    required this.amplitude,
    required this.isActive,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const barCount = 40;
    final spacing = size.width / barCount;
    final rng = Random(42);

    for (int i = 0; i < barCount; i++) {
      final x = i * spacing + spacing / 2;
      final base = isActive ? (rng.nextDouble() * 0.3 + 0.05) : 0.1;
      final h = (base + amplitude * 0.65) * size.height;
      canvas.drawLine(
        Offset(x, size.height / 2 - h / 2),
        Offset(x, size.height / 2 + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.amplitude != amplitude || old.isActive != isActive || old.color != color;
}

// ─── Elapsed timer ────────────────────────────────────────────────────────────

class _ElapsedTimer extends StatelessWidget {
  final RecorderState state;
  const _ElapsedTimer({required this.state});

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final duration = switch (state) {
      RecorderRecording(:final elapsed) => elapsed,
      RecorderStopped(:final duration) => duration,
      RecorderPlaying(:final total) => total,
      _ => Duration.zero,
    };

    final position = state is RecorderPlaying
        ? (state as RecorderPlaying).position
        : null;

    return Column(
      children: [
        Text(
          position != null
              ? '${_format(position)} / ${_format(duration)}'
              : _format(duration),
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w200,
            letterSpacing: 4,
            color: AppColors.textPrimary,
          ),
        ),
        if (state is RecorderPlaying) ...[
          const SizedBox(height: 8),
          _PlaybackProgressBar(state: state as RecorderPlaying),
        ],
      ],
    );
  }
}

class _PlaybackProgressBar extends StatelessWidget {
  final RecorderPlaying state;
  const _PlaybackProgressBar({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: LinearProgressIndicator(
        value: state.progress,
        backgroundColor: AppColors.border,
        valueColor: const AlwaysStoppedAnimation(AppColors.teal),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ─── Record controls ──────────────────────────────────────────────────────────

class _RecordControls extends StatelessWidget {
  final RecorderState state;
  final VoidCallback onRecord;
  final VoidCallback onStop;
  final VoidCallback onPlay;
  final VoidCallback onStopPlay;
  final VoidCallback onReset;

  const _RecordControls({
    required this.state,
    required this.onRecord,
    required this.onStop,
    required this.onPlay,
    required this.onStopPlay,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: switch (state) {
        RecorderIdle() || RecorderReady() => [
            _BigButton(
              icon: Icons.mic,
              color: AppColors.dream,
              onTap: onRecord,
              label: 'Записать',
            ),
          ],
        RecorderRecording() => [
            _BigButton(
              icon: Icons.stop,
              color: Colors.red,
              onTap: onStop,
              label: 'Стоп',
            ),
          ],
        RecorderStopped() => [
            _SmallButton(
              icon: Icons.refresh,
              onTap: onReset,
              tooltip: 'Перезаписать',
            ),
            const SizedBox(width: 24),
            _BigButton(
              icon: Icons.play_arrow,
              color: AppColors.teal,
              onTap: onPlay,
              label: 'Прослушать',
            ),
          ],
        RecorderPlaying() => [
            _BigButton(
              icon: Icons.stop,
              color: AppColors.teal,
              onTap: onStopPlay,
              label: 'Стоп',
            ),
          ],
        RecorderSaving() || RecorderSaved() => [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(),
            ),
          ],
        RecorderError() => [
            _BigButton(
              icon: Icons.mic,
              color: AppColors.dream,
              onTap: onRecord,
              label: 'Попробовать снова',
            ),
          ],
      },
    );
  }
}

class _BigButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String label;

  const _BigButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _SmallButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.textSecondary),
      onPressed: onTap,
      tooltip: tooltip,
    );
  }
}

// ─── Save button ──────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final VoidCallback onSave;
  const _SaveButton({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dream,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onSave,
        icon: const Icon(Icons.check, color: AppColors.textPrimary),
        label: const Text(
          'Сохранить запись',
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
