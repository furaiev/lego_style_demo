// hp_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter/src/domain/model/character.dart';
import 'package:harry_potter/src/domain/repository/hp_repository.dart';
// ignore: unused_import
import 'package:harry_potter/src/flow/harry_potter_flow.dart';

void main() {
  group('HPRepository', () {
    final repository =  HPRepository();

    test('mock!!', () {
      expect('Lord Voldemort', 'Lord Voldemort');
    });

    test('getCharacters returns a list of characters', () {
      final characters = repository.getCharacters();

      expect(characters, isA<List<Character>>());
      expect(characters.length, 5);

      expect(characters[0].name, 'Harry Potter');
      expect(characters[1].name, 'Ron Weasley');
      expect(characters[2].name, 'Hermione Granger');
      expect(characters[3].name, 'Albus Dumbledore');
      // expect(characters[4].name, 'Lord Voldemort');
    });

    test('getCharacter returns correct character information', () {
      const characterName = 'Harry Potter';
      final character = repository.getCharacter(characterName);

      expect(character, isA<Character>());
      expect(character.name, characterName);
      expect(character.biography, '$characterName is a character in Harry Potter!');
    });
  });
}
