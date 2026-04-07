import 'package:equatable/equatable.dart';
import '../../../domain/models/content_item_model.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<ContentItemModel> items;

  const ContentLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ContentError extends ContentState {
  final String message;

  const ContentError(this.message);

  @override
  List<Object?> get props => [message];
}
