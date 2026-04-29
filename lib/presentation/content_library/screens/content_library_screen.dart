import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/content_type.dart';
import '../../../domain/usecases/content/content_usecases.dart';
import '../cubit/content_library_cubit.dart';
import '../cubit/content_library_state.dart';
import '../widgets/content_item_tile.dart';

class ContentLibraryScreen extends StatelessWidget {
  const ContentLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContentLibraryCubit(
        getItems: sl(),
        deleteItem: sl(),
        addToPlaylist: sl(),
        removeFromPlaylist: sl(),
        watchPlaylist: sl(),
      )..init(),
      child: const _ContentLibraryView(),
    );
  }
}

class _ContentLibraryView extends StatelessWidget {
  const _ContentLibraryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentLibraryCubit, ContentLibraryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Мой контент'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _TabBar(activeTab: state.activeTab),
            ),
          ),
          body: switch (state) {
            ContentLibraryLoading() =>
              const Center(child: CircularProgressIndicator()),
            ContentLibraryError(:final message) =>
              Center(child: Text(message, style: const TextStyle(color: Colors.red))),
            ContentLibraryLoaded(:final activeList) => activeList.isEmpty
                ? _EmptyState(tab: state.activeTab)
                : _ItemList(items: activeList, state: state),
          },
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.dream,
            onPressed: () => _showCreateSheet(context, state.activeTab),
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
          ),
        );
      },
    );
  }

  void _showCreateSheet(BuildContext context, ContentTab activeTab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CreateItemSheet(
        defaultTab: activeTab,
        saveItem: sl<SaveContentItemUseCase>(),
        onCreated: (item) {
          context.push(AppRoutes.recorder, extra: {
            'contentItemId': item.id,
            'type': item.type,
            'text': item.text,
          });
        },
      ),
    );
  }
}

// ─── Tab bar ──────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final ContentTab activeTab;
  const _TabBar({required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: ContentTab.values.map((tab) {
          final isActive = tab == activeTab;
          final color =
              tab == ContentTab.affirmations ? AppColors.affirmation : AppColors.lucid;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<ContentLibraryCubit>().switchTab(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
                  border: Border.all(color: isActive ? color : AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tab.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? color : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Item list ────────────────────────────────────────────────────────────────

class _ItemList extends StatelessWidget {
  final List<ContentItem> items;
  final ContentLibraryLoaded state;
  const _ItemList({required this.items, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final cubit = context.read<ContentLibraryCubit>();
        return ContentItemTile(
          item: item,
          isPlaying: state.playingItemId == item.id,
          isInPlaylist: state.isInPlaylist(item.id),
          onPlay: () => cubit.playItem(item.id),
          onStopPlay: () => cubit.stopPlayback(),
          onRecord: () => context.push(AppRoutes.recorder, extra: {
            'contentItemId': item.id,
            'type': item.type,
            'text': item.text,
          }),
          onDelete: () => cubit.delete(item.id),
          onAddToPlaylist: () => cubit.addToPlaylist(item.id),
          onRemoveFromPlaylist: () => cubit.removeFromPlaylist(item.id),
        );
      },
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final ContentTab tab;
  const _EmptyState({required this.tab});

  @override
  Widget build(BuildContext context) {
    final isAffirmation = tab == ContentTab.affirmations;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAffirmation ? Icons.self_improvement : Icons.visibility_outlined,
              size: 56,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              isAffirmation ? 'Нет аффирмаций' : 'Нет триггеров осознанности',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isAffirmation
                  ? 'Добавь короткие фразы в настоящем времени\n«Я спокоен и уверен в себе»'
                  : 'Добавь MILD-фразы и реалити-чеки\n«Это сон — я осознаю»',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Create sheet ─────────────────────────────────────────────────────────────

class _CreateItemSheet extends StatefulWidget {
  final ContentTab defaultTab;
  final SaveContentItemUseCase saveItem;
  final void Function(ContentItem item) onCreated;
  const _CreateItemSheet({
    required this.defaultTab,
    required this.saveItem,
    required this.onCreated,
  });

  @override
  State<_CreateItemSheet> createState() => _CreateItemSheetState();
}

class _CreateItemSheetState extends State<_CreateItemSheet> {
  late ContentTab _selectedTab;
  final _titleCtrl = TextEditingController();
  final _textCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.defaultTab;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  ContentType get _contentType => switch (_selectedTab) {
        ContentTab.affirmations =>
          const ContentType.affirmation(category: AffirmationCategory.custom),
        ContentTab.lucidTriggers =>
          const ContentType.lucidTrigger(technique: TriggerTechnique.mild),
      };

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final text = _textCtrl.text.trim();
    if (title.isEmpty || text.isEmpty) {
      setState(() => _error = 'Заполни название и текст фразы');
      return;
    }
    setState(() { _saving = true; _error = null; });

    final now = DateTime.now();
    final item = ContentItem(
      id: const Uuid().v4(),
      title: title,
      text: text,
      type: _contentType,
      createdAt: now,
      updatedAt: now,
    );
    await widget.saveItem(item);
    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onCreated(item);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Новый контент', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
            children: ContentTab.values.map((tab) {
              final isSelected = _selectedTab == tab;
              final color = tab == ContentTab.affirmations
                  ? AppColors.affirmation
                  : AppColors.lucid;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = tab),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
                      border: Border.all(color: isSelected ? color : AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tab.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? color : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Название'),
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() => _error = null),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _textCtrl,
            decoration: InputDecoration(
              labelText: 'Текст фразы',
              hintText: _selectedTab == ContentTab.affirmations
                  ? 'Я спокоен и уверен в себе...'
                  : 'Это сон — я осознаю, что сплю...',
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            onChanged: (_) => setState(() => _error = null),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dream,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                    )
                  : const Icon(Icons.mic, color: AppColors.textPrimary),
              label: Text(
                _saving ? 'Сохранение...' : 'Создать и записать голос',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
