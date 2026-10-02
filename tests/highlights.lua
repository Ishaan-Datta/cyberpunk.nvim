local root = vim.fn.getcwd()
vim.opt.runtimepath:prepend(root)
vim.cmd.colorscheme('cyberpunk')

local function assert_fg(group, expected)
  local actual = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
  assert(actual == tonumber(expected:sub(2), 16), ('%s: expected %s, got #%06X'):format(group, expected, actual or 0))
end

local expected = {
  ['@lsp.type.keyword'] = '#00B0FF',
  ['@lsp.type.keyword.rust'] = '#FFFC58',
  ['@lsp.mod.controlFlow.rust'] = '#00B0FF',
  ['@lsp.type.variable.rust'] = '#EEFFFF',
  ['@lsp.type.parameter.rust'] = '#EEFFFF',
  ['@lsp.type.property.rust'] = '#00FF9C',
  ['@lsp.type.operator.rust'] = '#D57BFF',
  ['@lsp.type.method.nix'] = '#EE6DFF',
  ['@lsp.type.type.nix'] = '#EE6DFF',
  ['@lsp.type.regexp.nix'] = '#FFFC58',
  ['@lsp.type.macro.nix'] = '#FFFC58',
  ['@lsp.type.variable.nix'] = '#EEFFFF',
  ['@variable.member.nix'] = '#EE6DFF',
  ['@function.nix'] = '#EE6DFF',
}

for group, color in pairs(expected) do
  assert_fg(group, color)
end

for _, path in ipairs(vim.api.nvim_get_runtime_file('queries/rust/highlights.scm', true)) do
  assert(not vim.startswith(path, root), 'project must not override the Rust highlight query: ' .. path)
end

print('highlight assertions passed')
