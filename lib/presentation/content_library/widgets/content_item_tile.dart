import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/audio_source.dart';

class ContentItemTile extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onPlay;
  final VoidCallback onRecord;
  final VoidCallback onDelete;

  const ContentItemTile({
    super.key,
    required this.item,
    required this.onPlay,
    required this.onRecord,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.surfaceHigh,
            title: const Text('Удалить?'),
            content: Text('«${item.title}» будет удалён безвозвратно.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Удалить', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Тип-индикатор
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                color: item.isAffirmation ? AppColors.affirmation : AppColors.lucid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    item.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.audioDuration != null) ...[
                    const SizedBox(height: 4),
                    _AudioBadge(item: item),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Actions
            if (item.hasAudio)
              IconButton(
                icon: const Icon(Icons.play_circle_outline, color: AppColors.teal),
                onPressed: onPlay,
                tooltip: 'Прослушать',
              )
            else
              IconButton(
                icon: const Icon(Icons.mic_none, color: AppColors.dream),
                onPressed: onRecord,
                tooltip: 'Записать голос',
              ),
          ],
        ),
      ),
    );
  }
}

class _AudioBadge extends StatelessWidget {
  final ContentItem item;
  const _AudioBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    final duration = item.audioDuration!;
    final label = '${duration.inSeconds}с';

    final isOwn = item.audioSource is OwnRecording;

    return Row(
      children: [
        Icon(
          isOwn ? Icons.mic : Icons.auto_awesome,
          size: 11,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 3),
        Text(
          isOwn ? 'Запись · $label' : 'AI · $label',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
