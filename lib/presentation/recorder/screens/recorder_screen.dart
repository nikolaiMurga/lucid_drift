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

  const RecorderScreen({super.key, this.contentItemId, this.initialType});

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
        initialType: initialType ?? const ContentType.affirmation(category: AffirmationCategory.confidence),
      ),
    );
  }
}

class _RecorderView extends StatefulWidget {
  final String? contentItemId;
  final ContentType initialType;
  const _RecorderView({this.contentItemId, required this.initialType});

  @override
  State<_RecorderView> createState() => _RecorderViewState();
}

class _RecorderViewState extends State<_RecorderView> {
  final _titleCtrl = TextEditingController();
  final _textCtrl = TextEditingController();
  late ContentType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
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
          context.pop();
        }
        if (state is RecorderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(widget.contentItemId != null ? 'Перезаписать' : 'Новая запись'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.contentItemId == null) ...[
                    _TypeSelector(
                      selected: _selectedType,
                      onChanged: (t) => setState(() => _selectedType = t),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: 'Название'),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Текст фразы',
                        hintText: 'Я спокоен и уверен в себе...',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Текст для чтения (если редактируем существующий)
                  if (widget.contentItemId != null) ...[
                    Text('Прочитай фразу вслух и нажми запись',
                      style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                  ],

                  // Waveform
                  Expanded(child: _Waveform(state: state)),

                  // Elapsed
                  Center(child: _ElapsedTimer(state: state)),
                  const SizedBox(height: 32),

                  // Controls
                  _RecordControls(
                    state: state,
                    onRecord: () => context.read<RecorderCubit>().startRecording(),
                    onStop: () => context.read<RecorderCubit>().stopRecording(),
                    onPlay: () => context.read<RecorderCubit>().playback(),
                    onStopPlay: () => context.read<RecorderCubit>().stopPlayback(),
                    onReset: () => context.read<RecorderCubit>().reset(),
                  ),

                  const SizedBox(height: 20),

                  // Save button
                  if (state is RecorderStopped)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dream,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => context.read<RecorderCubit>().save(
                          title: _titleCtrl.text.isNotEmpty ? _titleCtrl.text : 'Без названия',
                          text: _textCtrl.text,
                          type: _selectedType,
                          existingItemId: widget.contentItemId,
                        ),
                        child: const Text('Сохранить запись', style: TextStyle(fontSize: 16)),
                      ),
                    ),

                  if (state is RecorderSaving)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

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
          onTap: () => onChanged(const ContentType.affirmation(category: AffirmationCategory.confidence)),
        ),
        const SizedBox(width: 8),
        _TypeChip(
          label: 'Триггер',
          color: AppColors.lucid,
          isSelected: !isAffirmation,
          onTap: () => onChanged(const ContentType.lucidTrigger(technique: TriggerTechnique.mild)),
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
  const _TypeChip({required this.label, required this.color, required this.isSelected, required this.onTap});

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
        child: Text(label, style: TextStyle(
          color: isSelected ? color : AppColors.textSecondary,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        )),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  final RecorderState state;
  const _Waveform({required this.state});

  @override
  Widget build(BuildContext context) {
    final amplitude = state is RecorderRecording
        ? (state as RecorderRecording).amplitude
        : 0.0;
    final isRecording = state is RecorderRecording;

    return Center(
      child: CustomPaint(
        size: const Size(double.infinity, 80),
        painter: _WaveformPainter(
          amplitude: amplitude,
          isActive: isRecording,
          color: isRecording ? AppColors.dream : AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double amplitude;
  final bool isActive;
  final Color color;
  _WaveformPainter({required this.amplitude, required this.isActive, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const barCount = 40;
    final barWidth = size.width / (barCount * 2);
    final rng = Random(42); // seed фиксирован — статичный паттерн для idle

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth * 2 + barWidth;
      final base = isActive
          ? (rng.nextDouble() * 0.4 + 0.1)
          : 0.15;
      final h = (base + amplitude * 0.6) * size.height;
      canvas.drawLine(
        Offset(x, size.height / 2 - h / 2),
        Offset(x, size.height / 2 + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) => old.amplitude != amplitude || old.isActive != isActive;
}

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
    final elapsed = switch (state) {
      RecorderRecording(:final elapsed) => elapsed,
      RecorderStopped(:final duration) => duration,
      RecorderPlaying(:final position) => position,
      _ => Duration.zero,
    };

    return Text(
      _format(elapsed),
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w200,
        letterSpacing: 4,
        color: AppColors.textPrimary,
      ),
    );
  }
}

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
          _BigButton(icon: Icons.mic, color: AppColors.dream, onTap: onRecord, label: 'Записать'),
        ],
        RecorderRecording() => [
          _BigButton(icon: Icons.stop, color: Colors.red, onTap: onStop, label: 'Стоп'),
        ],
        RecorderStopped() => [
          _SmallButton(icon: Icons.refresh, onTap: onReset, tooltip: 'Перезаписать'),
          const SizedBox(width: 20),
          _BigButton(icon: Icons.play_arrow, color: AppColors.teal, onTap: onPlay, label: 'Слушать'),
        ],
        RecorderPlaying() => [
          _BigButton(icon: Icons.stop, color: AppColors.teal, onTap: onStopPlay, label: 'Стоп'),
        ],
        RecorderSaving() => [const CircularProgressIndicator()],
        _ => [],
      },
    );
  }
}

class _BigButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String label;
  const _BigButton({required this.icon, required this.color, required this.onTap, required this.label});

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
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  const _SmallButton({required this.icon, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.textSecondary),
      onPressed: onTap,
      tooltip: tooltip,
    );
  }
}
