import 'package:get_it/get_it.dart';
import 'package:hp/src/di/di_initializer.config.dart';
import 'package:injectable/injectable.dart';

@injectableInit
void initialize() {
  GetIt.I.pushNewScope();
  $initGetIt(GetIt.I);
}

void deinitialize() {
  GetIt.I.popScope();
}
