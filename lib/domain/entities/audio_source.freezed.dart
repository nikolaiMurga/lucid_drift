// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AudioSource _$AudioSourceFromJson(Map<String, dynamic> json) {
  return OwnRecording.fromJson(json);
}

/// @nodoc
mixin _$AudioSource {
  String get localPath => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String localPath) ownRecording,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String localPath)? ownRecording,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String localPath)? ownRecording,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OwnRecording value) ownRecording,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OwnRecording value)? ownRecording,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OwnRecording value)? ownRecording,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AudioSourceCopyWith<AudioSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioSourceCopyWith<$Res> {
  factory $AudioSourceCopyWith(
          AudioSource value, $Res Function(AudioSource) then) =
      _$AudioSourceCopyWithImpl<$Res, AudioSource>;
  @useResult
  $Res call({String localPath});
}

/// @nodoc
class _$AudioSourceCopyWithImpl<$Res, $Val extends AudioSource>
    implements $AudioSourceCopyWith<$Res> {
  _$AudioSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localPath = null,
  }) {
    return _then(_value.copyWith(
      localPath: null == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OwnRecordingImplCopyWith<$Res>
    implements $AudioSourceCopyWith<$Res> {
  factory _$$OwnRecordingImplCopyWith(
          _$OwnRecordingImpl value, $Res Function(_$OwnRecordingImpl) then) =
      __$$OwnRecordingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String localPath});
}

/// @nodoc
class __$$OwnRecordingImplCopyWithImpl<$Res>
    extends _$AudioSourceCopyWithImpl<$Res, _$OwnRecordingImpl>
    implements _$$OwnRecordingImplCopyWith<$Res> {
  __$$OwnRecordingImplCopyWithImpl(
      _$OwnRecordingImpl _value, $Res Function(_$OwnRecordingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localPath = null,
  }) {
    return _then(_$OwnRecordingImpl(
      localPath: null == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OwnRecordingImpl implements OwnRecording {
  const _$OwnRecordingImpl({required this.localPath});

  factory _$OwnRecordingImpl.fromJson(Map<String, dynamic> json) =>
      _$$OwnRecordingImplFromJson(json);

  @override
  final String localPath;

  @override
  String toString() {
    return 'AudioSource.ownRecording(localPath: $localPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnRecordingImpl &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, localPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnRecordingImplCopyWith<_$OwnRecordingImpl> get copyWith =>
      __$$OwnRecordingImplCopyWithImpl<_$OwnRecordingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String localPath) ownRecording,
  }) {
    return ownRecording(localPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String localPath)? ownRecording,
  }) {
    return ownRecording?.call(localPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String localPath)? ownRecording,
    required TResult orElse(),
  }) {
    if (ownRecording != null) {
      return ownRecording(localPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OwnRecording value) ownRecording,
  }) {
    return ownRecording(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OwnRecording value)? ownRecording,
  }) {
    return ownRecording?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OwnRecording value)? ownRecording,
    required TResult orElse(),
  }) {
    if (ownRecording != null) {
      return ownRecording(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnRecordingImplToJson(
      this,
    );
  }
}

abstract class OwnRecording implements AudioSource {
  const factory OwnRecording({required final String localPath}) =
      _$OwnRecordingImpl;

  factory OwnRecording.fromJson(Map<String, dynamic> json) =
      _$OwnRecordingImpl.fromJson;

  @override
  String get localPath;
  @override
  @JsonKey(ignore: true)
  _$$OwnRecordingImplCopyWith<_$OwnRecordingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
