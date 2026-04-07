import 'package:equatable/equatable.dart';
import '../../../domain/models/content_item_model.dart';

abstract class NightSessionState extends Equatable {
  const NightSessionState();

  @override
  List<Object?> get props => [];
}

class NightSessionInitial extends NightSessionState {}

class NightSessionActive extends NightSessionState {
  final List<ContentItemModel> playlist;
  final bool isPlaying;
  final DateTime nextRemWindow;

  const NightSessionActive({
    required this.playlist,
    required this.isPlaying,
    required this.nextRemWindow,
  });

  @override
  List<Object?> get props => [playlist, isPlaying, nextRemWindow];
}
