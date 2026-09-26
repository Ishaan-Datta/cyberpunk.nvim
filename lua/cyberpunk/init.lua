local M = {}

M.palette = {
  bg = '#261D45', bg_dark = '#100D23', bg_sidebar = '#372963', bg_popup = '#002212',
  bg_focus = '#182333', bg_group = '#1B2738', border = '#1E2C3F',
  fg = '#00FF9C', fg_bright = '#EEFFFF', fg_dim = '#7877B3', comment = '#6766B3',
  cyan = '#00FFC8', cyan2 = '#00C3FF', blue = '#00B0FF', blue2 = '#6095FF', blue3 = '#82AAFF',
  green = '#00FF9C', green2 = '#00E676', green3 = '#C3E88D', green_dark = '#009550',
  purple = '#D57BFF', purple2 = '#C792EA', purple3 = '#9F5FFF', magenta = '#EE6DFF',
  pink = '#FF5680', pink2 = '#FF4081', red = '#FF5370', red2 = '#FF004C',
  yellow = '#FFFC58', yellow2 = '#FFCB6B', orange = '#F78C6C',
  string = '#76C1FF', property = '#98E3FF', white = '#FFFFFF', gray = '#65737E',
}

local function hi(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

function M.setup(opts)
  opts = opts or {}
  local p = M.palette
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') == 1 then vim.cmd('syntax reset') end
  vim.o.termguicolors = true
  vim.g.colors_name = 'cyberpunk'

  -- Core editor UI
  hi('Normal', { fg = p.fg, bg = p.bg })
  hi('NormalNC', { fg = p.fg, bg = p.bg })
  hi('NormalFloat', { fg = p.fg, bg = p.bg_popup })
  hi('FloatBorder', { fg = p.green, bg = p.bg_popup })
  hi('FloatTitle', { fg = p.green2, bg = p.bg_popup, bold = true })
  hi('Cursor', { fg = p.bg, bg = '#00FF6A' })
  hi('CursorLine', { bg = p.bg_dark })
  hi('CursorColumn', { bg = p.bg_dark })
  hi('ColorColumn', { bg = p.bg_dark })
  hi('LineNr', { fg = p.purple3, bg = p.bg })
  hi('CursorLineNr', { fg = p.cyan, bg = p.bg, bold = true })
  hi('SignColumn', { bg = p.bg })
  hi('FoldColumn', { fg = p.purple3, bg = p.bg })
  hi('Folded', { fg = p.fg_dim, bg = p.bg_dark })
  hi('VertSplit', { fg = p.border, bg = p.bg })
  hi('WinSeparator', { fg = p.border, bg = p.bg })
  hi('EndOfBuffer', { fg = p.bg })
  hi('Whitespace', { fg = '#2B3E5A' })
  hi('NonText', { fg = '#2B3E5A' })
  hi('SpecialKey', { fg = '#2B3E5A' })
  hi('Visual', { bg = '#311B92' })
  hi('VisualNOS', { bg = '#311B92' })
  hi('Search', { fg = p.fg_bright, bg = '#283593' })
  hi('IncSearch', { fg = p.white, bg = '#5E35B1' })
  hi('CurSearch', { fg = p.white, bg = '#5E35B1' })
  hi('MatchParen', { fg = p.red2, bg = '#4B234D', bold = true })
  hi('Directory', { fg = p.green2 })
  hi('Title', { fg = p.green2, bold = true })
  hi('Question', { fg = p.green })
  hi('MoreMsg', { fg = p.green2 })
  hi('ModeMsg', { fg = p.green })
  hi('WarningMsg', { fg = '#FF9100' })
  hi('ErrorMsg', { fg = '#FF3270' })

  -- Menus / completion / statusline
  hi('Pmenu', { fg = p.green, bg = p.bg_popup })
  hi('PmenuSel', { fg = p.fg_bright, bg = '#002F6D' })
  hi('PmenuSbar', { bg = p.bg_dark })
  hi('PmenuThumb', { bg = '#6A3ECF' })
  hi('WildMenu', { fg = p.bg_popup, bg = p.green })
  hi('StatusLine', { fg = p.green, bg = p.bg_popup })
  hi('StatusLineNC', { fg = p.fg_dim, bg = p.bg_dark })
  hi('TabLine', { fg = p.fg_dim, bg = p.bg_sidebar })
  hi('TabLineSel', { fg = p.green, bg = p.bg })
  hi('TabLineFill', { bg = p.bg_sidebar })
  hi('WinBar', { fg = p.green, bg = p.bg })
  hi('WinBarNC', { fg = p.fg_dim, bg = p.bg })

  -- Traditional Vim syntax groups mapped from the VS Code token scopes
  hi('Comment', { fg = p.comment, italic = true })
  hi('Constant', { fg = p.yellow })
  hi('String', { fg = p.string })
  hi('Character', { fg = p.yellow })
  hi('Number', { fg = p.yellow })
  hi('Boolean', { fg = p.yellow })
  hi('Float', { fg = p.yellow })
  hi('Identifier', { fg = p.fg_bright })
  hi('Function', { fg = p.blue })
  hi('Statement', { fg = p.purple })
  hi('Conditional', { fg = p.blue })
  hi('Repeat', { fg = p.blue })
  hi('Label', { fg = p.pink })
  hi('Operator', { fg = p.blue })
  hi('Keyword', { fg = p.purple })
  hi('Exception', { fg = p.purple })
  hi('PreProc', { fg = p.pink })
  hi('Include', { fg = p.purple })
  hi('Define', { fg = p.purple })
  hi('Macro', { fg = p.pink })
  hi('PreCondit', { fg = p.purple })
  hi('Type', { fg = p.green })
  hi('StorageClass', { fg = p.purple })
  hi('Structure', { fg = p.green })
  hi('Typedef', { fg = p.green })
  hi('Special', { fg = p.cyan2 })
  hi('SpecialChar', { fg = '#89DDFF' })
  hi('Tag', { fg = p.pink })
  hi('Delimiter', { fg = p.blue })
  hi('SpecialComment', { fg = p.comment, italic = true })
  hi('Debug', { fg = '#B267E6' })
  hi('Underlined', { fg = p.blue3, underline = true })
  hi('Ignore', { fg = p.gray })
  hi('Error', { fg = p.red })
  hi('Todo', { fg = p.bg_dark, bg = p.yellow, bold = true })

  -- Tree-sitter captures
  local ts = {
    ['@comment'] = { fg = p.comment, italic = true },
    ['@comment.documentation'] = { fg = p.comment, italic = true },
    ['@variable'] = { fg = p.fg_bright },
    ['@variable.builtin'] = { fg = p.pink, italic = true },
    ['@variable.parameter'] = { fg = p.yellow },
    ['@variable.member'] = { fg = p.property },
    ['@constant'] = { fg = p.yellow },
    ['@constant.builtin'] = { fg = p.yellow },
    ['@constant.macro'] = { fg = p.yellow },
    ['@module'] = { fg = p.pink },
    ['@module.builtin'] = { fg = p.pink },
    ['@label'] = { fg = p.pink },
    ['@string'] = { fg = p.string },
    ['@string.documentation'] = { fg = p.string },
    ['@string.regexp'] = { fg = '#89DDFF' },
    ['@string.escape'] = { fg = '#89DDFF' },
    ['@string.special'] = { fg = p.green },
    ['@character'] = { fg = p.yellow },
    ['@character.special'] = { fg = '#89DDFF' },
    ['@boolean'] = { fg = p.yellow },
    ['@number'] = { fg = p.yellow },
    ['@number.float'] = { fg = p.yellow },
    ['@type'] = { fg = p.green },
    ['@type.builtin'] = { fg = p.green },
    ['@type.definition'] = { fg = p.green },
    ['@attribute'] = { fg = p.magenta },
    ['@attribute.builtin'] = { fg = p.magenta },
    ['@property'] = { fg = p.property },
    ['@function'] = { fg = p.blue },
    ['@function.builtin'] = { fg = p.blue },
    ['@function.call'] = { fg = p.blue },
    ['@function.macro'] = { fg = p.blue },
    ['@function.method'] = { fg = p.blue2, italic = true },
    ['@function.method.call'] = { fg = p.blue2 },
    ['@constructor'] = { fg = p.blue2 },
    ['@operator'] = { fg = p.blue },
    ['@keyword'] = { fg = p.purple },
    ['@keyword.coroutine'] = { fg = p.purple },
    ['@keyword.function'] = { fg = p.purple },
    ['@keyword.operator'] = { fg = p.blue },
    ['@keyword.import'] = { fg = p.purple },
    ['@keyword.type'] = { fg = p.purple },
    ['@keyword.modifier'] = { fg = p.purple },
    ['@keyword.repeat'] = { fg = p.blue },
    ['@keyword.return'] = { fg = p.blue },
    ['@keyword.debug'] = { fg = p.purple },
    ['@keyword.exception'] = { fg = p.purple },
    ['@keyword.conditional'] = { fg = p.blue },
    ['@keyword.directive'] = { fg = p.purple },
    ['@punctuation.delimiter'] = { fg = p.blue },
    ['@punctuation.bracket'] = { fg = p.blue },
    ['@punctuation.special'] = { fg = p.blue },
    ['@tag'] = { fg = p.pink },
    ['@tag.attribute'] = { fg = p.green, italic = true },
    ['@tag.delimiter'] = { fg = p.blue },
    ['@markup.strong'] = { fg = '#F07178', bold = true },
    ['@markup.italic'] = { fg = '#F07178', italic = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.underline'] = { fg = p.orange, underline = true },
    ['@markup.heading'] = { fg = p.green3, bold = true },
    ['@markup.quote'] = { fg = p.gray, italic = true },
    ['@markup.math'] = { fg = p.purple2 },
    ['@markup.link'] = { fg = p.blue3, underline = true },
    ['@markup.link.label'] = { fg = p.purple2 },
    ['@markup.link.url'] = { fg = p.blue3, underline = true },
    ['@markup.raw'] = { fg = p.purple2 },
    ['@markup.list'] = { fg = p.fg_bright },
    ['@diff.plus'] = { fg = p.green3 },
    ['@diff.minus'] = { fg = p.red },
    ['@diff.delta'] = { fg = p.purple2 },
  }
  for g, s in pairs(ts) do hi(g, s) end

  -- LSP semantic tokens
  local lsp = {
    ['@lsp.type.class'] = { fg = p.green }, ['@lsp.type.struct'] = { fg = p.green },
    ['@lsp.type.interface'] = { fg = p.green }, ['@lsp.type.enum'] = { fg = p.green },
    ['@lsp.type.type'] = { fg = p.green }, ['@lsp.type.typeParameter'] = { fg = p.green },
    ['@lsp.type.namespace'] = { fg = p.pink }, ['@lsp.type.function'] = { fg = p.blue },
    ['@lsp.type.method'] = { fg = p.blue2 }, ['@lsp.type.macro'] = { fg = p.pink },
    ['@lsp.type.property'] = { fg = p.property }, ['@lsp.type.variable'] = { fg = p.fg_bright },
    ['@lsp.type.parameter'] = { fg = p.yellow }, ['@lsp.type.enumMember'] = { fg = p.yellow },
    ['@lsp.type.decorator'] = { fg = p.magenta, italic = true },
    ['@lsp.mod.readonly'] = { italic = true }, ['@lsp.mod.deprecated'] = { strikethrough = true },
  }
  for g, s in pairs(lsp) do hi(g, s) end

  -- Diagnostics
  hi('DiagnosticError', { fg = '#FF1865' })
  hi('DiagnosticWarn', { fg = '#FF9100' })
  hi('DiagnosticInfo', { fg = p.cyan2 })
  hi('DiagnosticHint', { fg = p.green2 })
  hi('DiagnosticOk', { fg = p.green })
  hi('DiagnosticUnderlineError', { sp = '#FF1865', undercurl = true })
  hi('DiagnosticUnderlineWarn', { sp = '#FF9100', undercurl = true })
  hi('DiagnosticUnderlineInfo', { sp = p.cyan2, undercurl = true })
  hi('DiagnosticUnderlineHint', { sp = p.green2, undercurl = true })

  -- Diff / git
  hi('DiffAdd', { fg = p.green3, bg = '#143D35' })
  hi('DiffDelete', { fg = p.red, bg = '#3D1630' })
  hi('DiffChange', { fg = p.purple2, bg = '#2B2456' })
  hi('DiffText', { fg = p.white, bg = '#5E35B1' })
  hi('GitSignsAdd', { fg = p.green2, bg = p.bg })
  hi('GitSignsChange', { fg = p.cyan2, bg = p.bg })
  hi('GitSignsDelete', { fg = p.red2, bg = p.bg })
  hi('GitSignsUntracked', { fg = '#00FF6A', bg = p.bg })

  -- Telescope
  hi('TelescopeNormal', { fg = p.fg, bg = p.bg_dark })
  hi('TelescopeBorder', { fg = p.green, bg = p.bg_dark })
  hi('TelescopeTitle', { fg = p.green2, bg = p.bg_dark, bold = true })
  hi('TelescopePromptNormal', { fg = p.green, bg = p.bg_popup })
  hi('TelescopePromptBorder', { fg = p.green, bg = p.bg_popup })
  hi('TelescopePromptPrefix', { fg = p.cyan })
  hi('TelescopeSelection', { fg = p.cyan, bg = p.bg_focus, bold = true })
  hi('TelescopeMatching', { fg = p.cyan2, bold = true })

  -- nvim-cmp
  hi('CmpItemAbbr', { fg = p.fg_bright })
  hi('CmpItemAbbrMatch', { fg = p.cyan2, bold = true })
  hi('CmpItemAbbrMatchFuzzy', { fg = p.cyan2 })
  hi('CmpItemAbbrDeprecated', { fg = p.gray, strikethrough = true })
  hi('CmpItemKindFunction', { fg = p.blue })
  hi('CmpItemKindMethod', { fg = p.blue2 })
  hi('CmpItemKindVariable', { fg = p.fg_bright })
  hi('CmpItemKindField', { fg = p.property })
  hi('CmpItemKindProperty', { fg = p.property })
  hi('CmpItemKindClass', { fg = p.green })
  hi('CmpItemKindInterface', { fg = p.green })
  hi('CmpItemKindModule', { fg = p.pink })
  hi('CmpItemKindKeyword', { fg = p.purple })
  hi('CmpItemKindConstant', { fg = p.yellow })
  hi('CmpItemKindText', { fg = p.string })

  -- Neo-tree / NvimTree
  hi('NvimTreeNormal', { fg = '#B08BFF', bg = p.bg_sidebar })
  hi('NvimTreeNormalNC', { fg = '#B08BFF', bg = p.bg_sidebar })
  hi('NvimTreeFolderName', { fg = p.cyan })
  hi('NvimTreeOpenedFolderName', { fg = p.green, bold = true })
  hi('NvimTreeRootFolder', { fg = p.green2, bold = true })
  hi('NvimTreeGitDirty', { fg = p.cyan2 })
  hi('NvimTreeGitNew', { fg = '#00FF6A' })
  hi('NvimTreeGitDeleted', { fg = p.red2 })
  hi('NeoTreeNormal', { fg = '#B08BFF', bg = p.bg_sidebar })
  hi('NeoTreeNormalNC', { fg = '#B08BFF', bg = p.bg_sidebar })
  hi('NeoTreeDirectoryName', { fg = p.cyan })
  hi('NeoTreeDirectoryIcon', { fg = p.cyan })
  hi('NeoTreeRootName', { fg = p.green2, bold = true })
  hi('NeoTreeGitModified', { fg = p.cyan2 })
  hi('NeoTreeGitUntracked', { fg = '#00FF6A' })
  hi('NeoTreeGitDeleted', { fg = p.red2 })

  -- Which-key / Lazy / Mason
  hi('WhichKey', { fg = p.cyan })
  hi('WhichKeyGroup', { fg = p.green })
  hi('WhichKeyDesc', { fg = p.string })
  hi('WhichKeySeparator', { fg = p.fg_dim })
  hi('LazyButton', { fg = p.fg_dim, bg = p.bg_dark })
  hi('LazyButtonActive', { fg = p.green, bg = p.bg_focus, bold = true })
  hi('LazyH1', { fg = p.bg_dark, bg = p.green, bold = true })
  hi('MasonHeader', { fg = p.bg_dark, bg = p.green, bold = true })
  hi('MasonHighlight', { fg = p.cyan2 })
  hi('MasonHighlightBlock', { fg = p.bg_dark, bg = p.cyan })

  -- Indent guides
  hi('IblIndent', { fg = p.bg_sidebar })
  hi('IblScope', { fg = p.cyan })
  hi('IndentBlanklineChar', { fg = p.bg_sidebar })
  hi('IndentBlanklineContextChar', { fg = p.cyan })

  -- Markdown compatibility groups
  hi('markdownH1', { fg = p.green3, bold = true })
  hi('markdownH2', { fg = p.green3, bold = true })
  hi('markdownH3', { fg = p.green3, bold = true })
  hi('markdownCode', { fg = p.purple2 })
  hi('markdownCodeBlock', { fg = p.purple2 })
  hi('markdownLinkText', { fg = p.blue3 })
  hi('markdownUrl', { fg = p.blue3, underline = true })

  if opts.on_highlights then opts.on_highlights(hi, p) end
end

return M
