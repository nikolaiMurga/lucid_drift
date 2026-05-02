import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/content_item.dart';

class PlaylistEntryTile extends StatelessWidget {
  final ContentItem item;
  final int index;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onRemove;

  const PlaylistEntryTile({
    super.key,
    required this.item,
    required this.index,
    required this.isPlaying,
    required this.onPlay,
    required this.onStop,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = item.isAffirmation ? AppColors.affirmation : AppColors.lucid;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isPlaying ? typeColor.withValues(alpha: 0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPlaying ? typeColor.withValues(alpha: 0.4) : AppColors.border,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 4, right: 8, top: 2, bottom: 2),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.drag_handle, color: AppColors.textTertiary, size: 20),
            ),
            // Type stripe
            Container(
              width: 3,
              height: 36,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            // Index
            Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Icon(
              item.isAffirmation ? Icons.self_improvement : Icons.visibility_outlined,
              size: 11,
              color: typeColor,
            ),
            const SizedBox(width: 4),
            Text(
              item.isAffirmation ? 'Аффирмация' : 'Триггер',
              style: TextStyle(fontSize: 11, color: typeColor),
            ),
            if (item.audioDuration != null) ...[
              const SizedBox(width: 6),
              Text(
                '· ${item.audioDuration!.inSeconds}с',
                style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
            ],
            if (isPlaying) ...[
              const SizedBox(width: 6),
              const Icon(Icons.graphic_eq, size: 11, color: AppColors.lucid),
              const SizedBox(width: 3),
              const Text(
                'Воспроизведение',
                style: TextStyle(fontSize: 11, color: AppColors.lucid),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.hasAudio)
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                  color: isPlaying ? AppColors.lucid : AppColors.textSecondary,
                  size: 22,
                ),
                onPressed: isPlaying ? onStop : onPlay,
                tooltip: isPlaying ? 'Стоп' : 'Прослушать',
              ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
              onPressed: onRemove,
              tooltip: 'Убрать из плейлиста',
            ),
          ],
        ),
      ),
    );
  }
}
