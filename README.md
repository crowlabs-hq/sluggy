# sluggy

Sluggy is a fast, opinionated and SEO-oriented lightweight library for working with [slugs](https://en.wikipedia.org/wiki/Clean_URL#Slug) in Gleam.

Sluggy focuses on doing one thing well: producing clean, predictable slugs that are actually usable for the web. It is built with SEO and developer-friendliness in mind.

It works on both the Erlang and JavaScript targets.


[![Package Version](https://img.shields.io/hexpm/v/sluggy)](https://hex.pm/packages/sluggy)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/sluggy/)


```sh
gleam add sluggy@1
```

```gleam
import sluggy

pub fn main() {
  // The simplest way to get a slug string
  let slugified = sluggy.str_slugify("Développeurs & Designers: 100% Remote!")
  assert slugified == "developpeurs-and-designers-100-percent-remote"

  // Cap the length, keeping only whole words
  let headline = "How emojis 🌍 became the world's universal language"
  let short_slugified = sluggy.str_slugify_max_length(headline, 40)
  assert short_slugified == "how-emojis-became-the-worlds-universal"

  // Get word count and length alongside the slug
  let slug = sluggy.from_string("New article is out.")
  assert sluggy.inspect(slug) == "Slug(words: 4, length: 18, str: new-article-is-out)"

  // Combine two slugs into one
  let combined = sluggy.combine(
    sluggy.from_string("Apple MacBook"),
    sluggy.from_string("Neo 13 inch 2026 Portable with A18 Pro Chip"),
  )
  assert sluggy.to_string(combined) == "apple-macbook-neo-13-inch-2026-portable-with-a18-pro-chip"
}
```

Further documentation can be found at <https://hexdocs.pm/sluggy>.
