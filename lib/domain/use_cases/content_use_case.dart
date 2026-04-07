import 'package:uuid/uuid.dart';
import '../../data/repos/content_repo.dart';
import '../models/content_item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ContentUseCase {
  final ContentRepo _repo;
  final _uuid = const Uuid();

  ContentUseCase(this._repo);

  Future<List<ContentItemModel>> getContentItems() async {
    return await _repo.getContentItems();
  }

  Future<void> addVoiceRecording(String text, ContentType type, String filePath) async {
    final item = ContentItemModel(
      id: _uuid.v4(),
      text: text,
      type: type,
      sourceType: AudioSourceType.ownRecording,
      audioPath: filePath,
      createdAt: DateTime.now(),
    );
    await _repo.saveContentItem(item);
  }

  Future<void> generateAiVoice(String text, ContentType type, String apiKey) async {
    // OpenAI TTS implementation for prototype
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'ai_${_uuid.v4()}.mp3';
    final filePath = '${directory.path}/$fileName';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/audio/speech'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: '{"model": "tts-1", "input": "$text", "voice": "nova"}',
    );

    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      final item = ContentItemModel(
        id: _uuid.v4(),
        text: text,
        type: type,
        sourceType: AudioSourceType.aiGenerated,
        audioPath: filePath,
        createdAt: DateTime.now(),
      );
      await _repo.saveContentItem(item);
    } else {
      throw Exception('Failed to generate AI voice: ${response.body}');
    }
  }

  Future<void> deleteContentItem(String id) async {
    final items = await _repo.getContentItems();
    final item = items.firstWhere((e) => e.id == id);
    final file = File(item.audioPath);
    if (await file.exists()) {
      await file.delete();
    }
    await _repo.deleteContentItem(id);
  }
}
