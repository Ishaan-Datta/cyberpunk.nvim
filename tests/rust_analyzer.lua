assert(vim.fn.executable('rust-analyzer') == 1, 'rust-analyzer is required for this test')

local root = vim.fn.getcwd()
local fixture_root = root .. '/tests/fixtures/rust'
vim.opt.runtimepath:prepend(root)
vim.cmd.edit(fixture_root .. '/src/lib.rs')
vim.bo.filetype = 'rust'
vim.cmd.colorscheme('cyberpunk')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.semanticTokens = {
  dynamicRegistration = false,
  requests = { range = true, full = { delta = true } },
  tokenTypes = {
    'namespace', 'type', 'class', 'enum', 'interface', 'struct', 'typeParameter', 'parameter',
    'variable', 'property', 'enumMember', 'event', 'function', 'method', 'macro', 'label', 'comment',
    'string', 'keyword', 'number', 'regexp', 'operator', 'decorator', 'angle', 'arithmetic',
    'attribute', 'attributeBracket', 'bitwise', 'boolean', 'brace', 'bracket', 'builtinAttribute',
    'builtinType', 'character', 'colon', 'comma', 'comparison', 'constParameter', 'const', 'derive',
    'deriveHelper', 'dot', 'escapeSequence', 'formatSpecifier', 'generic', 'invalidEscapeSequence',
    'lifetime', 'logical', 'macroBang', 'negation', 'parenthesis', 'procMacro', 'punctuation',
    'selfKeyword', 'selfTypeKeyword', 'semicolon', 'static', 'toolModule', 'typeAlias', 'union',
    'unresolvedReference',
  },
  tokenModifiers = {
    'declaration', 'definition', 'readonly', 'static', 'deprecated', 'abstract', 'async',
    'modification', 'documentation', 'defaultLibrary', 'attribute', 'callable', 'constant',
    'consuming', 'controlFlow', 'crateRoot', 'injected', 'intraDocLink', 'library', 'macro',
    'mutable', 'procMacro', 'public', 'reference', 'trait', 'unsafe',
  },
  formats = { 'relative' },
  overlappingTokenSupport = true,
  multilineTokenSupport = true,
}

local bufnr = vim.api.nvim_get_current_buf()
local client_id = assert(vim.lsp.start({
  name = 'cyberpunk-rust-analyzer-test',
  cmd = { 'rust-analyzer' },
  root_dir = fixture_root,
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      semanticHighlighting = {
        nonStandardTokens = true,
        operator = { enable = true, specialization = { enable = true } },
        punctuation = {
          enable = true,
          specialization = { enable = true },
          separate = { macro = { bang = true } },
        },
      },
    },
  },
}))

assert(vim.wait(20000, function()
  local client = vim.lsp.get_client_by_id(client_id)
  return client and client.initialized
end, 50), 'rust-analyzer did not initialize')

local client = assert(vim.lsp.get_client_by_id(client_id))
client:notify('workspace/didChangeConfiguration', { settings = client.settings })
vim.wait(10000)
local response = assert(client:request_sync(
  'textDocument/semanticTokens/full',
  { textDocument = vim.lsp.util.make_text_document_params(bufnr) },
  20000,
  bufnr
), 'rust-analyzer semantic token request timed out')
local data = assert(response.result and response.result.data, response.err and response.err.message or 'no semantic tokens')
local provider = assert(client.server_capabilities.semanticTokensProvider)
local token_types = provider.legend.tokenTypes
local token_modifiers = provider.legend.tokenModifiers
local semantic_tokens = {}
local line, start_col = 0, 0
for index = 1, #data, 5 do
  local delta_line, delta_col = data[index], data[index + 1]
  line = line + delta_line
  start_col = delta_line == 0 and start_col + delta_col or delta_col
  local modifier_bits = data[index + 4]
  local modifiers = {}
  for modifier_index, modifier in ipairs(token_modifiers) do
    if bit.band(modifier_bits, bit.lshift(1, modifier_index - 1)) ~= 0 then modifiers[modifier] = true end
  end
  semantic_tokens[#semantic_tokens + 1] = {
    line = line,
    start_col = start_col,
    end_col = start_col + data[index + 2],
    type = token_types[data[index + 3] + 1],
    modifiers = modifiers,
  }
end

local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
if vim.env.CYBERPUNK_DEBUG_TOKENS then
  for _, token in ipairs(semantic_tokens) do
    if token.line >= 15 then
      print(token.type, vim.inspect(token.modifiers), token.line + 1, lines[token.line + 1]:sub(token.start_col + 1, token.end_col))
    end
  end
end

local function position(text, occurrence)
  occurrence = occurrence or 1
  local seen = 0
  for row, source_line in ipairs(lines) do
    local from = 1
    while true do
      local col = source_line:find(text, from, true)
      if not col then break end
      seen = seen + 1
      if seen == occurrence then return row - 1, col - 1 end
      from = col + #text
    end
  end
  error('token not found: ' .. text)
end

local function assert_token(text, expected_type, occurrence, expected_modifier)
  local row, col = position(text, occurrence)
  local tokens = vim.iter(semantic_tokens):filter(function(token)
    return token.line == row and token.start_col <= col and token.end_col > col
  end):totable()
  assert(
    vim.iter(tokens):any(function(token)
      return token.type == expected_type and (not expected_modifier or token.modifiers[expected_modifier])
    end),
    ('%s: expected %s%s, got %s'):format(
      text,
      expected_type,
      expected_modifier and '.' .. expected_modifier or '',
      vim.inspect(tokens)
    )
  )
end

assert_token('crate', 'keyword')
assert_token('handle', 'function')
assert_token('_message', 'parameter')
assert_token('topic', 'property', 2)
assert_token('Start', 'enumMember', 2)
assert_token('if', 'keyword', 1, 'controlFlow')
assert_token('bool', 'builtinType')
assert_token('#', 'attributeBracket')

client:stop()
print('rust-analyzer semantic token assertions passed')
