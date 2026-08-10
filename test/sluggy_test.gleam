import gleeunit
import sluggy

pub fn main() -> Nil {
  gleeunit.main()
}

// str_slugify

pub fn str_slugify_test() {
  let str = "ârrivederci, come stai meine freünde ?"
  let exp = "arrivederci-come-stai-meine-freunde"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_2_test() {
  let str = "Utf Codepoints are awesome !"
  let exp = "utf-codepoints-are-awesome"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_3_test() {
  let str =
    "Develop skills in Gleam and 70+ other languages with a unique blend of learning, practicing, and mentoring from skilled programmers. An educational non-profit and free forever."
  let exp = "develop-skills-in-gleam-and-70-plus-other-languages-with-a"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_apostrophe_test() {
  let str = "What's the next feature in Gleam ?"
  let exp = "whats-the-next-feature-in-gleam"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_right_apostrophe_test() {
  let str = "Is that Jane Birkin’s song?"
  let exp = "is-that-jane-birkins-song"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_symbol_and_test() {
  let str = "Hello world, this is Jack & Jones article !"
  let exp = "hello-world-this-is-jack-and-jones-article"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_symbol_percent_test() {
  let str = "We got 99.999% availability this year."
  let exp = "we-got-99-999-percent-availability-this-year"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_symbol_at_test() {
  let str = "Find us at GitHub @crowlabs-hq"
  let exp = "find-us-at-github-at-crowlabs-hq"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_symbol_dollar_test() {
  let str = "NY Times: the software mistakes that costed 100M$"
  let exp = "ny-times-the-software-mistakes-that-costed-100m-dollar"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_symbol_euro_test() {
  let str = "That will be 100.000 €, sir"
  let exp = "that-will-be-100-000-euro-sir"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_symbol_degrees_test() {
  let str = "It's so hot, 42° out here ; ("
  let exp = "its-so-hot-42-degrees-out-here"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_only_symbols_test() {
  let str = "!!! ??? ,,,"
  let exp = ""

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_only_whitespace_test() {
  let str = "   \t\n  "
  let exp = ""

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_lone_apostrophe_test() {
  let str = "'"
  let exp = ""

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_lone_symbol_test() {
  let str = "&"
  let exp = "and"

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_consecutive_symbols_test() {
  let str = "&%@"
  let exp = "and-percent-at"

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_symbol_glued_no_space_test() {
  let str = "café@wifi"
  let exp = "cafe-at-wifi"

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_apostrophe_and_symbol_test() {
  let str = "cat's & dog's"
  let exp = "cats-and-dogs"

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_non_latin_dropped_test() {
  let str = "héllo世界wörld"
  let exp = "hello-world"

  assert sluggy.str_slugify(str) == exp
}

pub fn str_slugify_leading_digits_test() {
  let str = "0042 rue de la Paix"
  let exp = "0042-rue-de-la-paix"

  assert sluggy.str_slugify(str) == exp
}

// str_slugify_max_length

pub fn str_slugify_max_test() {
  let str =
    "Develop skills in Gleam and 70+ other languages with a unique blend of learning, practicing, and mentoring from skilled programmers. An educational non-profit and free forever."
  let exp =
    "develop-skills-in-gleam-and-70-plus-other-languages-with-a-unique-blend-of-learning-practicing-and-mentoring-from-skilled-programmers-an-educational-non-profit-and-free-forever"

  let slugified_str = sluggy.str_slugify_max_length(str, 180)

  assert slugified_str == exp
}

pub fn str_slugify_max_2_test() {
  let str =
    "Develop skills in Gleam and 70+ other languages with a unique blend of learning, practicing, and mentoring from skilled programmers. An educational non-profit and free forever."
  let exp = "develop-skills-in-gleam-and-70"

  let slugified_str = sluggy.str_slugify_max_length(str, 34)

  assert slugified_str == exp
}

pub fn str_slugify_max_3_test() {
  let str = "héllo世界wörld"
  let exp = "hello"

  let slugified_str = sluggy.str_slugify_max_length(str, 11)

  assert slugified_str == exp
}

pub fn str_slugify_max_4_test() {
  let str = "héllo世界wörld"
  let exp = "hello-world"

  let slugified_str = sluggy.str_slugify_max_length(str, 12)

  assert slugified_str == exp
}

pub fn str_slugify_max_5_test() {
  let str = "héllo世界wörld"
  let exp = ""

  let slugified_str = sluggy.str_slugify_max_length(str, 1)

  assert slugified_str == exp
}

pub fn str_slugify_max_6_test() {
  let str = "&hey/you !"
  let exp = "and"

  let slugified_str = sluggy.str_slugify_max_length(str, 3)

  assert slugified_str == exp
}

pub fn str_slugify_max_7_test() {
  let str = "&hey/you !"
  let exp = ""

  let slugified_str = sluggy.str_slugify_max_length(str, 2)

  assert slugified_str == exp
}

// from_string (and indirectly, inspect)

pub fn from_string_test() {
  let str = "We got 99.999% availability this year."
  let slug = sluggy.from_string(str)
  let expected =
    "Slug(words: 8, length: 44, str: we-got-99-999-percent-availability-this-year)"

  assert sluggy.inspect(slug) == expected
}

pub fn from_string_2_test() {
  let str = "NY Times: the software mistakes that costed 100M$"
  let slug = sluggy.from_string(str)
  let expected =
    "Slug(words: 9, length: 54, str: ny-times-the-software-mistakes-that-costed-100m-dollar)"

  assert sluggy.inspect(slug) == expected
}

pub fn from_string_3_test() {
  let str = "!!! ??? ,,,"
  let slug = sluggy.from_string(str)
  let expected = "Slug(words: 0, length: 0, str: [Empty])"

  assert sluggy.inspect(slug) == expected
}

pub fn from_string_empty_string_test() {
  let str = ""
  let slug = sluggy.from_string(str)
  let expected = "Slug(words: 0, length: 0, str: [Empty])"

  assert sluggy.inspect(slug) == expected
}

// to_string

pub fn to_string_test() {
  let str = "We got 99.999% availability this year."
  let slug = sluggy.from_string(str)

  let expected = "we-got-99-999-percent-availability-this-year"

  assert sluggy.to_string(slug) == expected
}

pub fn to_string_2_test() {
  let str = "NY Times: the software mistakes that costed 100M$"
  let slug = sluggy.from_string(str)

  let expected = "ny-times-the-software-mistakes-that-costed-100m-dollar"

  assert sluggy.to_string(slug) == expected
}

pub fn to_string_3_test() {
  let str = "'"
  let slug = sluggy.from_string(str)

  let expected = ""

  assert sluggy.to_string(slug) == expected
}

pub fn to_string_4_test() {
  let str = "&"
  let slug = sluggy.from_string(str)
  let expected = "and"

  assert sluggy.to_string(slug) == expected
}

// combine

pub fn combine_test() {
  let slug_1 = sluggy.from_string("héllo世界")
  let slug_2 = sluggy.from_string("wörld !")

  let combined = sluggy.combine(slug_1, slug_2)
  let expected = "Slug(words: 2, length: 11, str: hello-world)"

  assert sluggy.inspect(combined) == expected
}

pub fn combine_empty_param_test() {
  let slug_1 = sluggy.from_string("Hello my friend")
  let slug_2 = sluggy.from_string("")

  let combined = sluggy.combine(slug_1, slug_2)

  assert sluggy.inspect(combined) == sluggy.inspect(slug_1)
}

pub fn combine_empty_param_2_test() {
  let slug_1 = sluggy.from_string("")
  let slug_2 = sluggy.from_string("Hallo meine Freunde")

  let combined = sluggy.combine(slug_1, slug_2)

  assert sluggy.inspect(combined) == sluggy.inspect(slug_2)
}

pub fn combine_twice_test() {
  let slug_1 = sluggy.from_string("We got 99.999% availability this year")
  let slug_2 = sluggy.from_string("&")
  let slug_3 = sluggy.from_string("You can find us at GitHub @crowlabs-hq")

  let combined = sluggy.combine(sluggy.combine(slug_1, slug_2), slug_3)
  let expected =
    "Slug(words: 18, length: 89, str: we-got-99-999-percent-availability-this-year-and-you-can-find-us-at-github-at-crowlabs-hq)"

  assert sluggy.inspect(combined) == expected
}

// idempotency tests

pub fn idempotency_test() {
  let str = "It's so hot, 42° out here ; ("
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_2_test() {
  let str = "!!! ??? ,,,"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_3_test() {
  let str = "   \t\n  "
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_4_test() {
  let str = "'"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_5_test() {
  let str = "&"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_6_test() {
  let str = "&%@"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_7_test() {
  let str = "café@wifi"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_8_test() {
  let str = "cat's & dog's"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_9_test() {
  let str = "héllo世界wörld"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}

pub fn idempotency_10_test() {
  let str = "0042 rue de la Paix"
  let slugified = sluggy.str_slugify(str)

  assert sluggy.str_slugify(slugified) == slugified
}
