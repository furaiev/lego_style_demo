import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ll/ll.dart';
import 'package:ll/src/domain/model/lego_set.dart';
import 'package:ll/src/domain/repository/lego_repository.dart';
import 'package:ll/src/widget/bloc/ll_state.dart';

class LegoListCubit extends Cubit<LegoListState> {
  LegoListCubit(
    LegoRepository repository,
    LegoListConfigurator configurator,
    this._navigation,
  ) : super(
          LegoListState(
            legoSets: repository.getLegoSets(),
            grid: configurator.gridRepresentation,
          ),
        );

  final LegoListNavigation _navigation;

  void onLegoSetSelected(LegoSet legoSet) {
    _navigation.openUniverse(legoSet.id);
  }
}
