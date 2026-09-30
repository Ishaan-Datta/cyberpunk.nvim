; extends

; The VS Code Nix grammar scopes binding names as attribute names. The base
; Tree-sitter query only does this inside explicit attribute sets.
(binding
  attrpath: (attrpath
    (identifier) @variable.member))
