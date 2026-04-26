// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentType _$ContentTypeFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'affirmation':
      return AffirmationContent.fromJson(json);
    case 'lucidTrigger':
      return LucidTriggerContent.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ContentType',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ContentType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AffirmationCategory category) affirmation,
    required TResult Function(TriggerTechnique technique) lucidTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AffirmationCategory category)? affirmation,
    TResult? Function(TriggerTechnique technique)? lucidTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AffirmationCategory category)? affirmation,
    TResult Function(TriggerTechnique technique)? lucidTrigger,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AffirmationContent value) affirmation,
    required TResult Function(LucidTriggerContent value) lucidTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AffirmationContent value)? affirmation,
    TResult? Function(LucidTriggerContent value)? lucidTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AffirmationContent value)? affirmation,
    TResult Function(LucidTriggerContent value)? lucidTrigger,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentTypeCopyWith<$Res> {
  factory $ContentTypeCopyWith(
          ContentType value, $Res Function(ContentType) then) =
      _$ContentTypeCopyWithImpl<$Res, ContentType>;
}

/// @nodoc
class _$ContentTypeCopyWithImpl<$Res, $Val extends ContentType>
    implements $ContentTypeCopyWith<$Res> {
  _$ContentTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AffirmationContentImplCopyWith<$Res> {
  factory _$$AffirmationContentImplCopyWith(_$AffirmationContentImpl value,
          $Res Function(_$AffirmationContentImpl) then) =
      __$$AffirmationContentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AffirmationCategory category});
}

/// @nodoc
class __$$AffirmationContentImplCopyWithImpl<$Res>
    extends _$ContentTypeCopyWithImpl<$Res, _$AffirmationContentImpl>
    implements _$$AffirmationContentImplCopyWith<$Res> {
  __$$AffirmationContentImplCopyWithImpl(_$AffirmationContentImpl _value,
      $Res Function(_$AffirmationContentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
  }) {
    return _then(_$AffirmationContentImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AffirmationCategory,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AffirmationContentImpl implements AffirmationContent {
  const _$AffirmationContentImpl({required this.category, final String? $type})
      : $type = $type ?? 'affirmation';

  factory _$AffirmationContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AffirmationContentImplFromJson(json);

  @override
  final AffirmationCategory category;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContentType.affirmation(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AffirmationContentImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AffirmationContentImplCopyWith<_$AffirmationContentImpl> get copyWith =>
      __$$AffirmationContentImplCopyWithImpl<_$AffirmationContentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AffirmationCategory category) affirmation,
    required TResult Function(TriggerTechnique technique) lucidTrigger,
  }) {
    return affirmation(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AffirmationCategory category)? affirmation,
    TResult? Function(TriggerTechnique technique)? lucidTrigger,
  }) {
    return affirmation?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AffirmationCategory category)? affirmation,
    TResult Function(TriggerTechnique technique)? lucidTrigger,
    required TResult orElse(),
  }) {
    if (affirmation != null) {
      return affirmation(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AffirmationContent value) affirmation,
    required TResult Function(LucidTriggerContent value) lucidTrigger,
  }) {
    return affirmation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AffirmationContent value)? affirmation,
    TResult? Function(LucidTriggerContent value)? lucidTrigger,
  }) {
    return affirmation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AffirmationContent value)? affirmation,
    TResult Function(LucidTriggerContent value)? lucidTrigger,
    required TResult orElse(),
  }) {
    if (affirmation != null) {
      return affirmation(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AffirmationContentImplToJson(
      this,
    );
  }
}

abstract class AffirmationContent implements ContentType {
  const factory AffirmationContent(
      {required final AffirmationCategory category}) = _$AffirmationContentImpl;

  factory AffirmationContent.fromJson(Map<String, dynamic> json) =
      _$AffirmationContentImpl.fromJson;

  AffirmationCategory get category;
  @JsonKey(ignore: true)
  _$$AffirmationContentImplCopyWith<_$AffirmationContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LucidTriggerContentImplCopyWith<$Res> {
  factory _$$LucidTriggerContentImplCopyWith(_$LucidTriggerContentImpl value,
          $Res Function(_$LucidTriggerContentImpl) then) =
      __$$LucidTriggerContentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TriggerTechnique technique});
}

/// @nodoc
class __$$LucidTriggerContentImplCopyWithImpl<$Res>
    extends _$ContentTypeCopyWithImpl<$Res, _$LucidTriggerContentImpl>
    implements _$$LucidTriggerContentImplCopyWith<$Res> {
  __$$LucidTriggerContentImplCopyWithImpl(_$LucidTriggerContentImpl _value,
      $Res Function(_$LucidTriggerContentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? technique = null,
  }) {
    return _then(_$LucidTriggerContentImpl(
      technique: null == technique
          ? _value.technique
          : technique // ignore: cast_nullable_to_non_nullable
              as TriggerTechnique,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LucidTriggerContentImpl implements LucidTriggerContent {
  const _$LucidTriggerContentImpl(
      {required this.technique, final String? $type})
      : $type = $type ?? 'lucidTrigger';

  factory _$LucidTriggerContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$LucidTriggerContentImplFromJson(json);

  @override
  final TriggerTechnique technique;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContentType.lucidTrigger(technique: $technique)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LucidTriggerContentImpl &&
            (identical(other.technique, technique) ||
                other.technique == technique));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, technique);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LucidTriggerContentImplCopyWith<_$LucidTriggerContentImpl> get copyWith =>
      __$$LucidTriggerContentImplCopyWithImpl<_$LucidTriggerContentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AffirmationCategory category) affirmation,
    required TResult Function(TriggerTechnique technique) lucidTrigger,
  }) {
    return lucidTrigger(technique);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AffirmationCategory category)? affirmation,
    TResult? Function(TriggerTechnique technique)? lucidTrigger,
  }) {
    return lucidTrigger?.call(technique);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AffirmationCategory category)? affirmation,
    TResult Function(TriggerTechnique technique)? lucidTrigger,
    required TResult orElse(),
  }) {
    if (lucidTrigger != null) {
      return lucidTrigger(technique);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AffirmationContent value) affirmation,
    required TResult Function(LucidTriggerContent value) lucidTrigger,
  }) {
    return lucidTrigger(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AffirmationContent value)? affirmation,
    TResult? Function(LucidTriggerContent value)? lucidTrigger,
  }) {
    return lucidTrigger?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AffirmationContent value)? affirmation,
    TResult Function(LucidTriggerContent value)? lucidTrigger,
    required TResult orElse(),
  }) {
    if (lucidTrigger != null) {
      return lucidTrigger(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LucidTriggerContentImplToJson(
      this,
    );
  }
}

abstract class LucidTriggerContent implements ContentType {
  const factory LucidTriggerContent(
      {required final TriggerTechnique technique}) = _$LucidTriggerContentImpl;

  factory LucidTriggerContent.fromJson(Map<String, dynamic> json) =
      _$LucidTriggerContentImpl.fromJson;

  TriggerTechnique get technique;
  @JsonKey(ignore: true)
  _$$LucidTriggerContentImplCopyWith<_$LucidTriggerContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
