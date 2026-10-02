assert(vim.fn.executable('nixd') == 1, 'nixd is required for this test')

local root = vim.fn.getcwd()
vim.opt.runtimepath:prepend(root)
vim.cmd.edit(root .. '/tests/fixtures/reference.nix')
vim.bo.filetype = 'nix'
vim.cmd.colorscheme('cyberpunk')

local bufnr = vim.api.nvim_get_current_buf()
local client_id = assert(vim.lsp.start({
  name = 'cyberpunk-nixd-test',
  cmd = { 'nixd' },
  root_dir = root,
}))

assert(vim.wait(10000, function()
  local client = vim.lsp.get_client_by_id(client_id)
  return client and client.initialized
end, 50), 'nixd did not initialize')

local function position(text, occurrence)
  occurrence = occurrence or 1
  local seen = 0
  for row, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local from = 1
    while true do
      local col = line:find(text, from, true)
      if not col then break end
      seen = seen + 1
      if seen == occurrence then return row - 1, col - 1 end
      from = col + #text
    end
  end
  error('token not found: ' .. text)
end

local client = assert(vim.lsp.get_client_by_id(client_id))
local response = assert(client:request_sync(
  'textDocument/semanticTokens/full',
  { textDocument = vim.lsp.util.make_text_document_params(bufnr) },
  10000,
  bufnr
), 'nixd semantic token request timed out')
local data = assert(response.result and response.result.data, response.err and response.err.message or 'no semantic tokens')
local legend = {
  'function',
  'string',
  'number',
  'type',
  'keyword',
  'variable',
  'interface',
  'variable',
  'regexp',
  'macro',
  'method',
  'regexp',
  'regexp',
}
local semantic_tokens = {}
local line, start_col = 0, 0
for index = 1, #data, 5 do
  local delta_line, delta_col = data[index], data[index + 1]
  line = line + delta_line
  start_col = delta_line == 0 and start_col + delta_col or delta_col
  semantic_tokens[#semantic_tokens + 1] = {
    line = line,
    start_col = start_col,
    end_col = start_col + data[index + 2],
    type = legend[data[index + 3] + 1],
  }
end

if vim.env.CYBERPUNK_DEBUG_TOKENS then
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, token in ipairs(semantic_tokens) do
    print(token.type, token.line + 1, lines[token.line + 1]:sub(token.start_col + 1, token.end_col))
  end
end

local function assert_token(text, expected_type, occurrence)
  local row, col = position(text, occurrence)
  local tokens = vim.iter(semantic_tokens):filter(function(token)
    return token.line == row and token.start_col <= col and token.end_col > col
  end):totable()
  assert(
    vim.iter(tokens):any(function(token) return token.type == expected_type end),
    ('%s: expected semantic type %s, got %s; line tokens: %s'):format(
      text,
      expected_type,
      vim.inspect(tokens),
      vim.inspect(vim.iter(semantic_tokens):filter(function(token) return token.line == row end):totable())
    )
  )
end

assert_token('description', 'method')
assert_token('nixConfig', 'method')
assert_token('inputs', 'regexp', 1)
assert_token('inputs', 'method', 5)
assert_token('hasExt', 'type')
assert_token('true', 'macro')

client:stop()
print('nixd semantic token assertions passed')
