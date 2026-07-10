import '../interval/interval.dart';
import '../interval/size.dart';
import '../tuning/equal_temperament.dart';

/// TemplateCandidate typedef.
typedef TemplateCandidate = ({
  List<Interval> intervals,
  List<int> order,
  int sizePenalty,
  int qualityPenalty,
  int templatePriority,
  int span,
});

int _templatePriority(int firstSize) => switch (firstSize) {
  3 => 0,
  2 || 4 => 1,
  _ => 2,
};

int _templateSize(int firstSize, int index) =>
    index == 0 ? firstSize : 5 + (index - 1) * 2;

int _simpleDistance(int a, int b) {
  final diff = (a - b).abs();
  return diff < 7 - diff ? diff : 7 - diff;
}

int _qualityPenalty(Interval interval) {
  final options = switch (interval.size.simple.abs()) {
    3 || 2 || 6 => const [0, 1],
    5 || 4 || 7 => const [-1, 0, 1],
    _ => const [0],
  };

  return options
      .map((value) => (interval.quality.semitones - value).abs())
      .reduce((a, b) => a < b ? a : b);
}

/// Whether a candidate is a better normalization than the current best.
bool isBetterNormalizationScore({
  required int sizePenalty,
  required int qualityPenalty,
  required int templatePriority,
  required int span,
  required int bestSizePenalty,
  required int bestQualityPenalty,
  required int bestTemplatePriority,
  required int bestSpan,
}) =>
    sizePenalty < bestSizePenalty ||
    (sizePenalty == bestSizePenalty && qualityPenalty < bestQualityPenalty) ||
    (sizePenalty == bestSizePenalty &&
        qualityPenalty == bestQualityPenalty &&
        templatePriority < bestTemplatePriority) ||
    (sizePenalty == bestSizePenalty &&
        qualityPenalty == bestQualityPenalty &&
        templatePriority == bestTemplatePriority &&
        span < bestSpan);

/// Normalizes a list of [Interval]s to the closest match among chord templates.
TemplateCandidate normalizeIntervalsByTemplate(List<Interval> intervals) {
  TemplateCandidate? bestTemplate;

  for (final firstSize in const [3, 2, 4]) {
    final remaining = intervals.indexed
        .map((entry) => (index: entry.$1, interval: entry.$2))
        .toList();
    final orderedIntervals = <Interval>[];
    final order = <int>[];
    var sizePenalty = 0;
    var totalQualityPenalty = 0;

    for (var i = 0; i < intervals.length; i++) {
      final targetSize = _templateSize(firstSize, i);
      final targetSimple = Size(targetSize).simple.abs();

      remaining.sort((a, b) {
        final promotedA = Interval.fromSizeAndSemitones(
          Size(targetSize),
          (a.interval.semitones % chromaticDivisions) +
              ((targetSize - 1) ~/ 7) * chromaticDivisions,
        );
        final promotedB = Interval.fromSizeAndSemitones(
          Size(targetSize),
          (b.interval.semitones % chromaticDivisions) +
              ((targetSize - 1) ~/ 7) * chromaticDivisions,
        );
        final distanceA = _simpleDistance(
          a.interval.size.simple.abs(),
          targetSimple,
        );
        final distanceB = _simpleDistance(
          b.interval.size.simple.abs(),
          targetSimple,
        );

        if (distanceA != distanceB) return distanceA.compareTo(distanceB);

        final qualityA = _qualityPenalty(promotedA);
        final qualityB = _qualityPenalty(promotedB);
        if (qualityA != qualityB) return qualityA.compareTo(qualityB);

        return promotedA.semitones.compareTo(promotedB.semitones);
      });

      final chosen = remaining.removeAt(0);
      final promoted = Interval.fromSizeAndSemitones(
        Size(targetSize),
        (chosen.interval.semitones % chromaticDivisions) +
            ((targetSize - 1) ~/ 7) * chromaticDivisions,
      );

      sizePenalty += _simpleDistance(
        chosen.interval.size.simple.abs(),
        targetSimple,
      );
      totalQualityPenalty += _qualityPenalty(promoted);
      order.add(chosen.index);
      orderedIntervals.add(promoted);
    }

    final candidate = (
      intervals: orderedIntervals,
      order: order,
      sizePenalty: sizePenalty,
      qualityPenalty: totalQualityPenalty,
      templatePriority: _templatePriority(firstSize),
      span: orderedIntervals.isEmpty ? 0 : orderedIntervals.last.semitones,
    );

    if (bestTemplate == null ||
        isBetterNormalizationScore(
          sizePenalty: candidate.sizePenalty,
          qualityPenalty: candidate.qualityPenalty,
          templatePriority: candidate.templatePriority,
          span: candidate.span,
          bestSizePenalty: bestTemplate.sizePenalty,
          bestQualityPenalty: bestTemplate.qualityPenalty,
          bestTemplatePriority: bestTemplate.templatePriority,
          bestSpan: bestTemplate.span,
        )) {
      bestTemplate = candidate;
    }
  }

  return bestTemplate!;
}
