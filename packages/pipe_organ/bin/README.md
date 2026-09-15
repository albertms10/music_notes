# organ_frequency_chart

Two in-terminal charts for a `music_notes` organ **Stop Disposition**
(`List<PipeRow>`, from the [`organ` branch][branch]):

1. **Frequency distribution** — a log-frequency histogram of every pipe
   sounded across a keyboard, rendered with [`artisanal`][artisanal]'s
   `createBarChart`.
2. **Pitch vs. frequency ("breaks") chart** — x-axis is the keyboard key
   (e.g. `C2` → `G6`), y-axis is frequency in Hz on a log scale (gridlines
   at `100 Hz`, `1.000 Hz`, `10.000 Hz`, …), one line per rank. Wherever
   two or more ranks land on the exact same pitch — e.g. a mixture
   repeating a foot length within a row to keep the ambitus full near a
   break, like:

   ```
   c''             4′  2 2/3′          2′      1 1/3′  1′
   gis''   5 1/3′  4′  2 2/3′          2′  2′  1 1/3′
   ```

   — the marker is drawn bigger (`⬤` instead of `●`, and bold at three or
   more) instead of silently overlapping, so duplication is something you
   can actually see rather than something a single dot quietly hides.
   Lines are coloured either by breakpoint or by rank position
   (`--color-by breakpoint|rank`, see below). Rendered with a small
   purpose-built ANSI renderer (see *Why chart 2 is hand-rolled* below).

Both charts answer the same underlying question — what does this mixture
actually sound like across the keyboard — from two angles: chart 1 shows
*how many* pipes cluster around which pitch height; chart 2 shows *which
key* produces *which* pitch, rank by rank.

## How it works

For every chromatic key across a keyboard:

1. Find the [`PipeRow`][pipe_row] that applies at that key
   (`StopDisposition.rowFor`).
2. For each rank in that row, transpose *that key* by the rank's
   [`Interval`][interval] (`PipeRow.rankIntervals`, derived from the foot
   length vs. the 8′ reference) to get the rank's actual sounding pitch.
3. Take that pitch's [`Frequency`][frequency] in Hz.

Chart 1 bins every one of those frequencies into equal-width buckets in
log2 (octave) space (`--bins-per-octave` buckets per octave). Chart 2 plots
each `(key, frequency)` pair directly, one polyline per rank, coloured by
which `PipeRow` produced it.

## Why chart 2 is hand-rolled

`package:artisanal`'s public API turned out to be a moving target while
building this: the docs for `charting.dart`'s `BarChartProps` /
`DataSeries` / `AxisOptions` (used for chart 1) were stable and specific
enough to rely on, but its multi-series `LineChartProps` shape wasn't
pinnable from what was available while writing this — and a *different*
`LineChart`, a stateful TUI widget in `package:artisanal/widgets.dart`
(unrelated to the plain print-and-done `charting.dart` functions), kept
surfacing instead. Rather than guess at an unverified signature for a
multi-colour, multi-series chart, chart 2 is self-contained: plain ANSI
colour codes over a character grid, no extra dependency risk. Worth
double-checking both charts against your installed `artisanal` version
before relying on them — none of this could actually be compiled in the
environment that wrote it.

The `pubspec.yaml` also corrects an earlier draft's `artisanal: ^0.6.0` —
that version doesn't exist; `charting.dart` only exists from `0.2.0` on.

## Setup

```yaml
dependencies:
  music_notes:
    git:
      url: https://github.com/albertms10/music_notes.git
      ref: ae330ccf099c21116a996ca40e142deba2a13423 # the `organ` branch commit
  artisanal: ^0.2.0
  args: ^2.5.0
```

```console
$ dart pub get
```

## Usage

```console
$ dart run bin/organ_frequency_chart.dart
```

renders both charts for the Fourniture IV example straight from
`PipeRow.parse`'s doc comment:

```
C2 1 1/3, 1, 2/3
C3 2 2/3, 2, 1 1/3, 1
C4 4, 2 2/3, 2, 1 1/3
C5 5 1/3, 4, 2 2/3, 2
```

Point it at your own disposition file (same format — one breakpoint pitch
followed by comma-separated foot lengths per line), pick which chart(s) to
show, and tune resolution/size:

```console
$ dart run bin/organ_frequency_chart.dart \
    --file great_cymbale.txt \
    --from C1 --to C6 \
    --charts breaks \
    --line-height 30 --width 120 \
    --title 'Great Cymbale VI'
```

```console
$ dart run bin/organ_frequency_chart.dart --help
```

for the full flag list (`--file/-f`, `--from`, `--to`, `--bins-per-octave`,
`--width`, `--height`, `--line-height`, `--title`, `--charts`,
`--color-by`).

`--color-by` controls how the pitch/frequency chart's lines are grouped:

- `breakpoint` (default): one colour per `PipeRow`; every rank of that row
  shares it, so a breakpoint segment reads as one group.
- `rank`: one colour per rank *position* within its row (a row's 1st rank,
  2nd rank, …), so the same "slot" stays the same colour across breaks —
  useful for spotting how a given voice moves, even though which physical
  rank fills that slot can change at each break.

[branch]: https://github.com/albertms10/music_notes/tree/ae330ccf099c21116a996ca40e142deba2a13423/lib/src/organ
[artisanal]: https://pub.dev/packages/artisanal
[pipe_row]: https://github.com/albertms10/music_notes/blob/ae330ccf099c21116a996ca40e142deba2a13423/lib/src/organ/pipe_row.dart
[interval]: https://pub.dev/documentation/music_notes/latest/music_notes/Interval-class.html
[frequency]: https://pub.dev/documentation/music_notes/latest/music_notes/Frequency.html
