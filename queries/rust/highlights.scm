; extends

; Rust's TextMate grammar classifies these as keyword.other, which Umbra
; deliberately places after the generic keyword rule.
((crate) @keyword.other
  (#set! priority 110))

([
  "async"
  "gen"
] @keyword.other
  (#set! priority 110))

("await" @keyword.control
  (#set! priority 110))

; Tree-sitter treats path and structural operators as delimiters. VS Code's
; Rust grammar gives them keyword.operator scopes instead.
([
  "."
  ":"
  "::"
  "->"
  "=>"
] @operator
  (#set! priority 110))
