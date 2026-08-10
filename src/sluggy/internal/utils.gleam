import gleam/option.{type Option, None, Some}

pub fn symbol_replacement(code: Int) -> Option(String) {
  case code {
    0x24 -> Some("dollar")
    0x25 -> Some("percent")
    0x26 -> Some("and")
    0x40 -> Some("at")
    0x2B -> Some("plus")
    0x20AC -> Some("euro")
    0x00b0 -> Some("degrees")
    _ -> None
  }
}

/// Checks if the code corresponds to a Combining Diacritical Mark
/// (range U+0300 to U+036F)
pub fn is_combining_mark(code: Int) -> Bool {
  { 0x0300 <= code && code <= 0x036F }
}

/// Returns whether the code should be dropped silently, without
/// creating a word boundary. Apostrophes are the main case: `"don't"`
/// should become `"dont"`, not `"don-t"`.
pub fn to_be_dropped(code: Int) -> Bool {
  case code {
    // ' (regular apostrophe)
    0x27 -> True
    // ’ (right single quotation mark)
    0x2019 -> True
    _ -> False
  }
}

/// If the given codepoint corresponds to an uppercase ASCII letter (`A`-`Z`),
/// it returns the lowercase ASCII codepoint of the equivalent letter.
pub fn to_lower_ascii(code: Int) -> Int {
  case code {
    c if { 0x41 <= c && c <= 0x5A } -> c + 0x20
    _ -> code
  }
}

/// Returns whether the given code is a lowercase **alphanumeric** ASCII character.
pub fn is_slug_char(code: Int) -> Bool {
  case code {
    c if { 0x61 <= c && c <= 0x7A } -> True
    c if { 0x30 <= c && c <= 0x39 } -> True
    _ -> False
  }
}

pub fn bool_to_int(b: Bool) -> Int {
  case b {
    True -> 1
    False -> 0
  }
}
