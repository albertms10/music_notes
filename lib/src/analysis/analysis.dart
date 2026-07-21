// ignore_for_file: constant_identifier_names, public_member_api_docs test

export 'time_ast.dart';

enum TokenType {
  PP('PP'),
  FP('FP'),
  Kdz('Kdz'),
  VS('VS'),
  NS('NS'),
  HS('HS'),
  US('US'),
  SS('SS'),
  Schl('Schl'),
  DF('DF'),
  Rpr('Rpr'),
  V('V'),
  T('T'),
  TE('TE')
  ;

  final String label;

  const TokenType(this.label);

  factory TokenType.parse(String source) => values.firstWhere(
    (value) => value.label == source,
    orElse: () => throw ArgumentError('Unknown token type: $source'),
  );
}

class Token {
  final TokenType type;
  Token(this.type);
}

abstract class FormNode {
  static FormNode? analyze(String input) {
    final tokens = input.split(RegExp(r'\s+')).map(TokenType.parse).toList();
    if (tokens.contains(null)) return null;

    return TokenParser(tokens).parse();
  }
}

class Satz extends FormNode {
  final int fpCount;
  final bool hasAnhang;

  Satz(this.fpCount, {required this.hasAnhang});
}

class Periode extends FormNode {}

class Sonata extends FormNode {
  final bool hasDevelopment;

  Sonata({required this.hasDevelopment});
}

class TokenParser {
  final List<TokenType> tokens;
  int pos = 0;

  TokenParser(this.tokens);

  bool get isAtEnd => pos >= tokens.length;

  TokenType? peek() => isAtEnd ? null : tokens[pos];

  TokenType? advance() => isAtEnd ? null : tokens[pos++];

  bool match(TokenType t) {
    if (peek() == t) {
      advance();

      return true;
    }

    return false;
  }

  void consumeModifiers() {
    while (peek() == .V || peek() == .T || peek() == .TE) {
      advance();
    }
  }

  FormNode? parse() => parseSatz() ?? parsePeriode() ?? parseSonata();

  // --- SATZ ---
  FormNode? parseSatz() {
    final start = pos;

    if (!match(.PP)) {
      pos = start;

      return null;
    }

    consumeModifiers();

    var fpCount = 0;
    while (match(.FP)) {
      fpCount++;
      consumeModifiers();
    }

    if (fpCount == 0) {
      pos = start;

      return null;
    }

    if (!match(.Kdz)) {
      pos = start;

      return null;
    }

    // Annex opcional
    var hasAnhang = false;
    while (match(.Schl) || match(.FP)) {
      hasAnhang = true;
      consumeModifiers();
    }

    if (!isAtEnd) {
      pos = start;

      return null;
    }

    return Satz(fpCount, hasAnhang: hasAnhang);
  }

  // --- PERIODE ---
  FormNode? parsePeriode() {
    final start = pos;

    if (!match(.VS)) return null;
    consumeModifiers();

    if (!match(.NS)) {
      pos = start;

      return null;
    }

    consumeModifiers();

    if (!isAtEnd) {
      pos = start;

      return null;
    }

    return Periode();
  }

  // --- SONATA ---
  FormNode? parseSonata() {
    final start = pos;

    if (!match(.HS)) return null;
    if (!match(.US)) {
      pos = start;

      return null;
    }
    if (!match(.SS)) {
      pos = start;

      return null;
    }
    if (!match(.Schl)) {
      pos = start;

      return null;
    }

    final hasDF = match(.DF);

    if (!match(.Rpr)) {
      pos = start;

      return null;
    }

    if (!isAtEnd) {
      pos = start;

      return null;
    }

    return Sonata(hasDevelopment: hasDF);
  }
}

typedef FormParser<T> = ParseResult<T>? Function(ParseState state);

class ParseState {
  final List<TokenType> tokens;
  final int pos;

  ParseState(this.tokens, this.pos);

  bool get isAtEnd => pos >= tokens.length;
  TokenType? get current => isAtEnd ? null : tokens[pos];

  ParseState advance() => ParseState(tokens, pos + 1);
}

class ParseResult<T> {
  final T value;
  final ParseState state;

  ParseResult(this.value, this.state);
}

FormParser<TokenType> token(TokenType t) => (state) {
  if (state.current == t) {
    return ParseResult(t, state.advance());
  }
  return null;
};

FormParser<List<T>> seq<T>(List<FormParser<T>> parsers) => (state) {
  final values = <T>[];
  var current = state;

  for (final p in parsers) {
    final result = p(current);
    if (result == null) return null;

    values.add(result.value);
    current = result.state;
  }

  return ParseResult(values, current);
};

FormParser<T> choice<T>(List<FormParser<T>> parsers) => (state) {
  for (final p in parsers) {
    final result = p(state);
    if (result != null) return result;
  }
  return null;
};

FormParser<List<T>> many<T>(FormParser<T> parser) => (state) {
  final values = <T>[];
  var current = state;

  while (true) {
    final result = parser(current);
    if (result == null) break;

    values.add(result.value);
    current = result.state;
  }

  return ParseResult(values, current);
};

FormParser<T?> optional<T>(FormParser<T> parser) => (state) {
  final result = parser(state);
  if (result != null) return result;
  return ParseResult(null, state);
};

final modifier = choice<TokenType>([
  token(TokenType.V),
  token(TokenType.T),
  token(TokenType.TE),
]);

final modifiers = many(modifier);

FormParser<FormNode> satz = (state) {
  final parser = seq([
    token(TokenType.PP),
    modifiers,
    many(
      seq([
        token(TokenType.FP),
        modifiers,
      ]),
    ),
    token(TokenType.Kdz),
    optional(
      many(
        choice([
          token(TokenType.Schl),
          token(TokenType.FP),
        ]),
      ),
    ),
  ]);

  final result = parser(state);
  if (result == null) return null;

  final fpBlocks = result.value[2]! as List;

  if (fpBlocks.isEmpty) return null;

  return ParseResult(
    Satz(fpBlocks.length, hasAnhang: result.value[4] != null),
    result.state,
  );
};

FormParser<FormNode> periode = (state) {
  final parser = seq([
    token(TokenType.VS),
    modifiers,
    token(TokenType.NS),
    modifiers,
  ]);

  final result = parser(state);
  if (result == null) return null;

  return ParseResult(Periode(), result.state);
};

FormParser<FormNode> sonata = (state) {
  final parser = seq([
    token(TokenType.HS),
    token(TokenType.US),
    token(TokenType.SS),
    token(TokenType.Schl),
    optional(token(TokenType.DF)),
    token(TokenType.Rpr),
  ]);

  final result = parser(state);
  if (result == null) return null;

  final hasDF = result.value[4] != null;

  return ParseResult(Sonata(hasDevelopment: hasDF), result.state);
};

final formParser = choice<FormNode>([
  satz,
  periode,
  sonata,
]);

FormNode? analyze(List<TokenType> tokens) {
  final result = formParser(ParseState(tokens, 0));

  if (result == null) return null;
  if (!result.state.isAtEnd) return null;

  return result.value;
}
