/// Checks if the code corresponds to a Combining Diacritical Mark
/// (range U+0300 to U+036F)
pub fn is_combining_mark(code: Int) -> Bool {
  { 0x0300 <= code && code <= 0x036F }
}

/// Computes the arithmetical operation to get the lowercase
/// if the provided code corresponds to an ASCII letter
pub fn to_lower_ascii(code: Int) -> Int {
  case code {
    c if { 0x41 <= c && c <= 0x5A } -> c + 0x20
    _ -> code
  }
}

/// Returns wether the given code corresponds to
/// an ASCII alphanumeric character
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
