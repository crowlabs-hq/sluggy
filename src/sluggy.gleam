import gleam/int
import gleam/list.{Continue, Stop}
import gleam/option.{None, Some}
import gleam/string
import sluggy/internal/utils

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

type WordFit {
  WordFit(count: Int, length: Int)
}

/// Converts a string to its slug representation, returning a plain
/// `String` instead of a whole `Slug`.
///
/// This is more convenient when you don't need the word count or
/// precomputed length; use [from_string](#from_string) instead if you do.
///
/// Since this is SEO-oriented, the default length cap of the
/// slug is **60** characters. If you want a custom length, use
/// [str_slugify_max_length](#str_slugify_max_length) instead.
///
/// ### Example
/// ```gleam
/// assert sluggy.str_slugify("Sluggy is awesome !") == "sluggy-is-awesome"
/// ```
pub fn str_slugify(str: String) -> String {
  str_slugify_max_length(str, 60)
}

/// Same as [str_slugify](#str_slugify), but with a custom max. length instead
/// of the default of 60 characters.
///
/// Note that this doesn't mean the resulting slug will be exactly
/// `max_length` characters long; only that it won't exceed it.
///
/// ### Example
/// ```gleam
/// assert sluggy.str_slugify_max_length("Sluggy is awesome !", 8) == "sluggy"
/// assert sluggy.str_slugify_max_length("Sluggy is awesome !", 9) == "sluggy-is"
/// assert sluggy.str_slugify_max_length("Sluggy is awesome !", 20) == "sluggy-is-awesome"
/// ```
pub fn str_slugify_max_length(str: String, max_length: Int) -> String {
  let computed = compute(str)
  truncate(computed, max_length).str
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
  compute(str) |> truncate(60)
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
                codepoints: acc.codepoints,
                pending_sep: True,
                has_output: acc.has_output,
                word_count: acc.word_count,
                length_count: acc.length_count,
              )
          }
      }
    }
  }
}

/// Cuts a slug down to `max_length`, keeping only whole words.
fn truncate(acc: SlugAcc, max_length: Int) -> Slug {
  let slug = codepoints_to_string(acc.codepoints)

  case acc.length_count <= max_length {
    True -> Slug(str: slug, words: acc.word_count, length: acc.length_count)
    False -> {
      let wordlist = string.split(slug, "-")

      let fit =
        list.fold_until(wordlist, WordFit(count: 0, length: 0), fn(state, word) {
          let new_length = case state.count {
            // first word, no hyphen before
            0 -> string.length(word)
            _ -> state.length + 1 + string.length(word)
          }

          case new_length <= max_length {
            True ->
              Continue(WordFit(count: state.count + 1, length: new_length))
            False -> Stop(state)
          }
        })

      Slug(
        str: wordlist |> list.take(fit.count) |> string.join("-"),
        words: fit.count,
        length: fit.length,
      )
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
    codepoints: list.append(prefix, acc.codepoints),
    pending_sep: force_boundary,
    has_output: True,
    word_count: acc.word_count + utils.bool_to_int(is_new_word),
    length_count: acc.length_count + list.length(prefix),
  )
}
