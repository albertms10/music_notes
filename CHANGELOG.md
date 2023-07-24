## 0.11.1

- 📌 chore(pubspec): downgrade `test` to 1.24.1 to keep Flutter compatibility in [#231](https://github.com/albertms10/music_notes/pull/231)

**Full Changelog**: [`v0.11.0...v0.11.1`](https://github.com/albertms10/music_notes/compare/v0.11.0...v0.11.1)

## 0.11.0

- 📄 docs(README): update license badge in [#207](https://github.com/albertms10/music_notes/pull/207)
- 📖 docs(README): fix typo in C♯ example in [#208](https://github.com/albertms10/music_notes/pull/208)
- ♻️ refactor(positioned_note)!: make `octave` argument required in [#209](https://github.com/albertms10/music_notes/pull/209)
- 📖 docs(note): update missing `inOctave` examples in [#210](https://github.com/albertms10/music_notes/pull/210)
- ♻️ refactor: use `incrementBy` method in [#211](https://github.com/albertms10/music_notes/pull/211)
- ♻️ refactor(interval): remove redundant `Scalable<T>` types in [#212](https://github.com/albertms10/music_notes/pull/212)
- 📖 docs(scale): fix wrong `functionChord` examples in [#213](https://github.com/albertms10/music_notes/pull/213)
- ✨ feat(note): add `respellByBaseNoteDistance` method in [#214](https://github.com/albertms10/music_notes/pull/214)
- ✨ feat(enharmonic): allow providing `distance` to `spellings` in [#215](https://github.com/albertms10/music_notes/pull/215)
- ♻️ refactor(accidental): extract parsable symbols from `parse` in [#216](https://github.com/albertms10/music_notes/pull/216)
- chore(deps): bump coverallsapp/github-action from 2.2.0 to 2.2.1 in [#217](https://github.com/albertms10/music_notes/pull/217)
- ✨ feat(enharmonic): remove semitones from `toString` output in [#218](https://github.com/albertms10/music_notes/pull/218)
- ✨ feat(enharmonic): use pipe `|` in `toString` output in [#219](https://github.com/albertms10/music_notes/pull/219)
- 💥 refactor(note)!: rewrite semitones starting from 0 instead of 1 in [#220](https://github.com/albertms10/music_notes/pull/220)
- ⚡ perf(positioned_note): extract `parse` expressions to static finals in [#221](https://github.com/albertms10/music_notes/pull/221)
- 💥 feat(interval)!: move `isDissonant` getter from `IntervalSizeExtension` in [#222](https://github.com/albertms10/music_notes/pull/222)
- ♻️ refactor(interval)!: move `inverted` logic from `IntervalSizeExtension` in [#223](https://github.com/albertms10/music_notes/pull/223)
- ♻️ refactor(interval): move `simplified` from `IntervalSizeExtension` in [#224](https://github.com/albertms10/music_notes/pull/224)
- ♻️ refactor(interval): move `isCompound` from `IntervalSizeExtension` in [#225](https://github.com/albertms10/music_notes/pull/225)
- 📖 docs(interval_size_extension): improve `semitones` and `isPerfect` comments in [#226](https://github.com/albertms10/music_notes/pull/226)
- 📌 chore(pubspec): downgrade `collection` to 1.17.1 to keep Flutter compatibility in [#228](https://github.com/albertms10/music_notes/pull/228)
- ➖ chore(pubspec): remove `dart_code_metrics` dependency in [#229](https://github.com/albertms10/music_notes/pull/229)
- 💥 refactor(interval)!: rewrite `IntervalSizeExtension` methods as private in [#227](https://github.com/albertms10/music_notes/pull/227)

**Full Changelog**: [`v0.10.1...v0.11.0`](https://github.com/albertms10/music_notes/compare/v0.10.1...v0.11.0)

## 0.10.1

- ✨ feat(interval): take `distance` sign into account in `circleFrom` in [#199](https://github.com/albertms10/music_notes/pull/199)
- ✨ feat(enharmonic_note): add pitch-class multiplication operator in [#200](https://github.com/albertms10/music_notes/pull/200)
- ♻️ refactor(base_note): rename `fromSemitones` static method in [#201](https://github.com/albertms10/music_notes/pull/201)
- 🔥 refactor(enharmonic_note)!: remove `shortestFifthsDistance` methods in [#202](https://github.com/albertms10/music_notes/pull/202)
- ✨ feat(tuning_system): add class and test cases in [#203](https://github.com/albertms10/music_notes/pull/203)
- 📖 docs(README): write main library documentation in [#204](https://github.com/albertms10/music_notes/pull/204)
- ⬆️ chore(pubspec): pin dependencies versions in [#205](https://github.com/albertms10/music_notes/pull/205)
- 📖 docs(README): remove publisher badge in [#206](https://github.com/albertms10/music_notes/pull/206)

**Full Changelog**: [`v0.10.0...v0.10.1`](https://github.com/albertms10/music_notes/compare/v0.10.0...v0.10.1)

## 0.10.0

**Note:** the published versioned erroneously contained some changes from 0.10.1.

- ♻️ refactor(interval): rename shorter static constants in [#177](https://github.com/albertms10/music_notes/pull/177)
- ✨ feat(string_extension): add `isUpperCase` and `isLowerCase` getters in [#179](https://github.com/albertms10/music_notes/pull/179)
- ✨ feat: add `parse` factory constructors to Note and Interval classes in [#180](https://github.com/albertms10/music_notes/pull/180)
- 🔧 chore(dependabot): add configuration file in [#181](https://github.com/albertms10/music_notes/pull/181)
- ⬆️ chore(deps): bump actions/checkout from 3.5.0 to 3.5.3 in [#182](https://github.com/albertms10/music_notes/pull/182)
- ⬆️ chore(deps): bump coverallsapp/github-action from 2.0.0 to 2.2.0 in [#183](https://github.com/albertms10/music_notes/pull/183)
- 💥 feat(key_signature)!: rewrite based on a list of Notes in [#184](https://github.com/albertms10/music_notes/pull/184)
- ♻️ refactor(key_signature): declare static `empty` constant in [#185](https://github.com/albertms10/music_notes/pull/185)
- ♻️ refactor(key_signature): simplify tonality methods in [#186](https://github.com/albertms10/music_notes/pull/186)
- 🐛 fix(note): return correct distance for extreme Note spellings in [#187](https://github.com/albertms10/music_notes/pull/187)
- ⚡ perf(interval): rewrite `distanceBetween` method avoiding unnecessary iterations in [#188](https://github.com/albertms10/music_notes/pull/188)
- ♻️ refactor(base_note): rewrite `parse` method using `byName` in [#189](https://github.com/albertms10/music_notes/pull/189)
- ✨ feat(note): add respelling methods in [#190](https://github.com/albertms10/music_notes/pull/190)
- ✨ feat(note): add `respelledSimple` getter in [#191](https://github.com/albertms10/music_notes/pull/191)
- ✨ feat(int_extension): add `incrementBy` method in [#192](https://github.com/albertms10/music_notes/pull/192)
- ✨ feat(interval): add `circleFrom` and related methods on `Note` in [#193](https://github.com/albertms10/music_notes/pull/193)
- ✨ feat(interval): add `respellBySize` method in [#195](https://github.com/albertms10/music_notes/pull/195)
- ✨ feat(key_signature)!: rewrite `toString` method in [#196](https://github.com/albertms10/music_notes/pull/196)
- ♻️ refactor(analysis): enable ignored lints in [#197](https://github.com/albertms10/music_notes/pull/197)
- ✨ feat(interval): rewrite distance methods expecting `Scalable` arguments in [#198](https://github.com/albertms10/music_notes/pull/198)

**Full Changelog**: [`v0.9.0...v0.10.0`](https://github.com/albertms10/music_notes/compare/v0.9.0...v0.10.0)

## 0.9.0

- fix(scale): take descending items into account for `hashCode` in [#151](https://github.com/albertms10/music_notes/pull/151)
- test(note): add test cases for `sharp`, `flat`, `major`, `minor` getters in [#152](https://github.com/albertms10/music_notes/pull/152)
- test(enharmonic): move each `toString` test cases to implementation in [#153](https://github.com/albertms10/music_notes/pull/153)
- feat(harmony): add `Chord` and `ChordPattern` classes in [#154](https://github.com/albertms10/music_notes/pull/154)
- fix(positioned_note): use correct `hashCode` values in [#155](https://github.com/albertms10/music_notes/pull/155)
- fix(interval_size_extension): return correct `semitones` for large intervals in [#156](https://github.com/albertms10/music_notes/pull/156)
- fix(note): correctly handle compound intervals in `transposeBy` in [#157](https://github.com/albertms10/music_notes/pull/157)
- feat(chord): implement `Transposable` in [#158](https://github.com/albertms10/music_notes/pull/158)
- feat(chord_pattern): add `intervalSteps` factory constructor in [#159](https://github.com/albertms10/music_notes/pull/159)
- test(interval): add compound intervals test cases for `semitones` in [#160](https://github.com/albertms10/music_notes/pull/160)
- feat(interval): add `simplified` getter in [#161](https://github.com/albertms10/music_notes/pull/161)
- refactor: rename `from` → `on` in [#162](https://github.com/albertms10/music_notes/pull/162)
- feat(note): add Chord triad getters in [#163](https://github.com/albertms10/music_notes/pull/163)
- feat(scale): add `ScaleDegree` class and methods on `Scale` in [#164](https://github.com/albertms10/music_notes/pull/164)
- feat(chord_pattern): add `fromQuality` factory constructor in [#165](https://github.com/albertms10/music_notes/pull/165)
- feat(scale_degree): add `raised`, `lowered`, `major`, and `minor` getters in [#167](https://github.com/albertms10/music_notes/pull/167)
- feat(scale_pattern): take `ScaleDegree.quality` into account in `degreePattern` in [#166](https://github.com/albertms10/music_notes/pull/166)
- feat(scale_pattern): add `fromChordPattern` factory constructor in [#168](https://github.com/albertms10/music_notes/pull/168)
- feat(scale): add `degree` and rename `degreeChord` methods in [#169](https://github.com/albertms10/music_notes/pull/169)
- refactor(scale): rename `items` → `degrees` in [#170](https://github.com/albertms10/music_notes/pull/170)
- refactor(scale_degree): rename `degree` → `ordinal` in [#171](https://github.com/albertms10/music_notes/pull/171)
- refactor(scale_pattern): extract helper functions to simplify `degreePattern` method in [#172](https://github.com/albertms10/music_notes/pull/172)
- feat(chord_pattern): add `augmented`, `major`, `minor`, and `diminished` getters in [#173](https://github.com/albertms10/music_notes/pull/173)
- fix(chord): correctly identify compound intervals in `pattern` getter in [#174](https://github.com/albertms10/music_notes/pull/174)
- feat(harmony): make `Chord` implement extracted `Chordable` mixin methods in [#175](https://github.com/albertms10/music_notes/pull/175)
- chore(pubspec): bump version 0.9.0 in [#178](https://github.com/albertms10/music_notes/pull/178)
- feat(harmonic_function): add class and `Scale` method in [#176](https://github.com/albertms10/music_notes/pull/176)

**Full Changelog**: [`v0.8.0...v0.9.0`](https://github.com/albertms10/music_notes/compare/v0.8.0...v0.9.0)

## 0.8.0

- refactor(scale_pattern): rename class in [#128](https://github.com/albertms10/music_notes/pull/128)
- refactor(scale_pattern): rename test file in [#129](https://github.com/albertms10/music_notes/pull/129)
- feat(frequency): add `+`, `-`, `*`, `/` operators in [#130](https://github.com/albertms10/music_notes/pull/130)
- test(interval_size_extension): add test cases for large `semitones` in [#131](https://github.com/albertms10/music_notes/pull/131)
- feat(interval): show quality semitones on `null` abbreviation in `toString` in [#133](https://github.com/albertms10/music_notes/pull/133)
- feat(base_note)!: remove support for `intervalSize` `isDescending` argument in [#134](https://github.com/albertms10/music_notes/pull/134)
- feat(scalable): add abstract interface with `interval` method in [#135](https://github.com/albertms10/music_notes/pull/135)
- feat(interval): add `+` operator in [#136](https://github.com/albertms10/music_notes/pull/136)
- fix(scale_pattern): check for `descendingIntervalSteps` in `==` in [#137](https://github.com/albertms10/music_notes/pull/137)
- feat(scale_pattern): include descending steps in `toString` in [#138](https://github.com/albertms10/music_notes/pull/138)
- fix(scale_pattern): return `mirrored` Scale with descending steps in [#141](https://github.com/albertms10/music_notes/pull/141)
- feat(scale)!: add new class with `pattern` and `reversed` getters in [#139](https://github.com/albertms10/music_notes/pull/139)
- fix(scale_pattern): return correct descending `PositionedNote` scale in `from` in [#142](https://github.com/albertms10/music_notes/pull/142)
- refactor(scalable): move to root `lib` directory in [#143](https://github.com/albertms10/music_notes/pull/143)
- feat(enharmonic_interval): add `isDescending`, `descending` methods in [#144](https://github.com/albertms10/music_notes/pull/144)
- test(enharmonic_interval): add test cases for `isDescending`, `descending` methods in [#145](https://github.com/albertms10/music_notes/pull/145)
- chore(pubspec): bump versions as of `very_good_analysis` 5.0.0+1 in [#146](https://github.com/albertms10/music_notes/pull/146)
- feat(positioned_note): add reference `note` for `equalTemperamentFrequency` in [#147](https://github.com/albertms10/music_notes/pull/147)
- refactor(note): rename `fifthsDistanceWith` method in [#148](https://github.com/albertms10/music_notes/pull/148)
- test(note): reference failing tests related to #149 in [#150](https://github.com/albertms10/music_notes/pull/150)

**Full Changelog**: [`v0.7.0...v0.8.0`](https://github.com/albertms10/music_notes/compare/v0.7.0...v0.8.0)

## 0.7.0

- refactor: Extract Frequency in [#112](https://github.com/albertms10/music_notes/pull/112)
- refactor: normalize `isNegative` condition in [#116](https://github.com/albertms10/music_notes/pull/116)
- feat(frequency): override `toString`, `==`, `hashCode`, and `compareTo` methods in [#117](https://github.com/albertms10/music_notes/pull/117)
- feat(frequency): assert positive `hertz` value in [#118](https://github.com/albertms10/music_notes/pull/118)
- refactor(positioned_note)!: use `Frequency` as a reference in [#119](https://github.com/albertms10/music_notes/pull/119)
- refactor: remove `MusicItem` interface in [#115](https://github.com/albertms10/music_notes/pull/115)
- refactor: PositionedNote composition with Note instead of inheritance in [#113](https://github.com/albertms10/music_notes/pull/113)
- test(positioned_note): add more test cases for `semitonesFromRootHeight` in [#120](https://github.com/albertms10/music_notes/pull/120)
- refactor(transposable): add generic constraint in [#99](https://github.com/albertms10/music_notes/pull/99)
- refactor(base_notes): rename `Notes` → `BaseNote` in [#121](https://github.com/albertms10/music_notes/pull/121)
- refactor(enharmonic_note): remove redirecting method on `enharmonicIntervalDistance` in [#122](https://github.com/albertms10/music_notes/pull/122)
- refactor!: consistently rename `isDescending` in [#123](https://github.com/albertms10/music_notes/pull/123)
- feat(note): add Tonality `major` and `minor` getters in [#124](https://github.com/albertms10/music_notes/pull/124)
- refactor(base_note): rename `transposeBySize` method in [#125](https://github.com/albertms10/music_notes/pull/125)
- docs(note): migrate missing `PositionedNote` documentation in [#126](https://github.com/albertms10/music_notes/pull/126)
- feat(note): add `sharp`, `flat` getters in [#127](https://github.com/albertms10/music_notes/pull/127)

**Full Changelog**: [`v0.6.0...v0.7.0`](https://github.com/albertms10/music_notes/compare/v0.6.0...v0.7.0)

## 0.6.0

- refactor(interval): extract and reuse `_sizeAbsShift` getter in [#97](https://github.com/albertms10/music_notes/pull/97)
- refactor(mode): rename `compare` static method in [#98](https://github.com/albertms10/music_notes/pull/98)
- feat(positioned_note)!: allow passing `a4Hertzs` to `isHumanAudibleAt` in [#100](https://github.com/albertms10/music_notes/pull/100)
- feat(note): add `circleOfFifthsDistance` getter in [#101](https://github.com/albertms10/music_notes/pull/101)
- feat(note): add `compareByFifthsDistance` static comparator in [#102](https://github.com/albertms10/music_notes/pull/102)
- feat(interval): add `descending` method in [#103](https://github.com/albertms10/music_notes/pull/103)
- feat(scale): add `descendingIntervalSteps` in [#104](https://github.com/albertms10/music_notes/pull/104)
- chore: bump versions as of Dart SDK 3.0 in [#105](https://github.com/albertms10/music_notes/pull/105)

**Full Changelog**: [`v0.5.1...v0.6.0`](https://github.com/albertms10/music_notes/compare/v0.5.1...v0.6.0)

## 0.5.1

- feat(scale): allow passing `EnharmonicNote` to `fromNote` in [#91](https://github.com/albertms10/music_notes/pull/91)
- fix(enharmonic_interval): handle descending intervals in `items` in [#92](https://github.com/albertms10/music_notes/pull/92)
- refactor(quality)!: rename `double` to `doubly` in [#93](https://github.com/albertms10/music_notes/pull/93)
- refactor(enharmonic): rename `items` → `spellings` in [#94](https://github.com/albertms10/music_notes/pull/94)
- fix(interval_size_extension): address `simplified` compound interval sizes in [#95](https://github.com/albertms10/music_notes/pull/95)
- feat(interval): show simplified interval in `toString` in [#96](https://github.com/albertms10/music_notes/pull/96)

**Full Changelog**: [`v0.5.0...v0.5.1`](https://github.com/albertms10/music_notes/compare/v0.5.0...v0.5.1)

## 0.5.0

- feat(enharmonic_interval): suppress semitones limit in [#64](https://github.com/albertms10/music_notes/pull/64)
- perf(interval): simplify `isPerfect` logic in [#65](https://github.com/albertms10/music_notes/pull/65)
- refactor(accidental): rewrite `symbol` getter using explanatory variables in [#66](https://github.com/albertms10/music_notes/pull/66)
- feat(int_interval_extension): allow compound intervals in `fromSemitones` in [#67](https://github.com/albertms10/music_notes/pull/67)
- feat(enharmonic_interval)!: rewrite distance `semitones` starting from 0 in [#68](https://github.com/albertms10/music_notes/pull/68)
- refactor(enharmonic_interval): change `Transposable` with add/subtract operators in [#69](https://github.com/albertms10/music_notes/pull/69)
- feat(note): implement `Transposable` in [#70](https://github.com/albertms10/music_notes/pull/70)
- refactor(interval): add static const constructors in [#71](https://github.com/albertms10/music_notes/pull/71)
- feat(scale): add class and `fromNote` method in [#72](https://github.com/albertms10/music_notes/pull/72)
- feat(interval)!: change `descending` with negative `size` in [#73](https://github.com/albertms10/music_notes/pull/73)
- refactor(interval_size_extension): rename extension in [#74](https://github.com/albertms10/music_notes/pull/74)
- feat(interval): add negation and multiplication operators in [#75](https://github.com/albertms10/music_notes/pull/75)
- feat(key_signature): throw an assertion error when passing a wrong `Accidental` in [#77](https://github.com/albertms10/music_notes/pull/77)
- feat(scale): add `mirrored`, `name` methods and override `==` in [#79](https://github.com/albertms10/music_notes/pull/79)
- feat(mode)!: rewrite `Mode` enums in [#78](https://github.com/albertms10/music_notes/pull/78)
- feat(tonality): add `scaleNotes` getter in [#80](https://github.com/albertms10/music_notes/pull/80)
- feat(positioned_note): override `transposeBy` method in [#81](https://github.com/albertms10/music_notes/pull/81)
- docs: add Wikipedia links to `Scale` and `Mode` in [#82](https://github.com/albertms10/music_notes/pull/82)
- feat(mode)!: use `brightness` as the Dorian Brightness Quotient in [#83](https://github.com/albertms10/music_notes/pull/83)
- refactor(positioned_note): improve `helmholtzName` getter legibility in [#84](https://github.com/albertms10/music_notes/pull/84)
- refactor: replace `quiver` package with native `Object.hash` in [#85](https://github.com/albertms10/music_notes/pull/85)
- chore(vscode): add `.lock` file association with YAML in [#86](https://github.com/albertms10/music_notes/pull/86)
- feat(interval): add `isDescending` getter in [#87](https://github.com/albertms10/music_notes/pull/87)
- test(interval): add more test cases for descending `Interval` in [#76](https://github.com/albertms10/music_notes/pull/76)
- refactor: replace `EnharmonicNote` with `Note` for `transposeBy` in [#88](https://github.com/albertms10/music_notes/pull/88)
- fix(key_signature): use XOR in 0 accidentals assertions in [#89](https://github.com/albertms10/music_notes/pull/89)
- refactor(note): rewrite `fromRawAccidentals` into `KeySignature.majorNote` in [#90](https://github.com/albertms10/music_notes/pull/90)

**Full Changelog**: [`v0.4.0...v0.5.0`](https://github.com/albertms10/music_notes/compare/v0.4.0...v0.5.0)

## 0.4.0

- test: consistently group test cases by content in [#22](https://github.com/albertms10/music_notes/pull/22)
- fix(enharmonic_note): address edge cases for `items` getter in [#23](https://github.com/albertms10/music_notes/pull/23)
- feat(accidental): bring `increment` method back in [#24](https://github.com/albertms10/music_notes/pull/24)
- test: add test cases for `toString` methods in [#25](https://github.com/albertms10/music_notes/pull/25)
- test(key_signature): add test cases for `tonalities` getter in [#26](https://github.com/albertms10/music_notes/pull/26)
- test(key_signature): add test cases for `fromDistance` method in [#27](https://github.com/albertms10/music_notes/pull/27)
- feat: implement and test Comparable in [#28](https://github.com/albertms10/music_notes/pull/28)
- feat(accidental): show positive sign in `toString` in [#29](https://github.com/albertms10/music_notes/pull/29)
- feat(key_signature): remove × sign in `toString` in [#30](https://github.com/albertms10/music_notes/pull/30)
- test(music): add test case for `circleOfFifths` in [#31](https://github.com/albertms10/music_notes/pull/31)
- test(enharmonic): add test cases for `toString` in [#32](https://github.com/albertms10/music_notes/pull/32)
- test(interval): add test cases for `toString` in [#33](https://github.com/albertms10/music_notes/pull/33)
- test(enharmonic_interval): add test cases for `transposeBy` in [#34](https://github.com/albertms10/music_notes/pull/34)
- refactor(music_item): implement `Comparable` and mark as immutable in [#35](https://github.com/albertms10/music_notes/pull/35)
- test: compare `.hashCode` Set as a List in [#36](https://github.com/albertms10/music_notes/pull/36)
- feat(tonality): improve `compareTo` sorting by note and mode in [#37](https://github.com/albertms10/music_notes/pull/37)
- test(interval): add test cases for interval-related members in [#39](https://github.com/albertms10/music_notes/pull/39)
- feat(intervals): add `isCompound` getter in [#40](https://github.com/albertms10/music_notes/pull/40)
- test(intervals): add test cases for `fromSemitones` in [#41](https://github.com/albertms10/music_notes/pull/41)
- feat!: rewrite `Qualities` enum with proper `Quality` class in [#42](https://github.com/albertms10/music_notes/pull/42)
- feat(intervals): add `isDissonant` getter in [#43](https://github.com/albertms10/music_notes/pull/43)
- refactor(enharmonic_interval): add static const constructors in [#44](https://github.com/albertms10/music_notes/pull/44)
- feat(interval)!: replace `Intervals` enum with `int` value in [#45](https://github.com/albertms10/music_notes/pull/45)
- docs: document `Quality` class and rewrite Example consistently in [#46](https://github.com/albertms10/music_notes/pull/46)
- feat(accidental): add `name` getter in [#47](https://github.com/albertms10/music_notes/pull/47)
- feat(enharmonic_note): add `toClosestNote` method in [#48](https://github.com/albertms10/music_notes/pull/48)
- fix(note): simplify `fromRawAccidentals` accidental increment in [#49](https://github.com/albertms10/music_notes/pull/49)
- refactor(quality): move `qualityFromDelta` to `Quality.fromInterval` factory constructor in [#51](https://github.com/albertms10/music_notes/pull/51)
- refactor(interval): move `EnharmonicInterval.fromDesiredSemitones` in [#52](https://github.com/albertms10/music_notes/pull/52)
- test(interval): add test cases for `inverted` in [#53](https://github.com/albertms10/music_notes/pull/53)
- refactor(notes): address `intervalSize` descending logic in [#54](https://github.com/albertms10/music_notes/pull/54)
- test(note): add test cases for `difference` in [#55](https://github.com/albertms10/music_notes/pull/55)
- refactor(tonality): add static const constructors in [#56](https://github.com/albertms10/music_notes/pull/56)
- feat(note): add `octave` member in [#57](https://github.com/albertms10/music_notes/pull/57)
- feat(note): add scientific and Helmholtz notation getters in [#58](https://github.com/albertms10/music_notes/pull/58)
- feat(note): add `equalTemperamentFrequency` in [#59](https://github.com/albertms10/music_notes/pull/59)
- feat(note): add `isHumanAudible` method in [#60](https://github.com/albertms10/music_notes/pull/60)
- refactor(positioned_note): move `Note` methods to subclass in [#61](https://github.com/albertms10/music_notes/pull/61)
- test(tonality): add test cases for `relative`, `keySignature` methods in [#62](https://github.com/albertms10/music_notes/pull/62)
- refactor(music_item): remove unnecessary private constructors in [#63](https://github.com/albertms10/music_notes/pull/63)

**Full Changelog**: [`v0.3.0...v0.4.0`](https://github.com/albertms10/music_notes/compare/v0.3.0...v0.4.0)

## 0.3.0

- chore: bump versions as of Dart SDK 2.19 in [#7](https://github.com/albertms10/music_notes/pull/7)
- refactor(accidental): rewrite new `Accidental` class in [#8](https://github.com/albertms10/music_notes/pull/8)
- docs: reference new `Accidental` class instead of enum in [#9](https://github.com/albertms10/music_notes/pull/9)
- refactor: make `Accidental.natural` default in [#10](https://github.com/albertms10/music_notes/pull/10)
- refactor(enharmonic): rewrite based on `semitones` in [#11](https://github.com/albertms10/music_notes/pull/11)
- refactor(notes): rename notes using the English convention in [#12](https://github.com/albertms10/music_notes/pull/12)
- refactor(accidental): rename `value` → `semitones` in [#13](https://github.com/albertms10/music_notes/pull/13)
- refactor(note): add static const constructors in [#14](https://github.com/albertms10/music_notes/pull/14)
- refactor(src): reorganize directories by content in [#15](https://github.com/albertms10/music_notes/pull/15)
- refactor: rewrite `enum` members in [#16](https://github.com/albertms10/music_notes/pull/16)
- refactor(relative_tonalities): remove class in [#17](https://github.com/albertms10/music_notes/pull/17)
- refactor(int_mod_extension): rewrite mod functions into extension methods in [#18](https://github.com/albertms10/music_notes/pull/18)
- refactor(note): move fifths distance functions to class methods in [#19](https://github.com/albertms10/music_notes/pull/19)
- perf(tests): run tests from index `main.dart` file in [#20](https://github.com/albertms10/music_notes/pull/20)
- chore(pubspec): bump version 0.3.0 in [#21](https://github.com/albertms10/music_notes/pull/21)

**Full Changelog**: [`v0.2.0...v0.3.0`](https://github.com/albertms10/music_notes/compare/v0.2.0...v0.3.0)

## 0.2.0

### Music

- (feat) Add `hashCode` methods [528010d](https://github.com/albertms10/music_notes/commit/528010dabf96f537c10f4f9ef6bdaab794591931)

#### Note

- (fix) Add `fromRawAccidentals` method [5c2f663](https://github.com/albertms10/music_notes/commit/5c2f663be0140f9d441d9f256765bd02f3c1469f)

#### Accidentals

- (feat) Added methods for incrementing and decrementing Accidentals value [54c107e](https://github.com/albertms10/music_notes/commit/54c107e9dae728a34e7bb51938f539522aee957a) [092a5fc](https://github.com/albertms10/music_notes/commit/092a5fcbbcc12ba614e2e28d220a8f6a8f7085a7)
- (feat) Added Accidentals symbols [9ebbd18](https://github.com/albertms10/music_notes/commit/9ebbd18916400b92542db60f47e79e7933e3b20f)

### Codebase

- (feat) Coveralls integration [12fc7fa](https://github.com/albertms10/music_notes/commit/12fc7fac134676815d32b1873d27e26bb0cf5146)
- (style) Adopt `very_good_analysis`’ strict lint rules [9508807](https://github.com/albertms10/music_notes/commit/950880769fe07091af93baecd563369156c60376) [9139c38](https://github.com/albertms10/music_notes/commit/9139c38bd058902937599066019688f273dfebe7) [2577579](https://github.com/albertms10/music_notes/commit/25775796ba968a2aca9d2bc5de3d44b620f3e265)
- (refactor) Migrate to `null-safety` [#1](https://github.com/albertms10/music_notes/pull/1) [15d1eab](https://github.com/albertms10/music_notes/commit/15d1eab4884dbad7c383adaac32f6540c7762a41)
- (refactor) Rename and translate enum values [b481ef5](https://github.com/albertms10/music_notes/commit/b481ef5e21be374b6d95cae7cac326d70f868947)
- chore(deps): override `meta` v1.6.0 in [#3](https://github.com/albertms10/music_notes/pull/3)
- chore(deps): bump versions as of Dart SDK 2.16 in [#5](https://github.com/albertms10/music_notes/pull/5)
- refactor(enums): replace `toText` with native `name` getter in [#6](https://github.com/albertms10/music_notes/pull/6)

**Full Changelog**: [`v0.1.0...v0.2.0`](https://github.com/albertms10/music_notes/compare/v0.1.0...v0.2.0)

## 0.1.0

Initial implementation of basic and fundamental operations with notes, intervals, tonalities and key signatures.

**Full Changelog**: [`v0.1.0`](https://github.com/albertms10/music_notes/compare/68e419019f708f272fe4278b64a5a6dd5b43778e...v0.1.0)
