import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/content_item.dart';
import '../../../../domain/entities/audio_source.dart';

class ContentItemTile extends StatelessWidget {
  final ContentItem item;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onStopPlay;
  final VoidCallback onRecord;
  final VoidCallback onDelete;

  const ContentItemTile({
    super.key,
    required this.item,
    required this.isPlaying,
    required this.onPlay,
    required this.onStopPlay,
    required this.onRecord,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = item.isAffirmation ? AppColors.affirmation : AppColors.lucid;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      confirmDismiss: (_) async => await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surfaceHigh,
          title: const Text('Удалить?'),
          content: Text('«${item.title}» будет удалён безвозвратно.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isPlaying
              ? typeColor.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPlaying ? typeColor.withValues(alpha: 0.4) : AppColors.border,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          title: Text(
            item.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.text,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.audioDuration != null) ...[
                const SizedBox(height: 3),
                _AudioBadge(item: item, isPlaying: isPlaying, typeColor: typeColor),
              ],
            ],
          ),
          trailing: _TrailingActions(
            item: item,
            isPlaying: isPlaying,
            typeColor: typeColor,
            onPlay: onPlay,
            onStopPlay: onStopPlay,
            onRecord: onRecord,
          ),
        ),
      ),
    );
  }
}

class _AudioBadge extends StatelessWidget {
  final ContentItem item;
  final bool isPlaying;
  final Color typeColor;

  const _AudioBadge({
    required this.item,
    required this.isPlaying,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    final duration = item.audioDuration!;
    final secs = duration.inSeconds;
    final label = secs < 60
        ? '${secs}с'
        : '${duration.inMinutes}:${(secs % 60).toString().padLeft(2, '0')}';
    final isOwn = item.audioSource is OwnRecording;

    return Row(
      children: [
        Icon(
          isPlaying
              ? Icons.graphic_eq
              : (isOwn ? Icons.mic : Icons.auto_awesome),
          size: 11,
          color: isPlaying ? typeColor : AppColors.textTertiary,
        ),
        const SizedBox(width: 3),
        Text(
          isPlaying
              ? 'Воспроизведение...'
              : (isOwn ? 'Запись · $label' : 'AI · $label'),
          style: TextStyle(
            fontSize: 11,
            color: isPlaying ? typeColor : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _TrailingActions extends StatelessWidget {
  final ContentItem item;
  final bool isPlaying;
  final Color typeColor;
  final VoidCallback onPlay;
  final VoidCallback onStopPlay;
  final VoidCallback onRecord;

  const _TrailingActions({
    required this.item,
    required this.isPlaying,
    required this.typeColor,
    required this.onPlay,
    required this.onStopPlay,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.hasAudio) ...[
          // Play / Stop
          IconButton(
            icon: Icon(
              isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
              color: isPlaying ? typeColor : AppColors.teal,
            ),
            onPressed: isPlaying ? onStopPlay : onPlay,
            tooltip: isPlaying ? 'Стоп' : 'Прослушать',
          ),
          // Re-record
          IconButton(
            icon: const Icon(Icons.mic_none, color: AppColors.textTertiary, size: 20),
            onPressed: onRecord,
            tooltip: 'Перезаписать',
          ),
        ] else ...[
          // No audio — only record button, highlighted
          IconButton(
            icon: const Icon(Icons.mic, color: AppColors.dream),
            onPressed: onRecord,
            tooltip: 'Записать голос',
          ),
        ],
      ],
    );
  }
}
