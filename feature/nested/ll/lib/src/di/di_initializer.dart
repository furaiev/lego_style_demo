import 'package:get_it/get_it.dart';
import 'package:ll/src/domain/repository/lego_repository.dart';
import 'package:ll/src/widget/bloc/ll_cubit.dart';

const _initializedMark = 'll_initialized';

void initialize() {
  final isInitialized =
      GetIt.I.isRegistered<bool>(instanceName: _initializedMark);
  if (!isInitialized) {
    GetIt.I.registerSingleton<bool>(true, instanceName: _initializedMark);
    GetIt.I.registerFactory(() => LegoRepository());
    GetIt.I
        .registerFactory(() => LegoListCubit(GetIt.I(), GetIt.I(), GetIt.I()));
  }
}
