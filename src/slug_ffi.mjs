// src/slug_ffi.mjs

export function js_normalize(text) {
  return text
    .normalize("NFKD")
    // .replace(/[\u0300-\u036f]/g, "");
}
