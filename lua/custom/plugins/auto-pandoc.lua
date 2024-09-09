return {
  'jghauser/auto-pandoc.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = 'markdown',
  config = function()
    local auto_pandoc = require 'auto-pandoc'

    -- Helper function to run shell commands
    local function run_command(cmd)
      local output = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify('Error: ' .. output, vim.log.levels.ERROR)
      else
        vim.notify('Success: ' .. cmd, vim.log.levels.INFO)
      end
    end

    -- Function to generate PDF
    local function generate_pdf()
      local input = vim.fn.shellescape(vim.fn.expand '%:p')
      local output = vim.fn.shellescape(vim.fn.expand '%:p:r' .. '.pdf')
      run_command(string.format('pandoc %s -o %s --pdf-engine=xelatex', input, output))
    end

    -- Function to generate HTML with MathJax support
    local function generate_html()
      local input = vim.fn.shellescape(vim.fn.expand '%:p')
      local output = vim.fn.shellescape(vim.fn.expand '%:p:r' .. '.html')
      local mathjax_url = vim.fn.shellescape 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-AMS_CHTML-full'
      local title = vim.fn.shellescape(vim.fn.expand '%:t:r')
      run_command(string.format('pandoc %s -o %s --mathjax=%s --standalone --metadata title=%s', input, output, mathjax_url, title))
    end

    -- Function to generate both PDF and HTML
    local function generate_both()
      generate_pdf()
      generate_html()
    end

    -- Set up keymaps for markdown files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        -- Map 'go' to run auto-pandoc (uses YAML frontmatter)
        vim.keymap.set('n', 'go', auto_pandoc.run_pandoc, { buffer = true, desc = 'Run auto-pandoc' })

        -- Map 'gp' to generate PDF
        vim.keymap.set('n', 'gp', generate_pdf, { buffer = true, desc = 'Generate PDF' })

        -- Map 'gh' to generate HTML
        vim.keymap.set('n', 'gh', generate_html, { buffer = true, desc = 'Generate HTML' })

        -- Map 'gb' to generate both PDF and HTML
        vim.keymap.set('n', 'gb', generate_both, { buffer = true, desc = 'Generate PDF and HTML' })
      end,
    })
  end,
}
