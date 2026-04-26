import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/content_item_model.dart';
import '../cubit/content_cubit.dart';
import '../cubit/content_state.dart';
import 'package:record/record.dart'; // В версии 4.4.4 здесь лежит класс Record
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // ИСПОРАВЛЕНО: заменено AudioRecorder() на Record()
  final _recorder = Record();
  bool _isRecording = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _recorder.dispose(); // Метод dispose совпадает
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _recordingPath = '${directory.path}/temp_record_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // ИСПРАВЛЕНО: В версии 4.4.4 нет класса RecordConfig.
        // Параметры передаются напрямую в метод start()
        await _recorder.start(
          path: _recordingPath, // Путь передается сюда
          encoder: AudioEncoder.aacLc, // Аналог настроек из Config
          bitRate: 128000,
          samplingRate: 44100,
        );

        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording(ContentType type) async {
    // Метод stop() в 4.4.4 возвращает путь String?
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      final text = await _showTextPrompt();
      if (text != null && text.isNotEmpty) {
        if (mounted) {
          context.read<ContentCubit>().addRecording(text, type, path);
        }
      } else {
        await File(path).delete();
      }
    }
  }

  Future<String?> _showTextPrompt() async {
    String text = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Track Text'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => text = value,
          decoration: const InputDecoration(hintText: 'Enter affirmation/trigger text'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, text), child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _generateAiVoice(ContentType type) async {
    final text = await _showTextPrompt();
    if (text != null && text.isNotEmpty) {
      if (mounted) {
        context.read<ContentCubit>().generateAiVoice(text, type, 'YOUR_OPENAI_API_KEY');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LucidDrift Content'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Affirmations'),
            Tab(text: 'Lucid Triggers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ContentList(type: ContentType.affirmation),
          _ContentList(type: ContentType.trigger),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FloatingActionButton(
          //   heroTag: 'ai',
          //   onPressed: () => _generateAiVoice(_tabController.index == 0 ? ContentType.affirmation : ContentType.trigger),
          //   child: const Icon(Icons.auto_awesome),
          // ),
          // const Padding(padding: EdgeInsets.only(top: 16)),
          FloatingActionButton(
            heroTag: 'record',
            onPressed: _isRecording
                ? () => _stopRecording(_tabController.index == 0 ? ContentType.affirmation : ContentType.trigger)
                : _startRecording,
            backgroundColor: _isRecording ? Colors.red : null,
            child: Icon(_isRecording ? Icons.stop : Icons.mic),
          ),
        ],
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  final ContentType type;
  const _ContentList({required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        if (state is ContentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContentLoaded) {
          final items = state.items.where((i) => i.type == type).toList();
          if (items.isEmpty) {
            return const Center(child: Text('No tracks yet. Record your first one!'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.text),
                subtitle: Text(item.sourceType == AudioSourceType.aiGenerated ? 'AI Generated' : 'Voice Recorded'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => context.read<ContentCubit>().deleteItem(item.id),
                ),
              );
            },
          );
        } else if (state is ContentError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Ready.'));
      },
    );
  }
}