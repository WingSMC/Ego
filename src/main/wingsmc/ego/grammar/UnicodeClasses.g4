/**
 * Taken from http://www.antlr3.org/grammar/1345144569663/AntlrUnicode.txt
 */

lexer grammar UnicodeClasses;

fragment UNICODE_CLASS_ND:
  '\u16EE' ..'\u16F0'
  | '\u2160' ..'\u2182'
  | '\u2185' ..'\u2188'
  | '\u3007'
  | '\u3021' ..'\u3029'
  | '\u3038' ..'\u303A'
  | '\uA6E6' ..'\uA6EF';

fragment UNICODE_CLASS_ND_NOZEROS:
  '\u0031' ..'\u0039'
  | '\u0661' ..'\u0669'
  | '\u06f1' ..'\u06f9'
  | '\u07c1' ..'\u07c9'
  | '\u0967' ..'\u096f'
  | '\u09e7' ..'\u09ef'
  | '\u0a67' ..'\u0a6f'
  | '\u0ae7' ..'\u0aef'
  | '\u0b67' ..'\u0b6f'
  | '\u0be7' ..'\u0bef'
  | '\u0c67' ..'\u0c6f'
  | '\u0ce7' ..'\u0cef'
  | '\u0d67' ..'\u0d6f'
  | '\u0de7' ..'\u0def'
  | '\u0e51' ..'\u0e59'
  | '\u0ed1' ..'\u0ed9'
  | '\u0f21' ..'\u0f29'
  | '\u1041' ..'\u1049'
  | '\u1091' ..'\u1099'
  | '\u17e1' ..'\u17e9'
  | '\u1811' ..'\u1819'
  | '\u1947' ..'\u194f'
  | '\u19d1' ..'\u19d9'
  | '\u1a81' ..'\u1a89'
  | '\u1a91' ..'\u1a99'
  | '\u1b51' ..'\u1b59'
  | '\u1bb1' ..'\u1bb9'
  | '\u1c41' ..'\u1c49'
  | '\u1c51' ..'\u1c59'
  | '\ua621' ..'\ua629'
  | '\ua8d1' ..'\ua8d9'
  | '\ua901' ..'\ua909'
  | '\ua9d1' ..'\ua9d9'
  | '\ua9f1' ..'\ua9f9'
  | '\uaa51' ..'\uaa59'
  | '\uabf1' ..'\uabf9'
  | '\uff11' ..'\uff19';
