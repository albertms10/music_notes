## 0.25.0

- refactor: ♻️ consistently reorder `NotationSystem.parse` and `.format` methods [#676](https://github.com/albertms10/music_notes/pull/676)
- feat!(accidental): 💥 change directionality of accidentals in `SymbolAccidentalNotation` [#677](https://github.com/albertms10/music_notes/pull/677)
- feat(closest_pitch): ✨ make zero-cents pitch explicit [#679](https://github.com/albertms10/music_notes/pull/679)
- feat(key_signature): ✨ output more detailed `toString` [#678](https://github.com/albertms10/music_notes/pull/678)
- feat(closest_pitch): ✨ allow specifying the `fractionDigits` in `StandardClosestPitchNotation` [#680](https://github.com/albertms10/music_notes/pull/680)
- refactor(music_notes): ♻️ export missing library files [#681](https://github.com/albertms10/music_notes/pull/681)
- refactor(notation_system): ♻️ swap more natural type parameters order [#683](https://github.com/albertms10/music_notes/pull/683)
- feat(pitch): ✨ add `.fromMidi` factory constructor [#684](https://github.com/albertms10/music_notes/pull/684)
- refactor(pitch): ♻️ use case pattern to check for MIDI number range [#685](https://github.com/albertms10/music_notes/pull/685)
- feat(closest_pitch): ✨ allow passing `null` to disable rounding in `StandardClosestPitchNotation` [#686](https://github.com/albertms10/music_notes/pull/686)
- feat(pitch): ✨ add MusicXML notation system parser and formatter [#642](https://github.com/albertms10/music_notes/pull/642)
- feat(notation_system): ✨ add `StringParserChain.firstMatchingParser` extension method [#694](https://github.com/albertms10/music_notes/pull/694)
- fix(key): ⌨️ use standard capitalized `TonalMode` in `GermanKeyNotation` [#697](https://github.com/albertms10/music_notes/pull/697)
- refactor!(interval): 💥 rename `withDescending` method [#698](https://github.com/albertms10/music_notes/pull/698)
- feat(interval): ✨ add convenient `ascending`, `descending` and `direction` getters [#699](https://github.com/albertms10/music_notes/pull/699)
- refactor(interval): ♻️ simplify `fromSizeAndQualitySemitones` factory constructor [#702](https://github.com/albertms10/music_notes/pull/702)
- refactor!: 💥 rewrite `toString` into a more succinct `format` method [#705](https://github.com/albertms10/music_notes/pull/705)

### Dependabot updates

- chore(deps): ⬆️ bump github/codeql-action from 4.31.8 to 4.31.9 in the minor-actions-dependencies group [#682](https://github.com/albertms10/music_notes/pull/682)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#687](https://github.com/albertms10/music_notes/pull/687)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#688](https://github.com/albertms10/music_notes/pull/688)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#689](https://github.com/albertms10/music_notes/pull/689)
- chore(deps): ⬆️ bump github/codeql-action from 4.32.0 to 4.32.2 in the minor-actions-dependencies group [#691](https://github.com/albertms10/music_notes/pull/691)
- chore(deps): ⬆️ bump github/codeql-action from 4.32.2 to 4.32.3 in the minor-actions-dependencies group [#692](https://github.com/albertms10/music_notes/pull/692)
- chore(deps): ⬆️ bump github/codeql-action from 4.32.3 to 4.32.4 in the minor-actions-dependencies group [#693](https://github.com/albertms10/music_notes/pull/693)
- chore(deps): ⬆️ bump actions/upload-artifact from 6.0.0 to 7.0.0 [#695](https://github.com/albertms10/music_notes/pull/695)
- chore(deps): ⬆️ bump github/codeql-action from 4.32.4 to 4.32.6 in the minor-actions-dependencies group [#696](https://github.com/albertms10/music_notes/pull/696)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#703](https://github.com/albertms10/music_notes/pull/703)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#704](https://github.com/albertms10/music_notes/pull/704)
- chore(deps): ⬆️ bump actions/upload-artifact from 7.0.0 to 7.0.1 in the minor-actions-dependencies group [#706](https://github.com/albertms10/music_notes/pull/706)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#707](https://github.com/albertms10/music_notes/pull/707)

**Full Changelog**: [`v0.24.0...v0.25.0`](https://github.com/albertms10/music_notes/compare/v0.24.0...v0.25.0)

## 0.24.0

- build(pubspec): 🚚 bump Dart SDK 3.9 [#644](https://github.com/albertms10/music_notes/pull/644)
- refactor(base_note): ♻️ extract constant values and reuse base note lists [#649](https://github.com/albertms10/music_notes/pull/649)
- refactor(hearing_range): ♻️ rewrite as an extension of `Range<E>` [#650](https://github.com/albertms10/music_notes/pull/650)
- refactor: ♻️ extract `_parsers` default value static constant for all `.parse` factory methods [#651](https://github.com/albertms10/music_notes/pull/651)
- feat(tuning_fork): ✨ allow Helmholtz for the scientific notation and rewrite `Frequency` notation system [#652](https://github.com/albertms10/music_notes/pull/652)
- refactor!(note_name): 💥 rename `BaseNote` → `NoteName` [#653](https://github.com/albertms10/music_notes/pull/653)
- refactor: ♻️ scope `switch` case variables [#654](https://github.com/albertms10/music_notes/pull/654)
- refactor(range_extension): ♻️ rewrite `toString` parameter in favor of `formatter` [#655](https://github.com/albertms10/music_notes/pull/655)
- refactor: ♻️ make `chainParsers` a public static constant [#656](https://github.com/albertms10/music_notes/pull/656)
- feat(range_extension): ✨ add `RangeIterableExtension.parse` method [#657](https://github.com/albertms10/music_notes/pull/657)
- build(pubspec): 🚚 bump Dart SDK 3.10 and use dot shorthands [#666](https://github.com/albertms10/music_notes/pull/666)
- refactor(note): ♻️ rewrite `GermanNoteNotation.parse` method [#669](https://github.com/albertms10/music_notes/pull/669)
- feat(pitch): ✨ add support for numbered Helmholtz pitch notation [#670](https://github.com/albertms10/music_notes/pull/670)
- test(pitch): 🧪 add test case for repeated zeros in numbered Helmholtz notation [#671](https://github.com/albertms10/music_notes/pull/671)
- refactor(notation_system): ♻️ split string match responsibilities from `NotationSystem` [#675](https://github.com/albertms10/music_notes/pull/675)

### Dependabot updates

- chore(deps): ⬆️ bump github/codeql-action from 3.30.1 to 3.30.3 in the minor-actions-dependencies group [#645](https://github.com/albertms10/music_notes/pull/645)
- chore(deps): ⬆️ bump very_good_analysis from 9.0.0 to 10.0.0 [#646](https://github.com/albertms10/music_notes/pull/646)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#647](https://github.com/albertms10/music_notes/pull/647)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#648](https://github.com/albertms10/music_notes/pull/648)
- chore(deps): ⬆️ bump github/codeql-action from 3.30.6 to 4.30.8 [#658](https://github.com/albertms10/music_notes/pull/658)
- chore(deps): ⬆️ bump github/codeql-action from 4.30.8 to 4.30.9 in the minor-actions-dependencies group [#660](https://github.com/albertms10/music_notes/pull/660)
- chore(deps): ⬆️ bump github/codeql-action from 4.30.9 to 4.31.0 in the minor-actions-dependencies group [#662](https://github.com/albertms10/music_notes/pull/662)
- chore(deps): ⬆️ bump actions/upload-artifact from 4.6.2 to 5.0.0 [#661](https://github.com/albertms10/music_notes/pull/661)
- chore(deps): ⬆️ bump github/codeql-action from 4.31.0 to 4.31.2 in the minor-actions-dependencies group [#663](https://github.com/albertms10/music_notes/pull/663)
- chore(deps): ⬆️ bump actions/checkout from 5.0.0 to 6.0.0 [#665](https://github.com/albertms10/music_notes/pull/665)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#664](https://github.com/albertms10/music_notes/pull/664)
- chore(deps): ⬆️ bump github/codeql-action from 4.31.4 to 4.31.5 in the minor-actions-dependencies group [#667](https://github.com/albertms10/music_notes/pull/667)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#668](https://github.com/albertms10/music_notes/pull/668)
- chore(deps): ⬆️ bump actions/cache from 4.3.0 to 5.0.1 [#673](https://github.com/albertms10/music_notes/pull/673)
- chore(deps): ⬆️ bump github/codeql-action from 4.31.7 to 4.31.8 in the minor-actions-dependencies group [#672](https://github.com/albertms10/music_notes/pull/672)
- chore(deps): ⬆️ bump actions/upload-artifact from 5.0.0 to 6.0.0 [#674](https://github.com/albertms10/music_notes/pull/674)

**Full Changelog**: [`v0.23.0...v0.24.0`](https://github.com/albertms10/music_notes/compare/v0.23.0...v0.24.0)

## 0.23.0

- build(pubspec): 🚚 bump Dart SDK 3.8 [#603](https://github.com/albertms10/music_notes/pull/603)
- feat(scale_pattern): ✨ add Lydian augmented `name` [#610](https://github.com/albertms10/music_notes/pull/610)
- refactor(note): ♻️ simplify `GermanNoteNotation.note` formatter switch [#611](https://github.com/albertms10/music_notes/pull/611)
- refactor(equal_temperament): ♻️ move `chromaticDivisions` from `music.dart` [#616](https://github.com/albertms10/music_notes/pull/616)
- refactor: ♻️ rename formatters to `*Notation` [#608](https://github.com/albertms10/music_notes/pull/608)
- refactor(pitch): ♻️ rewrite using `NotationSystem` [#617](https://github.com/albertms10/music_notes/pull/617)
- refactor(chord_pattern): ♻️ rewrite clearer formatter for intervals [#619](https://github.com/albertms10/music_notes/pull/619)
- feat(interval): ✨ override subtract operator and add `intervalSteps` extension method [#621](https://github.com/albertms10/music_notes/pull/621)
- feat(chord_pattern): ✨ add `under` method [#620](https://github.com/albertms10/music_notes/pull/620)
- refactor(pitch_class): ♻️ rewrite formatter using `NotationSystem` [#622](https://github.com/albertms10/music_notes/pull/622)
- refactor(tuning_fork): ♻️ rewrite formatter using `NotationSystem` [#623](https://github.com/albertms10/music_notes/pull/623)
- refactor(scale_degree): ♻️ rewrite formatter using `NotationSystem` [#624](https://github.com/albertms10/music_notes/pull/624)
- feat(accidental): ✨ allow using ASCII characters for `SymbolAccidentalNotation` [#625](https://github.com/albertms10/music_notes/pull/625)
- feat(pitch): ✨ allow using ASCII characters for `HelmholtzPitchNotation` [#626](https://github.com/albertms10/music_notes/pull/626)
- feat(pitch): ✨ allow using ASCII characters for `ScientificPitchNotation` [#627](https://github.com/albertms10/music_notes/pull/627)
- feat(closest_pitch): ✨ allow using ASCII characters for `StandardClosestPitchNotation` [#628](https://github.com/albertms10/music_notes/pull/628)
- refactor(notation_system): ♻️ use named groups for regular expressions [#629](https://github.com/albertms10/music_notes/pull/629)
- refactor(notation_system): ♻️ use regular expressions consistently [#632](https://github.com/albertms10/music_notes/pull/632)
- feat(note): ✨ add `.textual` constructor to `NoteNotation` systems [#635](https://github.com/albertms10/music_notes/pull/635)
- refactor: ♻️ make textual string representations the default and add `symbol` constructors [#636](https://github.com/albertms10/music_notes/pull/636)
- perf: ⚡ replace `.toString` calls in favor of `.format` inside `Formatter` implementations [#637](https://github.com/albertms10/music_notes/pull/637)
- refactor(interval): ♻️ use `sizeNotation` RegExp pattern to match the `Interval.size` [#639](https://github.com/albertms10/music_notes/pull/639)
- fix(pitch): 🐛 use `noteNotation` RegExp to correctly match the note pattern (e.g., German as well) [#640](https://github.com/albertms10/music_notes/pull/640)
- feat(size): ✨ add `Size.parse` factory method [#641](https://github.com/albertms10/music_notes/pull/641)

### Dependabot updates

- chore(deps): ⬆️ bump ossf/scorecard-action from 2.4.1 to 2.4.2 in the minor-actions-dependencies group [#604](https://github.com/albertms10/music_notes/pull/604)
- chore(deps): ⬆️ bump github/codeql-action from 3.28.18 to 3.28.19 in the minor-actions-dependencies group [#607](https://github.com/albertms10/music_notes/pull/607)
- chore(deps): ⬆️ bump very_good_analysis from 7.0.0 to 9.0.0 [#606](https://github.com/albertms10/music_notes/pull/606)
- chore(deps): ⬆️ bump github/codeql-action from 3.28.19 to 3.29.0 in the minor-actions-dependencies group [#609](https://github.com/albertms10/music_notes/pull/609)
- chore(deps): ⬆️ bump github/codeql-action from 3.29.0 to 3.29.1 in the minor-actions-dependencies group [#612](https://github.com/albertms10/music_notes/pull/612)
- chore(deps): ⬆️ bump github/codeql-action from 3.29.1 to 3.29.2 in the minor-actions-dependencies group [#613](https://github.com/albertms10/music_notes/pull/613)
- chore(deps): ⬆️ bump github/codeql-action from 3.29.2 to 3.29.4 in the minor-actions-dependencies group [#614](https://github.com/albertms10/music_notes/pull/614)
- chore(deps): ⬆️ bump github/codeql-action from 3.29.4 to 3.29.5 in the minor-actions-dependencies group [#615](https://github.com/albertms10/music_notes/pull/615)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#618](https://github.com/albertms10/music_notes/pull/618)
- chore(deps): ⬆️ bump actions/checkout from 4.2.2 to 5.0.0 [#631](https://github.com/albertms10/music_notes/pull/631)
- chore(deps): ⬆️ bump github/codeql-action from 3.29.8 to 3.29.9 in the minor-actions-dependencies group [#630](https://github.com/albertms10/music_notes/pull/630)
- chore(deps): ⬆️ bump github/codeql-action from 3.29.9 to 3.29.11 in the minor-actions-dependencies group [#633](https://github.com/albertms10/music_notes/pull/633)
- chore(deps): ⬆️ bump github/codeql-action from 3.29.11 to 3.30.1 in the minor-actions-dependencies group [#638](https://github.com/albertms10/music_notes/pull/638)

**Full Changelog**: [`v0.22.0...v0.23.0`](https://github.com/albertms10/music_notes/compare/v0.22.0...v0.23.0)

## 0.22.0

- docs(README): 📖 add examples for `Frequency.at` temperature method [#581](https://github.com/albertms10/music_notes/pull/581)
- refactor(map_extension): 🔥 remove unused `recordEntries` utility method [#582](https://github.com/albertms10/music_notes/pull/582)
- refactor(note): 💥 rewrite `harmonics` methods to return an `Iterable` [#584](https://github.com/albertms10/music_notes/pull/584)
- refactor: ♻️ use `Size` constants where appropriate [#583](https://github.com/albertms10/music_notes/pull/583)
- refactor: ♻️ use patterns to succinctly destructure objects [#585](https://github.com/albertms10/music_notes/pull/585)
- docs(README): 📖 add more similar projects in other languages [#588](https://github.com/albertms10/music_notes/pull/588)
- docs: 📖 use consistent wording for documentation comments [#593](https://github.com/albertms10/music_notes/pull/593)
- build(pubspec): 🚚 bump Dart SDK 3.7 [#591](https://github.com/albertms10/music_notes/pull/591)
- refactor(quality): ♻️ rewrite `compareTo` without relying on `runtimeType` [#594](https://github.com/albertms10/music_notes/pull/594)
- test(quality): 🧪 add missing test case for `compareTo` method [#600](https://github.com/albertms10/music_notes/pull/600)
- feat(note): ✨ add `inOctave` extension methods for `Note` and `Pitch` lists [#586](https://github.com/albertms10/music_notes/pull/586)
- feat(scalable): ✨ add `isStepwise` getter [#446](https://github.com/albertms10/music_notes/pull/446)
- refactor(interval): ♻️ rewrite notation systems using `Formatter` [#416](https://github.com/albertms10/music_notes/pull/416)
- feat(chord_pattern): ✨ implement the `ChordPatternFormatter` [#256](https://github.com/albertms10/music_notes/pull/256)

### Dependabot updates

- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#587](https://github.com/albertms10/music_notes/pull/587)
- chore(deps): ⬆️ bump github/codeql-action from 3.28.5 to 3.28.8 in the minor-actions-dependencies group [#589](https://github.com/albertms10/music_notes/pull/589)
- chore(deps): ⬆️ bump github/codeql-action from 3.28.8 to 3.28.9 in the minor-actions-dependencies group [#590](https://github.com/albertms10/music_notes/pull/590)
- chore(deps): ⬆️ bump dart-lang/setup-dart from 1.7.0 to 1.7.1 in the minor-actions-dependencies group [#592](https://github.com/albertms10/music_notes/pull/592)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 4 updates [#595](https://github.com/albertms10/music_notes/pull/595)
- chore(deps): ⬆️ bump the minor-actions-dependencies group across 1 directory with 3 updates [#598](https://github.com/albertms10/music_notes/pull/598)
- chore(deps): ⬆️ bump github/codeql-action from 3.28.12 to 3.28.17 in the minor-actions-dependencies group [#599](https://github.com/albertms10/music_notes/pull/599)
- chore(deps): ⬆️ bump github/codeql-action from 3.28.17 to 3.28.18 in the minor-actions-dependencies group [#601](https://github.com/albertms10/music_notes/pull/601)

**Full Changelog**: [`v0.21.0...v0.22.0`](https://github.com/albertms10/music_notes/compare/v0.21.0...v0.22.0)

## 0.21.0

- docs(size): 📖 move implementation comments from method documentation [#571](https://github.com/albertms10/music_notes/pull/571)
- feat(scale_pattern): ✨ add `exclude` Intervals method [#570](https://github.com/albertms10/music_notes/pull/570)
- refactor(scale_pattern): ♻️ use proper `Set` argument for `exclude` [#572](https://github.com/albertms10/music_notes/pull/572)
- refactor(interval): 💥 simplify `circleFrom` method dropping the `distance` argument [#573](https://github.com/albertms10/music_notes/pull/573)
- refactor(note): 💥 rewrite `splitCircleOfFifths` method to return `Iterable`s [#574](https://github.com/albertms10/music_notes/pull/574)
- fix(size): 🐛 rewrite `simple` getter without imprecise `absShift` calc [#575](https://github.com/albertms10/music_notes/pull/575)
- docs(size): 📖 add clearer binary documentation about `isPerfect` implementation [#576](https://github.com/albertms10/music_notes/pull/576)
- fix(size): 🐛 rewrite `semitones` getter without relying on deprecated `absShift` [#577](https://github.com/albertms10/music_notes/pull/577)
- fix(size): 🐛 use correct `isPerfect` assert condition in constructor [#578](https://github.com/albertms10/music_notes/pull/578)
- ci(analysis): 💚 bump Dart SDK 3.6 [#580](https://github.com/albertms10/music_notes/pull/580)
- refactor(note): ♻️ rewrite `transposeBy` method without `absShift` [#579](https://github.com/albertms10/music_notes/pull/579)

### Dependabot updates

- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#568](https://github.com/albertms10/music_notes/pull/568)
- chore(deps): ⬆️ bump the minor-actions-dependencies group with 2 updates [#569](https://github.com/albertms10/music_notes/pull/569)

**Full Changelog**: [`v0.20.0...v0.21.0`](https://github.com/albertms10/music_notes/compare/v0.20.0...v0.21.0)

## 0.20.0

- refactor(scale_pattern): ♻️ rename `BinarySequence` extension methods [#529](https://github.com/albertms10/music_notes/pull/529)
- feat(note): ✨ add `flat`, `sharp`, and `natural` extension methods of `List<Note>` [#528](https://github.com/albertms10/music_notes/pull/528)
- refactor(interval): ♻️ rename `distanceBetween` parameters and simplify return signature [#531](https://github.com/albertms10/music_notes/pull/531)
- refactor!(interval): 💥 rename `distanceBetween` → `circleDistance` [#532](https://github.com/albertms10/music_notes/pull/532)
- refactor!(note): 💥 rename `flatCircleOfFifths` → `circleOfFifths` method [#533](https://github.com/albertms10/music_notes/pull/533)
- fix(pitch): 🐛 address descending intervals in `interval` method [#285](https://github.com/albertms10/music_notes/pull/285)
- feat(interval): ✨ make the class `Respellable` [#539](https://github.com/albertms10/music_notes/pull/539)
- feat(iterable_extension): ✨ add `compact`, `explode` and `format` extension methods [#535](https://github.com/albertms10/music_notes/pull/535)
- refactor(iterable_extension): ♻️ simplify `compact` method [#541](https://github.com/albertms10/music_notes/pull/541)
- perf(iterable_extension): ⚡️ rewrite `closestTo` with extension methods [#542](https://github.com/albertms10/music_notes/pull/542)
- perf: ⚡️ mark `toList` calls as non-`growable` [#540](https://github.com/albertms10/music_notes/pull/540)
- fix(size): 🐛 address longstanding issue with `isPerfect` in large interval sizes [#544](https://github.com/albertms10/music_notes/pull/544)

### Dependabot updates

- chore(deps): ⬆️ bump actions/upload-artifact from 4.3.5 to 4.3.6 [#526](https://github.com/albertms10/music_notes/pull/526)
- chore(deps): ⬆️ bump github/codeql-action from 3.25.15 to 3.26.0 [#527](https://github.com/albertms10/music_notes/pull/527)
- chore(deps): ⬆️ bump github/codeql-action from 3.26.0 to 3.26.5 [#534](https://github.com/albertms10/music_notes/pull/534)
- chore(deps): ⬆️ bump actions/upload-artifact from 4.3.6 to 4.4.0 [#536](https://github.com/albertms10/music_notes/pull/536)
- chore(deps): ⬆️ bump github/codeql-action from 3.26.5 to 3.26.7 [#538](https://github.com/albertms10/music_notes/pull/538)
- chore(deps): ⬆️ bump actions/checkout from 4.1.7 to 4.2.0 [#546](https://github.com/albertms10/music_notes/pull/546)
- chore(deps): ⬆️ bump github/codeql-action from 3.26.7 to 3.26.9 [#547](https://github.com/albertms10/music_notes/pull/547)
- chore(deps): ⬆️ bump github/codeql-action from 3.26.9 to 3.27.0 [#558](https://github.com/albertms10/music_notes/pull/558)
- chore(deps): ⬆️ bump coverallsapp/github-action from 2.3.0 to 2.3.4 [#559](https://github.com/albertms10/music_notes/pull/559)
- chore(deps): ⬆️ bump actions/cache from 4.0.2 to 4.1.2 [#557](https://github.com/albertms10/music_notes/pull/557)
- chore(deps): ⬆️ bump the minor-actions-dependencies group across 1 directory with 2 updates [#561](https://github.com/albertms10/music_notes/pull/561)
- chore(deps): ⬆️ bump github/codeql-action from 3.27.0 to 3.27.1 in the minor-actions-dependencies group [#562](https://github.com/albertms10/music_notes/pull/562)
- chore(deps): ⬆️ bump github/codeql-action from 3.27.1 to 3.27.4 in the minor-actions-dependencies group [#563](https://github.com/albertms10/music_notes/pull/563)
- chore(deps): ⬆️ bump the minor-actions-dependencies group across 1 directory with 2 updates [#565](https://github.com/albertms10/music_notes/pull/565)
- chore(deps): ⬆️ bump the minor-actions-dependencies group across 1 directory with 2 updates [#567](https://github.com/albertms10/music_notes/pull/567)

**Full Changelog**: `v0.19.1...v0.20.0`](https://github.com/albertms10/music_notes/compare/v0.19.1...v0.20.0)

## 0.19.1

- refactor(interval): 📖 remove ignored `prefer_const_constructors` lint [#524](https://github.com/albertms10/music_notes/pull/524)
- docs(CHANGELOG): 🔖 fix typos and address linked Pull requests [#525](https://github.com/albertms10/music_notes/pull/525)

**Full Changelog**: [`v0.19.0...v0.19.1`](https://github.com/albertms10/music_notes/compare/v0.19.0...v0.19.1)

## 0.19.0

- chore(pubspec): 🏗️ bump Dart SDK 3.4.0 [#499](https://github.com/albertms10/music_notes/pull/499)
- chore(analysis_options): 🕵️ enable new lints and fix `unnecessary_library_name` [#500](https://github.com/albertms10/music_notes/pull/500)
- feat!(scalable): 💥 allow providing `reference` in `numericRepresentation` [#501](https://github.com/albertms10/music_notes/pull/501)
- feat!(pitch): 💥 use double, triple, and quadruple prime symbols for Helmholtz notation [#502](https://github.com/albertms10/music_notes/pull/502)
- refactor(tuning): ♻️ remove `Ratio` extension type in favor of `Cent.fromRatio` constructor [#510](https://github.com/albertms10/music_notes/pull/510)
- refactor(utils): ♻️ move `nonZeroSign` method from `int` to `num` extension [#511](https://github.com/albertms10/music_notes/pull/511)
- refactor!(interval): 💥 make `isDescending` parameter in `descending` method positional [#521](https://github.com/albertms10/music_notes/pull/521)
- chore(pubspec): ⬇️ lower the Dart SDK bound to version 3.3 and upgrade analysis CI to 3.5 [#522](https://github.com/albertms10/music_notes/pull/522)
- refactor(analysis): 🕵️ add more lint rules and explain ignored diagnostics [#523](https://github.com/albertms10/music_notes/pull/523)
- feat(utils): ✨ add `Rational` class representation and test cases [#493](https://github.com/albertms10/music_notes/pull/493)
- feat!: 💥 make comparator operators agree with `compareTo` and `==` [#498](https://github.com/albertms10/music_notes/pull/498)

### Dependabot updates

- chore(deps): ⬆️ bump github/codeql-action from 3.25.4 to 3.25.5 [#504](https://github.com/albertms10/music_notes/pull/504)
- chore(deps): ⬆️ bump actions/checkout from 4.1.5 to 4.1.6 [#503](https://github.com/albertms10/music_notes/pull/503)
- chore(deps): ⬆️ bump github/codeql-action from 3.25.5 to 3.25.8 [#507](https://github.com/albertms10/music_notes/pull/507)
- chore(deps): ⬆️ bump actions/checkout from 4.1.6 to 4.1.7 [#508](https://github.com/albertms10/music_notes/pull/508)
- chore(deps): ⬆️ bump github/codeql-action from 3.25.8 to 3.25.10 [#509](https://github.com/albertms10/music_notes/pull/509)
- chore(deps): ⬆️ bump github/codeql-action from 3.25.10 to 3.25.11 [#513](https://github.com/albertms10/music_notes/pull/513)
- chore(deps): ⬆️ bump dart-lang/setup-dart from 1.6.4 to 1.6.5 [#512](https://github.com/albertms10/music_notes/pull/512)
- chore(deps): ⬆️ bump very_good_analysis from 5.1.0 to 6.0.0 [#514](https://github.com/albertms10/music_notes/pull/514)
- chore(deps): ⬆️ bump actions/upload-artifact from 4.3.3 to 4.3.4 [#515](https://github.com/albertms10/music_notes/pull/515)
- chore(deps): ⬆️ bump github/codeql-action from 3.25.11 to 3.25.12 [#516](https://github.com/albertms10/music_notes/pull/516)
- chore(deps): ⬆️ bump github/codeql-action from 3.25.12 to 3.25.15 [#518](https://github.com/albertms10/music_notes/pull/518)
- chore(deps): ⬆️ bump ossf/scorecard-action from 2.3.3 to 2.4.0 [#519](https://github.com/albertms10/music_notes/pull/519)
- chore(deps): ⬆️ bump actions/upload-artifact from 4.3.4 to 4.3.5 [#520](https://github.com/albertms10/music_notes/pull/520)

**Full Changelog**: [`v0.18.0...v0.19.0`](https://github.com/albertms10/music_notes/compare/v0.18.0...v0.19.0)

## 0.18.0

- refactor(note): ♻️ rename `respellByOrdinalDistance` methods [#442](https://github.com/albertms10/music_notes/pull/442)
- feat(note): ✨ return the next closest spelling in `respellByAccidental` when no respelling is possible [#443](https://github.com/albertms10/music_notes/pull/443)
- refactor(quality): ♻️ move `isDissonant` check from `Interval` [#444](https://github.com/albertms10/music_notes/pull/444)
- feat(base_note): ✨ add `next` and `previous` getters [#445](https://github.com/albertms10/music_notes/pull/445)
- test(interval): 🧪 use shorthand `Size` constructors [#447](https://github.com/albertms10/music_notes/pull/447)
- fix(quality): 🐛 address wrong `isDissonant` condition for `ImperfectQuality` [#449](https://github.com/albertms10/music_notes/pull/449)
- refactor(scale_pattern): ♻️ extract static bit-related methods [#451](https://github.com/albertms10/music_notes/pull/451)
- refactor(enharmonic): ♻️ rename `ClassMixin` → `Enharmonic` mixin [#452](https://github.com/albertms10/music_notes/pull/452)
- refactor(frequency): ♻️ extract `reference` as 440 Hz [#454](https://github.com/albertms10/music_notes/pull/454)
- feat(note): ✨ take `temperature` into account when dealing with `Frequency` [#455](https://github.com/albertms10/music_notes/pull/455)
- fix(pitch): 🐛 address `harmonics` wrongly forwarding parameters [#456](https://github.com/albertms10/music_notes/pull/456)
- ci(scorecards-analysis): 🧑‍⚕️ add OSSF Scorecards analysis workflow [#458](https://github.com/albertms10/music_notes/pull/458)
- test(frequency): 🧪 add test case for chained `closestPitch` with `temperature` [#459](https://github.com/albertms10/music_notes/pull/459)
- refactor(scalable, interval): ♻️ consistently rename `inverse`, `inverted` → `inversion` [#460](https://github.com/albertms10/music_notes/pull/460)
- docs(README): 📖 add examples for new methods [#461](https://github.com/albertms10/music_notes/pull/461)
- fix(pitch): 🐛 address `isEnharmonicWith` not taking `octave` into account [#462](https://github.com/albertms10/music_notes/pull/462)
- refactor(pitch): ♻️ extract `reference` static constant [#463](https://github.com/albertms10/music_notes/pull/463)
- refactor: ♻️ remove unnecessary `@immutable` annotation on extension types [#464](https://github.com/albertms10/music_notes/pull/464)
- docs(README): 📖 address `BaseNote` string representation examples [#465](https://github.com/albertms10/music_notes/pull/465)
- feat!(tuning): ✨ add new `TuningFork` class and refactor `TuningSystem` accordingly [#466](https://github.com/albertms10/music_notes/pull/466)
- refactor(frequency): ♻️ move `at` and extract `Celsius.ratio` methods [#467](https://github.com/albertms10/music_notes/pull/467)
- refactor(cent): ♻️ extract `divisionsPerSemitone` and rename `octave` [#471](https://github.com/albertms10/music_notes/pull/471)
- refactor(frequency): ♻️ expose `referenceTemperature` parameter [#472](https://github.com/albertms10/music_notes/pull/472)
- feat(closest_pitch): ✨ add `respelledSimple` getter [#473](https://github.com/albertms10/music_notes/pull/473)
- feat(closest_pitch): ✨ add `+`, `-` operators [#474](https://github.com/albertms10/music_notes/pull/474)
- refactor(scale_pattern): ♻️ extract bit-related methods into `BinarySequence` extension [#479](https://github.com/albertms10/music_notes/pull/479)
- feat(scale_pattern): ✨ add double harmonic major scale [#482](https://github.com/albertms10/music_notes/pull/482)
- refactor(scale_pattern): ♻️ extract bit-related methods into `BinarySequence` extension [#489](https://github.com/albertms10/music_notes/pull/489)
- test(closest_pitch): 🧪 add test cases for `toString` rounding [#491](https://github.com/albertms10/music_notes/pull/491)
- chore(pubspec): 🚚 use correct `repository` URL [#492](https://github.com/albertms10/music_notes/pull/492)
- fix(pitch): 🐛 address large `ClosestPitch` spellings for `harmonics` with `temperature` [#470](https://github.com/albertms10/music_notes/pull/470)
- feat!(interval): ✨ add `fromSemitones(int)` and rename `fromSizeAndSemitones` factory constructors [#476](https://github.com/albertms10/music_notes/pull/476)
- refactor(hearing_range): ♻️ rename `isAudibleAt` method [#457](https://github.com/albertms10/music_notes/pull/457)

### Dependabot updates

- chore(deps): ⬆️ bump actions/checkout from 4.1.1 to 4.1.2 [#448](https://github.com/albertms10/music_notes/pull/448)
- chore(deps): ⬆️ bump actions/cache from 4.0.1 to 4.0.2 [#450](https://github.com/albertms10/music_notes/pull/450)
- chore(deps): ⬆️ bump actions/upload-artifact from 4.1.0 to 4.3.1 [#469](https://github.com/albertms10/music_notes/pull/469)
- chore(deps): ⬆️ bump github/codeql-action from 3.24.9 to 3.24.10 [#478](https://github.com/albertms10/music_notes/pull/478)
- chore(deps): ⬆️ bump dart-lang/setup-dart from 1.6.2 to 1.6.4 [#480](https://github.com/albertms10/music_notes/pull/480)
- chore(deps): ⬆️ bump actions/upload-artifact from 4.3.1 to 4.3.3 [#487](https://github.com/albertms10/music_notes/pull/487)
- chore(deps): ⬆️ bump actions/checkout from 4.1.1 to 4.1.4 [#486](https://github.com/albertms10/music_notes/pull/486)
- chore(deps): ⬆️ bump github/codeql-action from 3.24.10 to 3.25.3 [#488](https://github.com/albertms10/music_notes/pull/488)
- chore(deps): ⬆️ bump actions/checkout from 4.1.4 to 4.1.5 [#497](https://github.com/albertms10/music_notes/pull/497)
- chore(deps): ⬆️ bump ossf/scorecard-action from 2.3.1 to 2.3.3 [#495](https://github.com/albertms10/music_notes/pull/495)
- chore(deps): ⬆️ bump coverallsapp/github-action from 2.2.3 to 2.3.0 [#496](https://github.com/albertms10/music_notes/pull/496)
- chore(deps): ⬆️ bump github/codeql-action from 3.25.3 to 3.25.4 [#494](https://github.com/albertms10/music_notes/pull/494)

**Full Changelog**: [`v0.17.1...v0.18.0`](https://github.com/albertms10/music_notes/compare/v0.17.1...v0.18.0)

## 0.17.1

- fix(deps): 🚚 move `test` to dev_dependencies [#441](https://github.com/albertms10/music_notes/pull/441)

**Full Changelog**: [`v0.17.0...v0.17.1`](https://github.com/albertms10/music_notes/compare/v0.17.0...v0.17.1)

## 0.17.0

- refactor!(key_signature): ♻️ rewrite `keys` method to return a Map [#401](https://github.com/albertms10/music_notes/pull/401)
- docs(README): 📖 remove unit symbol from `Frequency` examples [#402](https://github.com/albertms10/music_notes/pull/402)
- feat!(interval): ✨ use negative `Size` as descending string representation [#403](https://github.com/albertms10/music_notes/pull/403)
- refactor(interval): ♻️ extract `IntervalNotation` system [#404](https://github.com/albertms10/music_notes/pull/404)
- feat!(note): 🔥 use `RomanceNoteNotation` instead of Italian and French [#405](https://github.com/albertms10/music_notes/pull/405)
- refactor(note): ♻️ allow overriding `accidental` from `NoteNotation` [#406](https://github.com/albertms10/music_notes/pull/406)
- test(closest_pitch): 🧪 add more tests for `parse` constructor [#407](https://github.com/albertms10/music_notes/pull/407)
- refactor(note): ♻️ extract common `GermanNoteNotation` system into the dedicated `accidental` method [#408](https://github.com/albertms10/music_notes/pull/408)
- docs: 📖 simplify public API return documentation [#409](https://github.com/albertms10/music_notes/pull/409)
- refactor(interval): ♻️ rename `StandardIntervalNotation` [#410](https://github.com/albertms10/music_notes/pull/410)
- refactor(scale_degree): ♻️ extract `StandardScaleDegreeNotation` [#411](https://github.com/albertms10/music_notes/pull/411)
- feat(scale_degree): 🥅 assert `ordinal` and `inversion` integer values [#412](https://github.com/albertms10/music_notes/pull/412)
- refactor!(mode): ♻️ rename `opposite` → `parallel` method [#414](https://github.com/albertms10/music_notes/pull/414)
- refactor(note): ♻️ simplify `GermanNoteNotation.accidental` [#415](https://github.com/albertms10/music_notes/pull/415)
- refactor: ♻️ rewrite unnecessary `switch` expressions with `if` statements [#419](https://github.com/albertms10/music_notes/pull/419)
- fix(key): 🐛 use lowercased `TonalMode` in `NoteNotation.german` keys [#421](https://github.com/albertms10/music_notes/pull/421)
- feat(scale_degree): ✨ add `inverted` getter [#422](https://github.com/albertms10/music_notes/pull/422)
- refactor(scale_degree): ♻️ extract `romanNumeral` getter [#423](https://github.com/albertms10/music_notes/pull/423)
- docs: 📖 comprehensively document common `toString` methods and their `system`s [#424](https://github.com/albertms10/music_notes/pull/424)
- refactor(scale_degree): ♻️ use new `copyWith` method to update individual properties [#425](https://github.com/albertms10/music_notes/pull/425)
- feat(interval): ✨ add comparison operators `<`, `<=`, `>`, and `>=` [#426](https://github.com/albertms10/music_notes/pull/426)
- test(just_intonation): 🧪 use `closeTo` with ideal ratio in `ratio` use cases [#427](https://github.com/albertms10/music_notes/pull/427)
- feat(key_signature): ✨ add `incrementBy` method [#428](https://github.com/albertms10/music_notes/pull/428)
- feat!: 💥 make main entity collections unmodifiable [#429](https://github.com/albertms10/music_notes/pull/429)
- feat(scale_pattern): ✨ make equality enharmonic [#394](https://github.com/albertms10/music_notes/pull/394)
- refactor(scalable): ♻️ extract `isEnharmonicWith` extension method [#430](https://github.com/albertms10/music_notes/pull/430)
- feat(scale_pattern): ✨ add binary representation methods [#392](https://github.com/albertms10/music_notes/pull/392)
- refactor(scale_pattern): ♻️ simplify binary to integer conversion [#431](https://github.com/albertms10/music_notes/pull/431)
- feat(iterable_extension): ✨ allow overriding `difference` in `closestTo` method [#327](https://github.com/albertms10/music_notes/pull/327)
- feat(pitch): ✨ add helper `harmonics` method [#432](https://github.com/albertms10/music_notes/pull/432)
- feat(pitch): ✨ add Helmholtz notation German and Romance variants [#433](https://github.com/albertms10/music_notes/pull/433)
- feat(interval): ✨ make `perfect` constructor default to `PerfectQuality.perfect` [#435](https://github.com/albertms10/music_notes/pull/435)
- feat(size): ✨ add shorthand getters to create an `Interval` [#436](https://github.com/albertms10/music_notes/pull/436)
- refactor(size): ♻️ split `PerfectSize` and `ImperfectSize` sub-extension types [#437](https://github.com/albertms10/music_notes/pull/437)
- refactor(size): ♻️ redeclare `simple` in extension types to allow chaining [#438](https://github.com/albertms10/music_notes/pull/438)
- feat(size): ✨ add `inverted`, `isDissonant` getters moved from `Interval` [#439](https://github.com/albertms10/music_notes/pull/439)

### Dependabot updates

- chore(deps): ⬆️ bump actions/cache from 4.0.0 to 4.0.1 [#418](https://github.com/albertms10/music_notes/pull/418)

**Full Changelog**: [`v0.16.0...v0.17.0`](https://github.com/albertms10/music_notes/compare/v0.16.0...v0.17.0)

## 0.16.0

- test: ♻️ shorten test descriptions by dropping _should_ [#372](https://github.com/albertms10/music_notes/pull/372)
- refactor!(key_signature): ♻️ change operator `+` → `|` [#373](https://github.com/albertms10/music_notes/pull/373)
- feat(closest_pitch): ✨ add `frequency` method [#374](https://github.com/albertms10/music_notes/pull/374)
- test(note): 🧪 add edge test cases for `circleOfFifthsDistance` [#375](https://github.com/albertms10/music_notes/pull/375)
- refactor(pitch): ♻️ reuse default `Note.toString` return value for `ScientificPitchNotation` [#376](https://github.com/albertms10/music_notes/pull/376)
- feat(tonality): ✨ add `isTheoretical` getter [#377](https://github.com/albertms10/music_notes/pull/377)
- feat(pitch): ✨ add comparison operators `<`, `<=`, `>`, and `>=` [#379](https://github.com/albertms10/music_notes/pull/379)
- feat(pitch): ✨ add `midiNumber` getter [#378](https://github.com/albertms10/music_notes/pull/378)
- refactor!(key): ♻️ rename `Tonality` → `Key` [#380](https://github.com/albertms10/music_notes/pull/380)
- docs(key): 📖 addendum to rename `Tonality` → `Key` [#381](https://github.com/albertms10/music_notes/pull/381)
- test(note): 🧪 `skip` failing tests [#382](https://github.com/albertms10/music_notes/pull/382)
- feat(scale): ✨ add `length` getter [#383](https://github.com/albertms10/music_notes/pull/383)
- feat(note): ✨ rename `toPitchClass` and create `Pitch.toClass` methods [#385](https://github.com/albertms10/music_notes/pull/385)
- refactor: ♻️ enforce `@immutable` and declare `final` Notation classes [#386](https://github.com/albertms10/music_notes/pull/386)
- refactor: ♻️ rewrite `part of` directives in mini libraries [#387](https://github.com/albertms10/music_notes/pull/387)
- test: 🧪 remove unnecessary `equals` matcher [#388](https://github.com/albertms10/music_notes/pull/388)
- refactor(scalable): ♻️ move `toClass` method from `Pitch` [#391](https://github.com/albertms10/music_notes/pull/391)
- feat(scale): ✨ add `isEnharmonicWith` methods [#393](https://github.com/albertms10/music_notes/pull/393)
- build(pubspec): 🏗️ bump Dart SDK 3.3 [#395](https://github.com/albertms10/music_notes/pull/395)
- perf(tuning): ⚡️ rewrite `Cent`, `Ratio` as extension types [#312](https://github.com/albertms10/music_notes/pull/312)
- docs(pitch_class): 📖 add more examples for `operator *` [#396](https://github.com/albertms10/music_notes/pull/396)
- feat!(equal_temperament): 💥 remove default parameter value from `ratioFromSemitones` [#397](https://github.com/albertms10/music_notes/pull/397)
- docs(tuning_system): 📖 rename old `ratioFromNote` examples [#398](https://github.com/albertms10/music_notes/pull/398)
- docs(README): 🌟 add Star History Chart [#399](https://github.com/albertms10/music_notes/pull/399)
- perf(frequency): ⚡️ rewrite as extension type [#349](https://github.com/albertms10/music_notes/pull/349)
- refactor(interval): ♻️ rewrite `Size` as extension type [#311](https://github.com/albertms10/music_notes/pull/311)
- test(scalable): ⚡️ use `const` collection literals whenever possible [#400](https://github.com/albertms10/music_notes/pull/400)

### Dependabot updates

- chore(deps): ⬆️ bump actions/cache from 3.3.3 to 4.0.0 [#384](https://github.com/albertms10/music_notes/pull/384)
- chore(deps): ⬆️ bump dart-lang/setup-dart from 1.6.1 to 1.6.2 [#390](https://github.com/albertms10/music_notes/pull/390)

**Full Changelog**: [`v0.15.0...v0.16.0`](https://github.com/albertms10/music_notes/compare/v0.15.0...v0.16.0)

## 0.15.0

- refactor(tonality): ♻️ rewrite `toString` method into `NoteNotation` [#329](https://github.com/albertms10/music_notes/pull/329)
- refactor: ♻️ rename methods from `Notation` systems [#330](https://github.com/albertms10/music_notes/pull/330)
- perf(key_signature): ⚡️ use `empty` whenever possible [#331](https://github.com/albertms10/music_notes/pull/331)
- feat(accidental): ✨ add `isNatural` getter [#332](https://github.com/albertms10/music_notes/pull/332)
- docs(key_signature): 📖 address wrong `const` keyword [#333](https://github.com/albertms10/music_notes/pull/333)
- docs: 📖 add examples to `spellings` methods [#334](https://github.com/albertms10/music_notes/pull/334)
- feat(note): ✨ compare `spellings` by closest distance [#335](https://github.com/albertms10/music_notes/pull/335)
- refactor(note): ♻️ extract `switch` expression to a local variable in `GermanNoteNotation.tonality` [#336](https://github.com/albertms10/music_notes/pull/336)
- refactor(interval): ♻️ use `descending` in `circleFrom` [#337](https://github.com/albertms10/music_notes/pull/337)
- refactor(frequency): ♻️ rewrite `ClosestPitch` record into a class [#339](https://github.com/albertms10/music_notes/pull/339)
- refactor(frequency): ♻️ extract `humanHearingRange` record [#338](https://github.com/albertms10/music_notes/pull/338)
- refactor(closest_pitch): ♻️ move class to a new file [#341](https://github.com/albertms10/music_notes/pull/341)
- feat(cent): ✨ override negation operator [#342](https://github.com/albertms10/music_notes/pull/342)
- feat!(closest_pitch): 💥 remove `hertz` member [#343](https://github.com/albertms10/music_notes/pull/343)
- feat(pitch): ✨ add `+`, `-` operators [#344](https://github.com/albertms10/music_notes/pull/344)
- refactor(frequency): ♻️ rewrite `HearingRange` record into a class [#340](https://github.com/albertms10/music_notes/pull/340)
- refactor!(cent): ♻️ rename redundant `unitSymbol` static constant [#345](https://github.com/albertms10/music_notes/pull/345)
- refactor: ♻️ infer types from `static const` members [#346](https://github.com/albertms10/music_notes/pull/346)
- chore(gitignore): 🙈 ignore the `tool` directory instead of `bin` [#347](https://github.com/albertms10/music_notes/pull/347)
- refactor(frequency): ♻️ use `num` for `hertz` [#348](https://github.com/albertms10/music_notes/pull/348)
- refactor(tuning_system): ♻️ rename `pitch` parameter from `ratio` [#350](https://github.com/albertms10/music_notes/pull/350)
- feat(closest_pitch): ✨ add `parse` factory constructor [#351](https://github.com/albertms10/music_notes/pull/351)
- docs(tuning_system): 📖 rename `generator` getter examples [#352](https://github.com/albertms10/music_notes/pull/352)
- refactor(quality): ♻️ extract symbols to static constants [#353](https://github.com/albertms10/music_notes/pull/353)
- refactor(quality): ♻️ move diminished and augmented symbols to `Quality` [#354](https://github.com/albertms10/music_notes/pull/354)
- refactor(interval): ♻️ rename `fromQualitySemitones` factory constructor [#355](https://github.com/albertms10/music_notes/pull/355)
- refactor!(quality): ♻️ rename `abbreviation` → `symbol` getter [#356](https://github.com/albertms10/music_notes/pull/356)
- refactor(frequency): ♻️ use `accidental.isSharp` to check whether `isCloserToUpwardsSpelling` [#357](https://github.com/albertms10/music_notes/pull/357)
- docs(key_signature): 📖 add examples to `fromDistance` factory constructor [#358](https://github.com/albertms10/music_notes/pull/358)
- feat(key_signature): ✨ add `clean` getter to support cancellation naturals [#359](https://github.com/albertms10/music_notes/pull/359)
- feat(note): ✨ add `natural` getter [#360](https://github.com/albertms10/music_notes/pull/360)
- docs: 📖 remove wrong const keywords [#361](https://github.com/albertms10/music_notes/pull/361)
- docs(accidental): 📖 add symbols to `static const` members [#366](https://github.com/albertms10/music_notes/pull/366)
- feat(note): ✨ add `showNatural` option to `EnglishNoteNotation` [#365](https://github.com/albertms10/music_notes/pull/365)
- feat(key_signature): ✨ override `+` operator [#362](https://github.com/albertms10/music_notes/pull/362)
- feat(key_signature): ✨ show cautionary accidentals in `+` when not present in `other` [#367](https://github.com/albertms10/music_notes/pull/367)
- feat(tonality): ✨ add `parallel` getter [#368](https://github.com/albertms10/music_notes/pull/368)
- fix(key_signature): 🐛 show each cancelled accidental once in edge key signatures [#369](https://github.com/albertms10/music_notes/pull/369)
- perf(interval): ⚡️ rewrite `circleFrom` as a sync generator [#370](https://github.com/albertms10/music_notes/pull/370)
- feat!(key_signature): 💥 check for `isCanonical` before evaluating `distance` [#371](https://github.com/albertms10/music_notes/pull/371)

### Dependabot updates

- chore(deps): ⬆️ bump dart-lang/setup-dart from 1.6.0 to 1.6.1 [#363](https://github.com/albertms10/music_notes/pull/363)
- chore(deps): ⬆️ bump actions/cache from 3.3.2 to 3.3.3 [#364](https://github.com/albertms10/music_notes/pull/364)

**Full Changelog**: [`v0.14.0...v0.15.0`](https://github.com/albertms10/music_notes/compare/v0.14.0...v0.15.0)

## 0.14.0

- feat(equal_temperament): ✨ override `toString`, `operator ==`, and `hashCode` [#302](https://github.com/albertms10/music_notes/pull/302)
- refactor(equal_temperament)!: ♻️ rewrite octave divisions [#304](https://github.com/albertms10/music_notes/pull/304)
- refactor(interval): ♻️ declare and reassign dynamic `notes` in record [#305](https://github.com/albertms10/music_notes/pull/305)
- feat(accidental): ✨ add `name` cases for all accidentals [#306](https://github.com/albertms10/music_notes/pull/306)
- refactor(pitch): ♻️ rename `PositionedNote` → `Pitch` [#308](https://github.com/albertms10/music_notes/pull/308)
- docs: 📖 add related entities in class documentation [#309](https://github.com/albertms10/music_notes/pull/309)
- feat(note): ✨ add optional `NotationSystem` to `toString` methods [#307](https://github.com/albertms10/music_notes/pull/307)
- build(pubspec): ⬆️ upgrade Dart SDK 3.2 [#310](https://github.com/albertms10/music_notes/pull/310)
- feat!(pitch): 💥 move `scientificName` and `helmholtzName` to `toString` [#313](https://github.com/albertms10/music_notes/pull/313)
- refactor!(note): ♻️ rename `NotationSystem` → `NoteNotation` [#314](https://github.com/albertms10/music_notes/pull/314)
- refactor!(pitch_class): ♻️ move `integerNotation` to `toString` [#315](https://github.com/albertms10/music_notes/pull/315)
- refactor(note): ♻️ use `major` getter in `circleOfFifthsDistance` [#317](https://github.com/albertms10/music_notes/pull/317)
- docs(transposable): 📖 simplify `transposeBy` documentation [#318](https://github.com/albertms10/music_notes/pull/318)
- feat(accidental): ✨ add `isFlat`, `isSharp` getters [#319](https://github.com/albertms10/music_notes/pull/319)
- refactor(note): ♻️ rewrite notation systems to allow extending behavior [#316](https://github.com/albertms10/music_notes/pull/316)
- refactor: ♻️ rename `toClass` methods [#320](https://github.com/albertms10/music_notes/pull/320)
- docs(README): 📖 use varied descending `Interval` example [#323](https://github.com/albertms10/music_notes/pull/323)
- refactor(scalable): ♻️ move `semitones` to abstract class [#324](https://github.com/albertms10/music_notes/pull/324)
- feat!(scalable): 💥 make `difference` return the closest number of semitones [#325](https://github.com/albertms10/music_notes/pull/325)
- feat(scalable): ✨ add `inverse`, `retrograde` getters to `ScalableIterable` [#287](https://github.com/albertms10/music_notes/pull/287)
- test(interval): ⚡️ use `const` for literals [#328](https://github.com/albertms10/music_notes/pull/328)
- fix(pitch_class): 🐛 return descending intervals in `interval` method [#286](https://github.com/albertms10/music_notes/pull/286)

### Dependabot updates

- build(pubspec): ⬆️ bump `test` to 1.25.0 [#326](https://github.com/albertms10/music_notes/pull/326)

**Full Changelog**: [`v0.13.0...v0.14.0`](https://github.com/albertms10/music_notes/compare/v0.13.0...v0.14.0)

## 0.13.0

- fix(note)!: 💥 remove `semitones` chromatic modulo [#265](https://github.com/albertms10/music_notes/pull/265)
- feat(positioned_note): ✨ add respelling methods [#266](https://github.com/albertms10/music_notes/pull/266)
- feat(frequency)!: ✨ improve `closestPositionedNote` enharmonic spelling [#267](https://github.com/albertms10/music_notes/pull/267)
- feat(frequency): ✨ add `harmonics` related methods [#268](https://github.com/albertms10/music_notes/pull/268)
- feat(frequency): ✨ add `displayString` extension method on `ClosestPositionedNote` [#269](https://github.com/albertms10/music_notes/pull/269)
- docs(README): 📖 update recently added methods [#270](https://github.com/albertms10/music_notes/pull/270)
- feat(positioned_note): ✨ rename frequency method and expose `tuningSystem` [#271](https://github.com/albertms10/music_notes/pull/271)
- feat(interval)!: ✨ include `notes` in `distanceBetween` record [#272](https://github.com/albertms10/music_notes/pull/272)
- docs(README): 📖 fix CI badge [#277](https://github.com/albertms10/music_notes/pull/277)
- refactor(chordable): ♻️ expect a `Set` for `replaceSizes` [#280](https://github.com/albertms10/music_notes/pull/280)
- perf(scalable): ⚡️ rewrite extension methods to return `Iterable` [#281](https://github.com/albertms10/music_notes/pull/281)
- refactor(scalable): ♻️ override `difference` and implement in `PitchClass` [#283](https://github.com/albertms10/music_notes/pull/283)
- refactor(interval_class): ♻️ rewrite `Interval.fromSemitonesQuality` as `resolveClosestSpelling` [#284](https://github.com/albertms10/music_notes/pull/284)
- docs(note): 📖 improve overall methods documentation [#288](https://github.com/albertms10/music_notes/pull/288)
- refactor(interval): ♻️ call `fromDelta` in `fromSemitones` constructor [#289](https://github.com/albertms10/music_notes/pull/289)
- refactor(quality): ♻️ move `fromInterval` into `Interval.fromQualityDelta` [#290](https://github.com/albertms10/music_notes/pull/290)
- feat(note): ✨ add `isEnharmonicWith` method [#291](https://github.com/albertms10/music_notes/pull/291)
- refactor(test): ♻️ create a `SplayTreeSet` of a Set instead of a List [#292](https://github.com/albertms10/music_notes/pull/292)
- refactor(int_extension): ♻️ extract `nonZeroSign` method [#293](https://github.com/albertms10/music_notes/pull/293)
- docs(positioned_note): 📖 address documentation examples [#295](https://github.com/albertms10/music_notes/pull/295)
- perf(key_signature): ⚡️ remove unneeded variable declaration in `tonality` [#294](https://github.com/albertms10/music_notes/pull/294)
- docs: 📖 remove type parameter references in doc comments [#297](https://github.com/albertms10/music_notes/pull/297)
- docs(note): 📖 use regular comments for variables [#298](https://github.com/albertms10/music_notes/pull/298)
- feat(tuning): ✨ introduce new `Ratio`, `Cent` and move `.cents` to former class [#300](https://github.com/albertms10/music_notes/pull/300)
- refactor(tuning_system)!: ♻️ move `referenceNote` to `TuningSystem` [#301](https://github.com/albertms10/music_notes/pull/301)
- feat(tuning)!: 💥 add `PythagoreanTuning` tuning system [#273](https://github.com/albertms10/music_notes/pull/273)

### Dependabot updates

- chore(deps): ⬆️ bump actions/cache from 3.3.1 to 3.3.2 [#274](https://github.com/albertms10/music_notes/pull/274)
- chore(deps): ⬆️ bump coverallsapp/github-action from 2.2.1 to 2.2.3 [#275](https://github.com/albertms10/music_notes/pull/275)
- chore(deps): ⬆️ bump actions/checkout from 3.6.0 to 4.0.0 [#276](https://github.com/albertms10/music_notes/pull/276)
- chore(deps): ⬆️ bump dart-lang/setup-dart from 1.5.0 to 1.5.1 [#278](https://github.com/albertms10/music_notes/pull/278)
- chore(deps): ⬆️ bump actions/checkout from 4.0.0 to 4.1.0 [#279](https://github.com/albertms10/music_notes/pull/279)
- chore(deps): ⬆️ bump dart-lang/setup-dart from 1.5.1 to 1.6.0 [#296](https://github.com/albertms10/music_notes/pull/296)
- chore(deps): ⬆️ bump actions/checkout from 4.1.0 to 4.1.1 [#299](https://github.com/albertms10/music_notes/pull/299)

**Full Changelog**: [`v0.12.0...v0.13.0`](https://github.com/albertms10/music_notes/compare/v0.12.0...v0.13.0)

## 0.12.0

- ⚡️ perf(chord_pattern): call `sort` instead of creating a `SplayTreeSet` [#232](https://github.com/albertms10/music_notes/pull/232)
- ♻️ refactor(chord): reuse `augmented`, `major`, `minor`, `diminished` methods from `ChordPattern` [#233](https://github.com/albertms10/music_notes/pull/233)
- ♻️ refactor(scalable): extract private `_ScalableIterable` extension [#234](https://github.com/albertms10/music_notes/pull/234)
- 📖 docs(music_notes): add library-level documentation comment [#235](https://github.com/albertms10/music_notes/pull/235)
- ♻️ refactor: sort members following `diminished..augmented` order [#236](https://github.com/albertms10/music_notes/pull/236)
- 📖 docs: add full public member API documentation [#237](https://github.com/albertms10/music_notes/pull/237)
- ✨ feat(interval)!: simplify `toString` and `Quality.abbreviation` [#238](https://github.com/albertms10/music_notes/pull/238)
- 🥅 feat(quality): strengthen `parse` exception cases [#239](https://github.com/albertms10/music_notes/pull/239)
- 🥅 feat(positioned_note): strengthen `parse` exception cases [#240](https://github.com/albertms10/music_notes/pull/240)
- ♻️ refactor(iterable): rename `comparator` variable [#241](https://github.com/albertms10/music_notes/pull/241)
- ♻️ refactor(positioned_note): extract `octave` variable in `parse` to improve readability [#242](https://github.com/albertms10/music_notes/pull/242)
- ✨ refactor(pitch_class)!: rename `EnharmonicNote` → `PitchClass` [#244](https://github.com/albertms10/music_notes/pull/244)
- ✨ feat(pitch_class): add `integerNotation` getter [#245](https://github.com/albertms10/music_notes/pull/245)
- ✨ feat(pitch_class): move modulo operation to the constructor [#246](https://github.com/albertms10/music_notes/pull/246)
- ✨ feat(interval_class)!: rename `EnharmonicInterval` → `IntervalClass` [#247](https://github.com/albertms10/music_notes/pull/247)
- ♻️ refactor(int_extension): simplify modulo methods [#249](https://github.com/albertms10/music_notes/pull/249)
- ♻️ refactor(enharmonic): remove unnecessary interface [#250](https://github.com/albertms10/music_notes/pull/250)
- 💥 feat(tuning_system): generalize `cents` method expecting `ratio` instead of `semitones` [#251](https://github.com/albertms10/music_notes/pull/251)
- 🚀 feat(frequency): add `closestPositionedNote` method [#252](https://github.com/albertms10/music_notes/pull/252)
- ♻️ refactor(positioned_note): rename `equalTemperamentFrequency` reference parameters consistently [#253](https://github.com/albertms10/music_notes/pull/253)
- ✨ feat: add `toPitchClass` and `toIntervalClass` methods [#254](https://github.com/albertms10/music_notes/pull/254)
- ♻️ refactor(base_note): rewrite `transposeBySize` using `incrementBy` [#255](https://github.com/albertms10/music_notes/pull/255)
- ♻️ refactor(chord_pattern): rename `fromIntervalSteps` factory constructor [#257](https://github.com/albertms10/music_notes/pull/257)
- ♻️ refactor(scalable): rename `_intervalSteps` getters from `_ScalableIterable` [#258](https://github.com/albertms10/music_notes/pull/258)
- ⚡️ perf(interval_class): remove unnecessary `abs` call on `operator *` [#259](https://github.com/albertms10/music_notes/pull/259)
- ✨ feat(accidental): add `operator +-` [#260](https://github.com/albertms10/music_notes/pull/260)
- ⚡️ perf: rewrite `map` calls in favor of `for` loops [#261](https://github.com/albertms10/music_notes/pull/261)
- 📖 docs(README): write comprehensive API walkthrough [#243](https://github.com/albertms10/music_notes/pull/243)

### Dependabot updates

- ⬆️ chore(deps): bump actions/checkout from 3.5.3 to 3.6.0 [#263](https://github.com/albertms10/music_notes/pull/263)

**Full Changelog**: [`v0.11.1...v0.12.0`](https://github.com/albertms10/music_notes/compare/v0.11.1...v0.12.0)

## 0.11.1

- 📌 chore(pubspec): downgrade `test` to 1.24.1 to keep Flutter compatibility [#231](https://github.com/albertms10/music_notes/pull/231)

**Full Changelog**: [`v0.11.0...v0.11.1`](https://github.com/albertms10/music_notes/compare/v0.11.0...v0.11.1)

## 0.11.0

- 📄 docs(README): update license badge [#207](https://github.com/albertms10/music_notes/pull/207)
- 📖 docs(README): fix typo in C♯ example [#208](https://github.com/albertms10/music_notes/pull/208)
- ♻️ refactor(positioned_note)!: make `octave` argument required [#209](https://github.com/albertms10/music_notes/pull/209)
- 📖 docs(note): update missing `inOctave` examples [#210](https://github.com/albertms10/music_notes/pull/210)
- ♻️ refactor: use `incrementBy` method [#211](https://github.com/albertms10/music_notes/pull/211)
- ♻️ refactor(interval): remove redundant `Scalable<T>` types [#212](https://github.com/albertms10/music_notes/pull/212)
- 📖 docs(scale): fix wrong `functionChord` examples [#213](https://github.com/albertms10/music_notes/pull/213)
- ✨ feat(note): add `respellByBaseNoteDistance` method [#214](https://github.com/albertms10/music_notes/pull/214)
- ✨ feat(enharmonic): allow providing `distance` to `spellings` [#215](https://github.com/albertms10/music_notes/pull/215)
- ♻️ refactor(accidental): extract parsable symbols from `parse` [#216](https://github.com/albertms10/music_notes/pull/216)
- ✨ feat(enharmonic): remove semitones from `toString` output [#218](https://github.com/albertms10/music_notes/pull/218)
- ✨ feat(enharmonic): use pipe `|` in `toString` output [#219](https://github.com/albertms10/music_notes/pull/219)
- 💥 refactor(note)!: rewrite semitones starting from 0 instead of 1 [#220](https://github.com/albertms10/music_notes/pull/220)
- ⚡ perf(positioned_note): extract `parse` expressions to static finals [#221](https://github.com/albertms10/music_notes/pull/221)
- 💥 feat(interval)!: move `isDissonant` getter from `IntervalSizeExtension` [#222](https://github.com/albertms10/music_notes/pull/222)
- ♻️ refactor(interval)!: move `inverted` logic from `IntervalSizeExtension` [#223](https://github.com/albertms10/music_notes/pull/223)
- ♻️ refactor(interval): move `simplified` from `IntervalSizeExtension` [#224](https://github.com/albertms10/music_notes/pull/224)
- ♻️ refactor(interval): move `isCompound` from `IntervalSizeExtension` [#225](https://github.com/albertms10/music_notes/pull/225)
- 📖 docs(interval_size_extension): improve `semitones` and `isPerfect` comments [#226](https://github.com/albertms10/music_notes/pull/226)
- 📌 chore(pubspec): downgrade `collection` to 1.17.1 to keep Flutter compatibility [#228](https://github.com/albertms10/music_notes/pull/228)
- ➖ chore(pubspec): remove `dart_code_metrics` dependency [#229](https://github.com/albertms10/music_notes/pull/229)
- 💥 refactor(interval)!: rewrite `IntervalSizeExtension` methods as private [#227](https://github.com/albertms10/music_notes/pull/227)

### Dependabot updates

- ⬆️ chore(deps): bump coverallsapp/github-action from 2.2.0 to 2.2.1 [#217](https://github.com/albertms10/music_notes/pull/217)

**Full Changelog**: [`v0.10.1...v0.11.0`](https://github.com/albertms10/music_notes/compare/v0.10.1...v0.11.0)

## 0.10.1

- ✨ feat(interval): take `distance` sign into account in `circleFrom` [#199](https://github.com/albertms10/music_notes/pull/199)
- ✨ feat(enharmonic_note): add pitch-class multiplication operator [#200](https://github.com/albertms10/music_notes/pull/200)
- ♻️ refactor(base_note): rename `fromSemitones` static method [#201](https://github.com/albertms10/music_notes/pull/201)
- 🔥 refactor(enharmonic_note)!: remove `shortestFifthsDistance` methods [#202](https://github.com/albertms10/music_notes/pull/202)
- ✨ feat(tuning_system): add class and test cases [#203](https://github.com/albertms10/music_notes/pull/203)
- 📖 docs(README): write main library documentation [#204](https://github.com/albertms10/music_notes/pull/204)
- 📌 chore(pubspec): pin dependencies versions [#205](https://github.com/albertms10/music_notes/pull/205)
- 📖 docs(README): remove publisher badge [#206](https://github.com/albertms10/music_notes/pull/206)

**Full Changelog**: [`v0.10.0...v0.10.1`](https://github.com/albertms10/music_notes/compare/v0.10.0...v0.10.1)

## 0.10.0

**Note:** the published versioned erroneously contained some changes from 0.10.1.

- ♻️ refactor(interval): rename shorter static constants [#177](https://github.com/albertms10/music_notes/pull/177)
- ✨ feat(string_extension): add `isUpperCase` and `isLowerCase` getters [#179](https://github.com/albertms10/music_notes/pull/179)
- ✨ feat: add `parse` factory constructors to Note and Interval classes [#180](https://github.com/albertms10/music_notes/pull/180)
- 🔧 chore(dependabot): add configuration file [#181](https://github.com/albertms10/music_notes/pull/181)
- 💥 feat(key_signature)!: rewrite based on a list of Notes [#184](https://github.com/albertms10/music_notes/pull/184)
- ♻️ refactor(key_signature): declare static `empty` constant [#185](https://github.com/albertms10/music_notes/pull/185)
- ♻️ refactor(key_signature): simplify tonality methods [#186](https://github.com/albertms10/music_notes/pull/186)
- 🐛 fix(note): return correct distance for extreme Note spellings [#187](https://github.com/albertms10/music_notes/pull/187)
- ⚡ perf(interval): rewrite `distanceBetween` method avoiding unnecessary iterations [#188](https://github.com/albertms10/music_notes/pull/188)
- ♻️ refactor(base_note): rewrite `parse` method using `byName` [#189](https://github.com/albertms10/music_notes/pull/189)
- ✨ feat(note): add respelling methods [#190](https://github.com/albertms10/music_notes/pull/190)
- ✨ feat(note): add `respelledSimple` getter [#191](https://github.com/albertms10/music_notes/pull/191)
- ✨ feat(int_extension): add `incrementBy` method [#192](https://github.com/albertms10/music_notes/pull/192)
- ✨ feat(interval): add `circleFrom` and related methods on `Note` [#193](https://github.com/albertms10/music_notes/pull/193)
- ✨ feat(interval): add `respellBySize` method [#195](https://github.com/albertms10/music_notes/pull/195)
- ✨ feat(key_signature)!: rewrite `toString` method [#196](https://github.com/albertms10/music_notes/pull/196)
- ♻️ refactor(analysis): enable ignored lints [#197](https://github.com/albertms10/music_notes/pull/197)
- ✨ feat(interval): rewrite distance methods expecting `Scalable` arguments [#198](https://github.com/albertms10/music_notes/pull/198)

### Dependabot updates

- ⬆️ chore(deps): bump actions/checkout from 3.5.0 to 3.5.3 [#182](https://github.com/albertms10/music_notes/pull/182)
- ⬆️ chore(deps): bump coverallsapp/github-action from 2.0.0 to 2.2.0 [#183](https://github.com/albertms10/music_notes/pull/183)

**Full Changelog**: [`v0.9.0...v0.10.0`](https://github.com/albertms10/music_notes/compare/v0.9.0...v0.10.0)

## 0.9.0

- fix(scale): take descending items into account for `hashCode` [#151](https://github.com/albertms10/music_notes/pull/151)
- test(note): add test cases for `sharp`, `flat`, `major`, `minor` getters [#152](https://github.com/albertms10/music_notes/pull/152)
- test(enharmonic): move each `toString` test cases to implementation [#153](https://github.com/albertms10/music_notes/pull/153)
- feat(harmony): add `Chord` and `ChordPattern` classes [#154](https://github.com/albertms10/music_notes/pull/154)
- fix(positioned_note): use correct `hashCode` values [#155](https://github.com/albertms10/music_notes/pull/155)
- fix(interval_size_extension): return correct `semitones` for large intervals [#156](https://github.com/albertms10/music_notes/pull/156)
- fix(note): correctly handle compound intervals in `transposeBy` [#157](https://github.com/albertms10/music_notes/pull/157)
- feat(chord): implement `Transposable` [#158](https://github.com/albertms10/music_notes/pull/158)
- feat(chord_pattern): add `intervalSteps` factory constructor [#159](https://github.com/albertms10/music_notes/pull/159)
- test(interval): add compound intervals test cases for `semitones` [#160](https://github.com/albertms10/music_notes/pull/160)
- feat(interval): add `simplified` getter [#161](https://github.com/albertms10/music_notes/pull/161)
- refactor: rename `from` → `on` [#162](https://github.com/albertms10/music_notes/pull/162)
- feat(note): add Chord triad getters [#163](https://github.com/albertms10/music_notes/pull/163)
- feat(scale): add `ScaleDegree` class and methods on `Scale` [#164](https://github.com/albertms10/music_notes/pull/164)
- feat(chord_pattern): add `fromQuality` factory constructor [#165](https://github.com/albertms10/music_notes/pull/165)
- feat(scale_degree): add `raised`, `lowered`, `major`, and `minor` getters [#167](https://github.com/albertms10/music_notes/pull/167)
- feat(scale_pattern): take `ScaleDegree.quality` into account in `degreePattern` [#166](https://github.com/albertms10/music_notes/pull/166)
- feat(scale_pattern): add `fromChordPattern` factory constructor [#168](https://github.com/albertms10/music_notes/pull/168)
- feat(scale): add `degree` and rename `degreeChord` methods [#169](https://github.com/albertms10/music_notes/pull/169)
- refactor(scale): rename `items` → `degrees` [#170](https://github.com/albertms10/music_notes/pull/170)
- refactor(scale_degree): rename `degree` → `ordinal` [#171](https://github.com/albertms10/music_notes/pull/171)
- refactor(scale_pattern): extract helper functions to simplify `degreePattern` method [#172](https://github.com/albertms10/music_notes/pull/172)
- feat(chord_pattern): add `augmented`, `major`, `minor`, and `diminished` getters [#173](https://github.com/albertms10/music_notes/pull/173)
- fix(chord): correctly identify compound intervals in `pattern` getter [#174](https://github.com/albertms10/music_notes/pull/174)
- feat(harmony): make `Chord` implement extracted `Chordable` mixin methods [#175](https://github.com/albertms10/music_notes/pull/175)
- chore(pubspec): bump version 0.9.0 [#178](https://github.com/albertms10/music_notes/pull/178)
- feat(harmonic_function): add class and `Scale` method [#176](https://github.com/albertms10/music_notes/pull/176)

**Full Changelog**: [`v0.8.0...v0.9.0`](https://github.com/albertms10/music_notes/compare/v0.8.0...v0.9.0)

## 0.8.0

- refactor(scale_pattern): rename class [#128](https://github.com/albertms10/music_notes/pull/128)
- refactor(scale_pattern): rename test file [#129](https://github.com/albertms10/music_notes/pull/129)
- feat(frequency): add `+`, `-`, `*`, `/` operators [#130](https://github.com/albertms10/music_notes/pull/130)
- test(interval_size_extension): add test cases for large `semitones` [#131](https://github.com/albertms10/music_notes/pull/131)
- feat(interval): show quality semitones on `null` abbreviation in `toString` [#133](https://github.com/albertms10/music_notes/pull/133)
- feat(base_note)!: remove support for `intervalSize` `isDescending` argument [#134](https://github.com/albertms10/music_notes/pull/134)
- feat(scalable): add abstract interface with `interval` method [#135](https://github.com/albertms10/music_notes/pull/135)
- feat(interval): add `+` operator [#136](https://github.com/albertms10/music_notes/pull/136)
- fix(scale_pattern): check for `descendingIntervalSteps` in `==` [#137](https://github.com/albertms10/music_notes/pull/137)
- feat(scale_pattern): include descending steps in `toString` [#138](https://github.com/albertms10/music_notes/pull/138)
- fix(scale_pattern): return `mirrored` Scale with descending steps [#141](https://github.com/albertms10/music_notes/pull/141)
- feat(scale)!: add new class with `pattern` and `reversed` getters [#139](https://github.com/albertms10/music_notes/pull/139)
- fix(scale_pattern): return correct descending `PositionedNote` scale in `from` [#142](https://github.com/albertms10/music_notes/pull/142)
- refactor(scalable): move to root `lib` directory [#143](https://github.com/albertms10/music_notes/pull/143)
- feat(enharmonic_interval): add `isDescending`, `descending` methods [#144](https://github.com/albertms10/music_notes/pull/144)
- test(enharmonic_interval): add test cases for `isDescending`, `descending` methods [#145](https://github.com/albertms10/music_notes/pull/145)
- chore(pubspec): bump versions as of `very_good_analysis` 5.0.0+1 [#146](https://github.com/albertms10/music_notes/pull/146)
- feat(positioned_note): add reference `note` for `equalTemperamentFrequency` [#147](https://github.com/albertms10/music_notes/pull/147)
- refactor(note): rename `fifthsDistanceWith` method [#148](https://github.com/albertms10/music_notes/pull/148)
- test(note): reference failing tests related to #149 [#150](https://github.com/albertms10/music_notes/pull/150)

**Full Changelog**: [`v0.7.0...v0.8.0`](https://github.com/albertms10/music_notes/compare/v0.7.0...v0.8.0)

## 0.7.0

- refactor: Extract Frequency [#112](https://github.com/albertms10/music_notes/pull/112)
- refactor: normalize `isNegative` condition [#116](https://github.com/albertms10/music_notes/pull/116)
- feat(frequency): override `toString`, `==`, `hashCode`, and `compareTo` methods [#117](https://github.com/albertms10/music_notes/pull/117)
- feat(frequency): assert positive `hertz` value [#118](https://github.com/albertms10/music_notes/pull/118)
- refactor(positioned_note)!: use `Frequency` as a reference [#119](https://github.com/albertms10/music_notes/pull/119)
- refactor: remove `MusicItem` interface [#115](https://github.com/albertms10/music_notes/pull/115)
- refactor: PositionedNote composition with Note instead of inheritance [#113](https://github.com/albertms10/music_notes/pull/113)
- test(positioned_note): add more test cases for `semitonesFromRootHeight` [#120](https://github.com/albertms10/music_notes/pull/120)
- refactor(transposable): add generic constraint [#99](https://github.com/albertms10/music_notes/pull/99)
- refactor(base_notes): rename `Notes` → `BaseNote` [#121](https://github.com/albertms10/music_notes/pull/121)
- refactor(enharmonic_note): remove redirecting method on `enharmonicIntervalDistance` [#122](https://github.com/albertms10/music_notes/pull/122)
- refactor!: consistently rename `isDescending` [#123](https://github.com/albertms10/music_notes/pull/123)
- feat(note): add Tonality `major` and `minor` getters [#124](https://github.com/albertms10/music_notes/pull/124)
- refactor(base_note): rename `transposeBySize` method [#125](https://github.com/albertms10/music_notes/pull/125)
- docs(note): migrate missing `PositionedNote` documentation [#126](https://github.com/albertms10/music_notes/pull/126)
- feat(note): add `sharp`, `flat` getters [#127](https://github.com/albertms10/music_notes/pull/127)

**Full Changelog**: [`v0.6.0...v0.7.0`](https://github.com/albertms10/music_notes/compare/v0.6.0...v0.7.0)

## 0.6.0

- refactor(interval): extract and reuse `_sizeAbsShift` getter [#97](https://github.com/albertms10/music_notes/pull/97)
- refactor(mode): rename `compare` static method [#98](https://github.com/albertms10/music_notes/pull/98)
- feat(positioned_note)!: allow passing `a4Hertzs` to `isHumanAudibleAt` [#100](https://github.com/albertms10/music_notes/pull/100)
- feat(note): add `circleOfFifthsDistance` getter [#101](https://github.com/albertms10/music_notes/pull/101)
- feat(note): add `compareByFifthsDistance` static comparator [#102](https://github.com/albertms10/music_notes/pull/102)
- feat(interval): add `descending` method [#103](https://github.com/albertms10/music_notes/pull/103)
- feat(scale): add `descendingIntervalSteps` [#104](https://github.com/albertms10/music_notes/pull/104)
- chore: bump versions as of Dart SDK 3.0 [#105](https://github.com/albertms10/music_notes/pull/105)

**Full Changelog**: [`v0.5.1...v0.6.0`](https://github.com/albertms10/music_notes/compare/v0.5.1...v0.6.0)

## 0.5.1

- feat(scale): allow passing `EnharmonicNote` to `fromNote` [#91](https://github.com/albertms10/music_notes/pull/91)
- fix(enharmonic_interval): handle descending intervals in `items` [#92](https://github.com/albertms10/music_notes/pull/92)
- refactor(quality)!: rename `double` to `doubly` [#93](https://github.com/albertms10/music_notes/pull/93)
- refactor(enharmonic): rename `items` → `spellings` [#94](https://github.com/albertms10/music_notes/pull/94)
- fix(interval_size_extension): address `simplified` compound interval sizes [#95](https://github.com/albertms10/music_notes/pull/95)
- feat(interval): show simplified interval in `toString` [#96](https://github.com/albertms10/music_notes/pull/96)

**Full Changelog**: [`v0.5.0...v0.5.1`](https://github.com/albertms10/music_notes/compare/v0.5.0...v0.5.1)

## 0.5.0

- feat(enharmonic_interval): suppress semitones limit [#64](https://github.com/albertms10/music_notes/pull/64)
- perf(interval): simplify `isPerfect` logic [#65](https://github.com/albertms10/music_notes/pull/65)
- refactor(accidental): rewrite `symbol` getter using explanatory variables [#66](https://github.com/albertms10/music_notes/pull/66)
- feat(int_interval_extension): allow compound intervals in `fromSemitones` [#67](https://github.com/albertms10/music_notes/pull/67)
- feat(enharmonic_interval)!: rewrite distance `semitones` starting from 0 [#68](https://github.com/albertms10/music_notes/pull/68)
- refactor(enharmonic_interval): change `Transposable` with add/subtract operators [#69](https://github.com/albertms10/music_notes/pull/69)
- feat(note): implement `Transposable` [#70](https://github.com/albertms10/music_notes/pull/70)
- refactor(interval): add static const constructors [#71](https://github.com/albertms10/music_notes/pull/71)
- feat(scale): add class and `fromNote` method [#72](https://github.com/albertms10/music_notes/pull/72)
- feat(interval)!: change `descending` with negative `size` [#73](https://github.com/albertms10/music_notes/pull/73)
- refactor(interval_size_extension): rename extension [#74](https://github.com/albertms10/music_notes/pull/74)
- feat(interval): add negation and multiplication operators [#75](https://github.com/albertms10/music_notes/pull/75)
- feat(key_signature): throw an assertion error when passing a wrong `Accidental` [#77](https://github.com/albertms10/music_notes/pull/77)
- feat(scale): add `mirrored`, `name` methods and override `==` [#79](https://github.com/albertms10/music_notes/pull/79)
- feat(mode)!: rewrite `Mode` enums [#78](https://github.com/albertms10/music_notes/pull/78)
- feat(tonality): add `scaleNotes` getter [#80](https://github.com/albertms10/music_notes/pull/80)
- feat(positioned_note): override `transposeBy` method [#81](https://github.com/albertms10/music_notes/pull/81)
- docs: add Wikipedia links to `Scale` and `Mode` [#82](https://github.com/albertms10/music_notes/pull/82)
- feat(mode)!: use `brightness` as the Dorian Brightness Quotient [#83](https://github.com/albertms10/music_notes/pull/83)
- refactor(positioned_note): improve `helmholtzName` getter legibility [#84](https://github.com/albertms10/music_notes/pull/84)
- refactor: replace `quiver` package with native `Object.hash` [#85](https://github.com/albertms10/music_notes/pull/85)
- chore(vscode): add `.lock` file association with YAML [#86](https://github.com/albertms10/music_notes/pull/86)
- feat(interval): add `isDescending` getter [#87](https://github.com/albertms10/music_notes/pull/87)
- test(interval): add more test cases for descending `Interval` [#76](https://github.com/albertms10/music_notes/pull/76)
- refactor: replace `EnharmonicNote` with `Note` for `transposeBy` [#88](https://github.com/albertms10/music_notes/pull/88)
- fix(key_signature): use XOR in 0 accidentals assertions [#89](https://github.com/albertms10/music_notes/pull/89)
- refactor(note): rewrite `fromRawAccidentals` into `KeySignature.majorNote` [#90](https://github.com/albertms10/music_notes/pull/90)

**Full Changelog**: [`v0.4.0...v0.5.0`](https://github.com/albertms10/music_notes/compare/v0.4.0...v0.5.0)

## 0.4.0

- test: consistently group test cases by content [#22](https://github.com/albertms10/music_notes/pull/22)
- fix(enharmonic_note): address edge cases for `items` getter [#23](https://github.com/albertms10/music_notes/pull/23)
- feat(accidental): bring `increment` method back [#24](https://github.com/albertms10/music_notes/pull/24)
- test: add test cases for `toString` methods [#25](https://github.com/albertms10/music_notes/pull/25)
- test(key_signature): add test cases for `tonalities` getter [#26](https://github.com/albertms10/music_notes/pull/26)
- test(key_signature): add test cases for `fromDistance` method [#27](https://github.com/albertms10/music_notes/pull/27)
- feat: implement and test Comparable [#28](https://github.com/albertms10/music_notes/pull/28)
- feat(accidental): show positive sign in `toString` [#29](https://github.com/albertms10/music_notes/pull/29)
- feat(key_signature): remove × sign in `toString` [#30](https://github.com/albertms10/music_notes/pull/30)
- test(music): add test case for `circleOfFifths` [#31](https://github.com/albertms10/music_notes/pull/31)
- test(enharmonic): add test cases for `toString` [#32](https://github.com/albertms10/music_notes/pull/32)
- test(interval): add test cases for `toString` [#33](https://github.com/albertms10/music_notes/pull/33)
- test(enharmonic_interval): add test cases for `transposeBy` [#34](https://github.com/albertms10/music_notes/pull/34)
- refactor(music_item): implement `Comparable` and mark as immutable [#35](https://github.com/albertms10/music_notes/pull/35)
- test: compare `.hashCode` Set as a List [#36](https://github.com/albertms10/music_notes/pull/36)
- feat(tonality): improve `compareTo` sorting by note and mode [#37](https://github.com/albertms10/music_notes/pull/37)
- test(interval): add test cases for interval-related members [#39](https://github.com/albertms10/music_notes/pull/39)
- feat(intervals): add `isCompound` getter [#40](https://github.com/albertms10/music_notes/pull/40)
- test(intervals): add test cases for `fromSemitones` [#41](https://github.com/albertms10/music_notes/pull/41)
- feat!: rewrite `Qualities` enum with proper `Quality` class [#42](https://github.com/albertms10/music_notes/pull/42)
- feat(intervals): add `isDissonant` getter [#43](https://github.com/albertms10/music_notes/pull/43)
- refactor(enharmonic_interval): add static const constructors [#44](https://github.com/albertms10/music_notes/pull/44)
- feat(interval)!: replace `Intervals` enum with `int` value [#45](https://github.com/albertms10/music_notes/pull/45)
- docs: document `Quality` class and rewrite Example consistently [#46](https://github.com/albertms10/music_notes/pull/46)
- feat(accidental): add `name` getter [#47](https://github.com/albertms10/music_notes/pull/47)
- feat(enharmonic_note): add `toClosestNote` method [#48](https://github.com/albertms10/music_notes/pull/48)
- fix(note): simplify `fromRawAccidentals` accidental increment [#49](https://github.com/albertms10/music_notes/pull/49)
- refactor(quality): move `qualityFromDelta` to `Quality.fromInterval` factory constructor [#51](https://github.com/albertms10/music_notes/pull/51)
- refactor(interval): move `EnharmonicInterval.fromDesiredSemitones` [#52](https://github.com/albertms10/music_notes/pull/52)
- test(interval): add test cases for `inverted` [#53](https://github.com/albertms10/music_notes/pull/53)
- refactor(notes): address `intervalSize` descending logic [#54](https://github.com/albertms10/music_notes/pull/54)
- test(note): add test cases for `difference` [#55](https://github.com/albertms10/music_notes/pull/55)
- refactor(tonality): add static const constructors [#56](https://github.com/albertms10/music_notes/pull/56)
- feat(note): add `octave` member [#57](https://github.com/albertms10/music_notes/pull/57)
- feat(note): add scientific and Helmholtz notation getters [#58](https://github.com/albertms10/music_notes/pull/58)
- feat(note): add `equalTemperamentFrequency` [#59](https://github.com/albertms10/music_notes/pull/59)
- feat(note): add `isHumanAudible` method [#60](https://github.com/albertms10/music_notes/pull/60)
- refactor(positioned_note): move `Note` methods to subclass [#61](https://github.com/albertms10/music_notes/pull/61)
- test(tonality): add test cases for `relative`, `keySignature` methods [#62](https://github.com/albertms10/music_notes/pull/62)
- refactor(music_item): remove unnecessary private constructors [#63](https://github.com/albertms10/music_notes/pull/63)

**Full Changelog**: [`v0.3.0...v0.4.0`](https://github.com/albertms10/music_notes/compare/v0.3.0...v0.4.0)

## 0.3.0

- chore: bump versions as of Dart SDK 2.19 [#7](https://github.com/albertms10/music_notes/pull/7)
- refactor(accidental): rewrite new `Accidental` class [#8](https://github.com/albertms10/music_notes/pull/8)
- docs: reference new `Accidental` class instead of enum [#9](https://github.com/albertms10/music_notes/pull/9)
- refactor: make `Accidental.natural` default [#10](https://github.com/albertms10/music_notes/pull/10)
- refactor(enharmonic): rewrite based on `semitones` [#11](https://github.com/albertms10/music_notes/pull/11)
- refactor(notes): rename notes using the English convention [#12](https://github.com/albertms10/music_notes/pull/12)
- refactor(accidental): rename `value` → `semitones` [#13](https://github.com/albertms10/music_notes/pull/13)
- refactor(note): add static const constructors [#14](https://github.com/albertms10/music_notes/pull/14)
- refactor(src): reorganize directories by content [#15](https://github.com/albertms10/music_notes/pull/15)
- refactor: rewrite `enum` members [#16](https://github.com/albertms10/music_notes/pull/16)
- refactor(relative_tonalities): remove class [#17](https://github.com/albertms10/music_notes/pull/17)
- refactor(int_mod_extension): rewrite mod functions into extension methods [#18](https://github.com/albertms10/music_notes/pull/18)
- refactor(note): move fifths distance functions to class methods [#19](https://github.com/albertms10/music_notes/pull/19)
- perf(tests): run tests from index `main.dart` file [#20](https://github.com/albertms10/music_notes/pull/20)
- chore(pubspec): bump version 0.3.0 [#21](https://github.com/albertms10/music_notes/pull/21)

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
- chore(deps): override `meta` v1.6.0 [#3](https://github.com/albertms10/music_notes/pull/3)
- chore(deps): bump versions as of Dart SDK 2.16 [#5](https://github.com/albertms10/music_notes/pull/5)
- refactor(enums): replace `toText` with native `name` getter [#6](https://github.com/albertms10/music_notes/pull/6)

**Full Changelog**: [`v0.1.0...v0.2.0`](https://github.com/albertms10/music_notes/compare/v0.1.0...v0.2.0)

## 0.1.0

Initial implementation of basic and fundamental operations with notes, intervals, tonalities and key signatures.

**Full Changelog**: [`v0.1.0`](https://github.com/albertms10/music_notes/compare/68e419019f708f272fe4278b64a5a6dd5b43778e...v0.1.0)
