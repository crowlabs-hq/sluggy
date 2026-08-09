// src/slug_ffi.mjs

export function js_normalize(text) {
  return text
    .normalize("NFKD")
}
