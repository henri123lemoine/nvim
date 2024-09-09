return {
  'jghauser/auto-pandoc.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = 'markdown',
  config = function()
    local auto_pandoc = require 'auto-pandoc'

    -- Function to run the custom pandoc command with improved error reporting and space handling
    _G.RunCustomPandoc = function()
      local input_file = vim.fn.shellescape(vim.fn.expand '%:p')
      local output_file = vim.fn.shellescape(vim.fn.fnamemodify(vim.fn.expand '%:p', ':r') .. '.pdf')
      local cmd = string.format('pandoc %s -o %s --pdf-engine=xelatex', input_file, output_file)

      vim.fn.jobstart(cmd, {
        on_stdout = function(_, data)
          if data and #data > 1 then
            vim.schedule(function()
              vim.notify(table.concat(data, '\n'), vim.log.levels.INFO)
            end)
          end
        end,
        on_stderr = function(_, data)
          if data and #data > 1 then
            vim.schedule(function()
              vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR)
            end)
          end
        end,
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.schedule(function()
              vim.notify('PDF generated successfully: ' .. vim.fn.expand '%:r' .. '.pdf', vim.log.levels.INFO)
            end)
          else
            vim.schedule(function()
              vim.notify('Failed to generate PDF. Exit code: ' .. exit_code, vim.log.levels.ERROR)
            end)
          end
        end,
      })
    end

    -- Create an autocommand group
    local augroup = vim.api.nvim_create_augroup('AutoPandoc', { clear = true })

    -- Set up keymaps for markdown files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      group = augroup,
      callback = function()
        -- Map 'go' to run auto-pandoc
        vim.keymap.set('n', 'go', function()
          auto_pandoc.run_pandoc()
        end, { buffer = true, desc = 'Run auto-pandoc' })

        -- Map 'gO' (shift+g, shift+o) to run the custom pandoc command
        vim.keymap.set('n', 'gO', function()
          RunCustomPandoc()
        end, { buffer = true, desc = 'Run custom pandoc command' })
      end,
    })
  end,
}
