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
    "develop-skills-in-gleam-and-70-other-languages-with-a-unique-blend-of-learning-practicing-and-mentoring-from-skilled-programmers-an-educational-non-profit-and-free-forever"
  let slugified_str = sluggy.str_slugify(str)

  assert slugified_str == exp
}
// TODO

// idempotency checks
// slugify(slugify(x)) == slugify(x)

// + all the other functions' tests
