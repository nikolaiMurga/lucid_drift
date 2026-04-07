import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/content_use_case.dart';
import '../../../domain/models/content_item_model.dart';
import 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  final ContentUseCase _useCase;

  ContentCubit(this._useCase) : super(ContentInitial());

  Future<void> loadContent() async {
    emit(ContentLoading());
    try {
      final items = await _useCase.getContentItems();
      emit(ContentLoaded(items));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> addRecording(String text, ContentType type, String filePath) async {
    try {
      await _useCase.addVoiceRecording(text, type, filePath);
      await loadContent();
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> generateAiVoice(String text, ContentType type, String apiKey) async {
    emit(ContentLoading());
    try {
      await _useCase.generateAiVoice(text, type, apiKey);
      await loadContent();
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _useCase.deleteContentItem(id);
      await loadContent();
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }
}
