import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import sluggy/internal/utils

// TODO
// length limit (without truncating mid-word)

@external(erlang, "unicode", "characters_to_nfkd_binary")
@external(javascript, "./slug_ffi.mjs", "js_normalize")
fn normalize_nfkd(str: String) -> String

/// A slug, along with its word count and length, computed alongside it.
///
/// Values of this type can only be constructed with `from_string`, which
/// guarantees `words`, `length`, and `str` always stay consistent with
/// each other.
pub opaque type Slug {
  Slug(words: Int, length: Int, str: String)
}

type SlugAcc {
  SlugAcc(
    codepoints: List(UtfCodepoint),
    pending_sep: Bool,
    has_output: Bool,
    word_count: Int,
    length_count: Int,
  )
}

/// Converts a string to its slug representation, returning a plain
/// `String` instead of a whole `Slug`.
///
/// This is more convenient when you don't need the word count or
/// precomputed length; use [from_string](#from_string) instead if you do.
///
/// ### Example
/// ```gleam
/// assert sluggy.str_slugify("Sluggy is awesome !") == "sluggy-is-awesome"
/// ```
pub fn str_slugify(str: String) -> String {
  str |> compute |> fn(acc) { codepoints_to_string(acc.codepoints) }
}

/// Given a `Slug`, this gives only its slug string.
///
/// ### Example
/// ```gleam
/// let slug = from_string("Hello World ; )")
/// assert "hello-world" == sluggy.to_string(slug)
/// ```
pub fn to_string(slug: Slug) -> String {
  let Slug(_l, _w, s) = slug
  s
}

/// Combines two `Slug`'s into a single one, summing their word counts
/// and lengths (plus one, for the hyphen joining them).
///
/// ### Examples
/// ```gleam
/// let slug_1 = sluggy.from_string("Hello")
/// let slug_2 = sluggy.from_string("Sluggy !")
/// let combined = sluggy.combine(slug_1, slug_2)
///
/// assert sluggy.inspect(combined) == "Slug(words: 2, length: 12, str: hello-sluggy)"
/// ```
pub fn combine(s1: Slug, s2: Slug) -> Slug {
  case s1.str, s2.str {
    _, "" -> s1
    "", _ -> s2
    _, _ ->
      Slug(
        words: s1.words + s2.words,
        length: s1.length + s2.length + 1,
        str: s1.str <> "-" <> s2.str,
      )
  }
}

/// Returns a human-readable, debug-style representation of a `Slug`,
/// showing its word count, length, and slug string.
///
/// ### Example
/// ```gleam
/// let slug = sluggy.from_string("New article is out.")
///
/// assert sluggy.inspect(slug) == "Slug(words: 4, length: 18, str: new-article-is-out)"
/// ```
pub fn inspect(slug: Slug) -> String {
  "Slug(words: "
  <> int.to_string(slug.words)
  <> ", "
  <> "length: "
  <> int.to_string(slug.length)
  <> ", "
  <> "str: "
  <> case slug.str {
    "" -> "[Empty]"
    s -> s
  }
  <> ")"
}

/// Creates a new `Slug` from the provided string.
///
/// If you only need the slugified string and don't want the **words**
/// and **length** fields, use [str_slugify](#str_slugify) instead.
///
/// ### Example
/// ```gleam
/// let slug = sluggy.from_string("New article is out.")
/// assert sluggy.inspect(slug) == "Slug(words: 4, length: 18, str: new-article-is-out)"
/// ```
pub fn from_string(str: String) -> Slug {
  let acc = compute(str)
  Slug(
    words: acc.word_count,
    length: acc.length_count,
    str: codepoints_to_string(acc.codepoints),
  )
}

fn codepoints_to_string(codepoints: List(UtfCodepoint)) -> String {
  codepoints |> list.reverse |> string.from_utf_codepoints
}

fn compute(str: String) -> SlugAcc {
  let assert [hyphen_cp] = string.to_utf_codepoints("-")

  str
  |> normalize_nfkd
  |> string.to_utf_codepoints
  |> list.fold(SlugAcc([], False, False, 0, 0), fn(acc, cp) {
    slugify_fold(acc, cp, hyphen_cp)
  })
}

fn slugify_fold(
  acc: SlugAcc,
  cp: UtfCodepoint,
  hyphen_cp: UtfCodepoint,
) -> SlugAcc {
  let codepoint = string.utf_codepoint_to_int(cp)

  case
    { utils.is_combining_mark(codepoint) || utils.to_be_dropped(codepoint) }
  {
    True -> acc
    False -> {
      let lowercased = utils.to_lower_ascii(codepoint)

      case utils.symbol_replacement(codepoint) {
        Some(word) ->
          emit_word(
            acc,
            list.reverse(string.to_utf_codepoints(word)),
            hyphen_cp,
            True,
          )

        None ->
          case utils.is_slug_char(lowercased) {
            True -> {
              let assert Ok(char_cp) = string.utf_codepoint(lowercased)
              emit_word(acc, [char_cp], hyphen_cp, False)
            }
            // Not a slug char, separator is now pending, nothing emitted
            False ->
              SlugAcc(
                acc.codepoints,
                True,
                acc.has_output,
                acc.word_count,
                acc.length_count,
              )
          }
      }
    }
  }
}

/// Adds a word's codepoints to the accumulator as a single slug
/// word, and also the separator (hyphen) when needed.
fn emit_word(
  acc: SlugAcc,
  word_codepoints: List(UtfCodepoint),
  hyphen_cp: UtfCodepoint,
  force_boundary: Bool,
) -> SlugAcc {
  let needs_leading_sep =
    acc.has_output && { acc.pending_sep || force_boundary }

  let is_new_word = !acc.has_output || acc.pending_sep || force_boundary

  let prefix = case needs_leading_sep {
    True -> list.append(word_codepoints, [hyphen_cp])
    False -> word_codepoints
  }

  SlugAcc(
    list.append(prefix, acc.codepoints),
    force_boundary,
    True,
    acc.word_count + utils.bool_to_int(is_new_word),
    acc.length_count + list.length(prefix),
  )
}
