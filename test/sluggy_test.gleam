import gleeunit
import sluggy

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn str_slugify_str_test() {
  let str = "ârrivederci, come stai meine freünde ?"
  let exp = "arrivederci-come-stai-meine-freunde"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_str_2_test() {
  let str = "Utf Codepoints are awesome !"
  let exp = "utf-codepoints-are-awesome"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_str_3_test() {
  let str =
    "Develop skills in Gleam and 70+ other languages with a unique blend of learning, practicing, and mentoring from skilled programmers. An educational non-profit and free forever."
  let exp =
    "develop-skills-in-gleam-and-70-plus-other-languages-with-a-unique-blend-of-learning-practicing-and-mentoring-from-skilled-programmers-an-educational-non-profit-and-free-forever"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_str_apostrophe_test() {
  let str = "What's the next feature in Gleam ?"
  let exp = "whats-the-next-feature-in-gleam"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_str_right_apostrophe_test() {
  let str = "Is that Jane Birkin’s song?"
  let exp = "is-that-jane-birkins-song"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}

pub fn str_slugify_str_transliteration_1_test() {
  let str = "Hello world, this is Jack & Jones article !"
  let exp = "hello-world-this-is-jack-and-jones-article"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_str_transliteration_2_test() {
  let str = "We got 99.999% availability this year."
  let exp = "we-got-99-999-percent-availability-this-year"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_str_transliteration_3_test() {
  let str = "Find us at GitHub @crowlabs-hq"
  let exp = "find-us-at-github-at-crowlabs-hq"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}

pub fn str_slugify_str_transliteration_4_test() {
  let str = "NY Times: the software mistakes that costed 100M$"
  let exp = "ny-times-the-software-mistakes-that-costed-100m-dollar"

  let slugified_str = sluggy.str_slugify(str)
  assert slugified_str == exp
}
// TODO

// idempotency checks
// slugify(slugify(x)) == slugify(x)

// + all the other functions' tests
