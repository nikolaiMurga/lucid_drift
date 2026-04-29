import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/night_playlist.dart';
import '../cubit/playlist_cubit.dart';
import '../cubit/playlist_state.dart';
import '../widgets/playlist_entry_tile.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistCubit(
        watch: sl(),
        remove: sl(),
        reorder: sl(),
        updateSettings: sl(),
        contentRepo: sl(),
      )..init(),
      child: const _PlaylistView(),
    );
  }
}

class _PlaylistView extends StatelessWidget {
  const _PlaylistView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ночной плейлист'),
            actions: [
              if (state is PlaylistLoaded && state.resolvedItems.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => _showSettings(context, state.playlist),
                  tooltip: 'Настройки',
                ),
            ],
          ),
          body: switch (state) {
            PlaylistLoading() => const Center(child: CircularProgressIndicator()),
            PlaylistError(:final message) => Center(
                child: Text(message, style: const TextStyle(color: Colors.red)),
              ),
            PlaylistLoaded() => _PlaylistBody(state: state),
          },
        );
      },
    );
  }

  void _showSettings(BuildContext context, NightPlaylist playlist) {
    final cubit = context.read<PlaylistCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceHigh,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SettingsSheet(playlist: playlist, cubit: cubit),
    );
  }
}

// ─── Playlist body ────────────────────────────────────────────────────────────

class _PlaylistBody extends StatelessWidget {
  final PlaylistLoaded state;
  const _PlaylistBody({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.resolvedItems.isEmpty) {
      return const _EmptyPlaylist();
    }

    return Column(
      children: [
        _SummaryBar(
          playlist: state.playlist,
          itemCount: state.resolvedItems.length,
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: state.resolvedItems.length,
            onReorder: (oldIndex, newIndex) =>
                context.read<PlaylistCubit>().reorder(oldIndex, newIndex),
            proxyDecorator: (child, index, animation) =>
                Material(color: Colors.transparent, child: child),
            itemBuilder: (context, i) {
              final item = state.resolvedItems[i];
              return PlaylistEntryTile(
                key: ValueKey(item.id),
                item: item,
                index: i,
                isPlaying: state.playingItemId == item.id,
                onPlay: () => context.read<PlaylistCubit>().playItem(item.id),
                onStop: () => context.read<PlaylistCubit>().stopPlayback(),
                onRemove: () => _confirmRemove(context, item.id, item.title),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmRemove(BuildContext context, String id, String title) {
    final cubit = context.read<PlaylistCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        title: const Text('Убрать из плейлиста?'),
        content: Text(
          '«$title» будет убран из плейлиста.\nЗапись останется в библиотеке.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.removeItem(id);
            },
            child: const Text('Убрать', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─── Summary bar ──────────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  final NightPlaylist playlist;
  final int itemCount;
  const _SummaryBar({required this.playlist, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final modeLabel = switch (playlist.playbackMode) {
      PlaybackMode.affirmationsFirst => 'Аффирмации → Триггеры',
      PlaybackMode.triggersFirst => 'Триггеры → Аффирмации',
      PlaybackMode.interleaved => 'Вперемешку',
    };

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.queue_music, size: 14, color: AppColors.dream),
          const SizedBox(width: 4),
          Text('$itemCount дорожек',
              style: const TextStyle(fontSize: 12, color: AppColors.dream)),
          const SizedBox(width: 12),
          const Icon(Icons.swap_vert, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(modeLabel,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const Spacer(),
          if (playlist.loop)
            const Icon(Icons.repeat, size: 16, color: AppColors.teal),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyPlaylist extends StatelessWidget {
  const _EmptyPlaylist();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.queue_music_outlined,
                size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('Плейлист пуст',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Перейди во вкладку «Контент» и нажми\n«+ в плейлист» на нужных дорожках',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Settings sheet ───────────────────────────────────────────────────────────

class _SettingsSheet extends StatefulWidget {
  final NightPlaylist playlist;
  final PlaylistCubit cubit;
  const _SettingsSheet({required this.playlist, required this.cubit});

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late double _affVol;
  late double _trigVol;
  late int _pause;
  late bool _loop;
  late PlaybackMode _mode;

  @override
  void initState() {
    super.initState();
    _affVol = widget.playlist.affirmationVolume;
    _trigVol = widget.playlist.triggerVolume;
    _pause = widget.playlist.pauseBetweenSeconds;
    _loop = widget.playlist.loop;
    _mode = widget.playlist.playbackMode;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Настройки', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),

          _sectionLabel(context, 'Порядок воспроизведения'),
          const SizedBox(height: 8),
          _ModeSelector(value: _mode, onChanged: (m) => setState(() => _mode = m)),
          const SizedBox(height: 16),

          _sectionLabel(context, 'Громкость аффирмаций'),
          _VolumeRow(
            color: AppColors.affirmation,
            value: _affVol,
            onChanged: (v) => setState(() => _affVol = v),
          ),
          const SizedBox(height: 8),

          _sectionLabel(context, 'Громкость триггеров'),
          _VolumeRow(
            color: AppColors.lucid,
            value: _trigVol,
            onChanged: (v) => setState(() => _trigVol = v),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              _sectionLabel(context, 'Пауза между дорожками'),
              const Spacer(),
              Text('$_pauseс',
                  style: const TextStyle(
                      color: AppColors.dream, fontWeight: FontWeight.w500)),
            ],
          ),
          Slider(
            value: _pause.toDouble(),
            min: 0, max: 60, divisions: 12,
            activeColor: AppColors.dream,
            onChanged: (v) => setState(() => _pause = v.round()),
          ),
          const SizedBox(height: 4),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Зациклить плейлист'),
            subtitle: const Text('Повторять до будильника'),
            value: _loop,
            activeThumbColor: AppColors.teal,
            onChanged: (v) => setState(() => _loop = v),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dream,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _save,
              child: const Text('Сохранить',
                  style: TextStyle(color: AppColors.textPrimary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: AppColors.textTertiary, letterSpacing: 0.5),
      );

  Future<void> _save() async {
    await widget.cubit.updateAffirmationVolume(_affVol);
    await widget.cubit.updateTriggerVolume(_trigVol);
    await widget.cubit.updatePause(_pause);
    if (_loop != widget.playlist.loop) await widget.cubit.toggleLoop();
    if (_mode != widget.playlist.playbackMode) {
      await widget.cubit.updatePlaybackMode(_mode);
    }
    if (mounted) Navigator.of(context).pop();
  }
}

class _ModeSelector extends StatelessWidget {
  final PlaybackMode value;
  final ValueChanged<PlaybackMode> onChanged;
  const _ModeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PlaybackMode.values.map((mode) {
        final label = switch (mode) {
          PlaybackMode.affirmationsFirst => 'Аффирмации → Триггеры',
          PlaybackMode.triggersFirst => 'Триггеры → Аффирмации',
          PlaybackMode.interleaved => 'Вперемешку',
        };
        return RadioListTile<PlaybackMode>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: mode,
          groupValue: value,
          activeColor: AppColors.dream,
          title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          onChanged: (m) => m != null ? onChanged(m) : null,
        );
      }).toList(),
    );
  }
}

class _VolumeRow extends StatelessWidget {
  final Color color;
  final double value;
  final ValueChanged<double> onChanged;
  const _VolumeRow({required this.color, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value,
            min: 0.1, max: 1.0, divisions: 9,
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${(value * 100).round()}%',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
