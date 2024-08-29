import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hp/src/domain/model/character.dart';

part 'hp_state.freezed.dart';

@freezed
class HarryPotterState with _$HarryPotterState {
  const factory HarryPotterState({
    Character? selectedCharacter,
  }) = _HarryPotterState;
}
