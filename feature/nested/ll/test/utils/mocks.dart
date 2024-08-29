import 'package:ll/src/configurator/configurator.dart';
import 'package:ll/src/navigation/navigation.dart';
import 'package:mocktail/mocktail.dart';

class MockLegoListConfigurator extends Mock implements LegoListConfigurator {}

LegoListConfigurator createLegoListConfigurator(bool isGrid) {
  final mock = MockLegoListConfigurator();
  when(() => mock.gridRepresentation).thenReturn(isGrid);
  return mock;
}

class MockLegoListNavigation extends Mock implements LegoListNavigation {}

LegoListNavigation createLegoListNavigation() => MockLegoListNavigation();
