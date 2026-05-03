import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/content_item.dart';
import '../../../../domain/entities/audio_source.dart';

class ContentItemTile extends StatelessWidget {
  final ContentItem item;
  final bool isPlaying;
  final bool isInPlaylist;
  final bool showDragHandle;
  final VoidCallback onPlay;
  final VoidCallback onStopPlay;
  final VoidCallback onRecord;
  final VoidCallback onDelete;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onRemoveFromPlaylist;

  const ContentItemTile({
    super.key,
    required this.item,
    required this.isPlaying,
    required this.isInPlaylist,
    this.showDragHandle = false,
    required this.onPlay,
    required this.onStopPlay,
    required this.onRecord,
    required this.onDelete,
    required this.onAddToPlaylist,
    required this.onRemoveFromPlaylist,
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
        decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      confirmDismiss: (_) async => await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surfaceHigh,
          title: const Text('Удалить?'),
          content: Text('«${item.title}» будет удалён безвозвратно.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Отмена')),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isPlaying ? typeColor.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isPlaying ? typeColor.withValues(alpha: 0.4) : AppColors.border),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: showDragHandle ? const Icon(Icons.drag_handle, color: AppColors.textTertiary, size: 24) : null,
          title: Text(item.title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.text, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Row(
                children: [
                  if (item.audioDuration != null)
                    Flexible(
                      child: _AudioBadge(item: item, isPlaying: isPlaying, typeColor: typeColor),
                    ),
                  if (isInPlaylist) ...[
                    if (item.audioDuration != null) const SizedBox(width: 6),
                    const Icon(Icons.queue_music, size: 11, color: AppColors.lucid),
                    const SizedBox(width: 2),
                    const Text('В плейлисте', style: TextStyle(fontSize: 11, color: AppColors.lucid)),
                  ],
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.hasAudio) ...[
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                    color: isPlaying ? typeColor : AppColors.lucid,
                  ),
                  onPressed: isPlaying ? onStopPlay : onPlay,
                  tooltip: isPlaying ? 'Стоп' : 'Прослушать',
                ),
                IconButton(
                  icon: Icon(
                    isInPlaylist ? Icons.playlist_add_check : Icons.playlist_add,
                    color: isInPlaylist ? AppColors.lucid : AppColors.textTertiary,
                    size: 22,
                  ),
                  onPressed: isInPlaylist ? onRemoveFromPlaylist : onAddToPlaylist,
                  tooltip: isInPlaylist ? 'Убрать из плейлиста' : 'В плейлист',
                ),
              ] else
                IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.dream),
                  onPressed: onRecord,
                  tooltip: 'Записать голос',
                ),
            ],
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

  const _AudioBadge({required this.item, required this.isPlaying, required this.typeColor});

  @override
  Widget build(BuildContext context) {
    final d = item.audioDuration!;
    final s = d.inSeconds;
    final label = s < 60 ? '$sс' : '${d.inMinutes}:${(s % 60).toString().padLeft(2, '0')}';
    final isOwn = item.audioSource is OwnRecording;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPlaying ? Icons.graphic_eq : (isOwn ? Icons.mic : Icons.auto_awesome),
          size: 11,
          color: isPlaying ? typeColor : AppColors.textTertiary,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            isPlaying ? 'Воспроизведение...' : (isOwn ? 'Запись · $label' : 'AI · $label'),
            style: TextStyle(fontSize: 11, color: isPlaying ? typeColor : AppColors.textTertiary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
