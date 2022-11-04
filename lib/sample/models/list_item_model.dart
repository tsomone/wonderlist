import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_item_model.freezed.dart';
part 'list_item_model.g.dart';

@freezed
class ListItemModel with _$ListItemModel {
  const factory ListItemModel({
    required int id,
    required String name,
    int? targetId,
    @Default([]) List<int> childrenIds,
    @Default(false) bool isCollapsed,
    @Default(false) bool isPagingIndicator,
    @Default(false) bool isLoading,
  }) = _ListItemModel;

  factory ListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ListItemModelFromJson(json);
}
