import 'analysis.dart';

abstract class TimeNode {}

class TimeNumber extends TimeNode {
  final int value;
  TimeNumber(this.value);
}

class TimeGroup extends TimeNode {
  final int total;
  final TimeNode inner;
  TimeGroup(this.total, this.inner);
}

class TimeSequence extends TimeNode {
  final List<TimeNode> parts;
  TimeSequence(this.parts);
}

class TimeRepeat extends TimeNode {
  final TimeNode left;
  final TimeNode right;
  TimeRepeat(this.left, this.right);
}

enum TimeTokenType { number, dash, V, lParen, rParen }

class TimeToken {
  final TimeTokenType type;
  final String value;
  TimeToken(this.type, this.value);
}

FormParser<TimeNode> number = (state) {
  final t = state.current as TimeToken?;
  if (t is TimeToken && t.type == TimeTokenType.number) {
    return ParseResult(
      TimeNumber(int.parse(t.value)),
      state.advance(),
    );
  }
  return null;
};

FormParser<TimeNode> term = (state) {
  final num = number(state);
  if (num == null) return null;

  var current = num.state;

  // check for grouping: 4(...)
  if (current.current is TimeToken &&
      (current.current! as TimeToken).type == TimeTokenType.lParen) {
    current = current.advance();

    final inner = timeExpr(current);
    if (inner == null) return null;

    current = inner.state;

    if ((current.current as TimeToken?)?.type != TimeTokenType.rParen) {
      return null;
    }

    current = current.advance();

    return ParseResult(
      TimeGroup((num.value as TimeNumber).value, inner.value),
      current,
    );
  }

  return num;
};

FormParser<TimeNode> sequence = (state) {
  final first = term(state);
  if (first == null) return null;

  final parts = <TimeNode>[first.value];
  var current = first.state;

  while ((current.current as TimeToken?)?.type == TimeTokenType.dash) {
    current = current.advance();

    final next = term(current);
    if (next == null) return null;

    parts.add(next.value);
    current = next.state;
  }

  if (parts.length == 1) return first;

  return ParseResult(TimeSequence(parts), current);
};

FormParser<TimeNode> timeExpr = (state) {
  final left = sequence(state);
  if (left == null) return null;

  var current = left.state;

  while ((current.current as TimeToken?)?.type == TimeTokenType.V) {
    current = current.advance();

    final right = sequence(current);
    if (right == null) return null;

    return ParseResult(
      TimeRepeat(left.value, right.value),
      right.state,
    );
  }

  return left;
};

class Timed<T extends FormNode> extends FormNode {
  final T form;
  final TimeNode time;
  Timed(this.form, this.time);
}

FormParser<FormNode> timedSatz = (state) {
  final timeResult = timeExpr(state);
  if (timeResult == null) return null;

  final formResult = satz(timeResult.state);
  if (formResult == null) return null;

  return ParseResult(
    Timed(formResult.value as Satz, timeResult.value),
    formResult.state,
  );
};

void main() {
  Timed(
    Satz(2, hasAnhang: false),
    TimeRepeat(
      TimeGroup(4, TimeSequence([TimeNumber(2), TimeNumber(2)])),
      TimeNumber(4),
    ),
  );
}
