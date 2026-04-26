import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class PrepareRecordingPathUseCase {
  const PrepareRecordingPathUseCase();

  Future<String> call() async {
    final dir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${dir.path}/audio');
    if (!await audioDir.exists()) await audioDir.create(recursive: true);
    final id = const Uuid().v4();
    return '${audioDir.path}/$id.m4a';
  }
}

class DeleteAudioFileUseCase {
  const DeleteAudioFileUseCase();

  Future<void> call(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
