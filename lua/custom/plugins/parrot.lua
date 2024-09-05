-- parrot.nvim
-- https://github.com/frankroeder/parrot.nvim

return {
  { -- LLM autocomplete plugin
    'frankroeder/parrot.nvim',
    dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
    -- optionally include "rcarriga/nvim-notify" for beautiful notifications
    config = function()
      require('parrot').setup {
        -- Providers must be explicitly added to make them available.
        providers = {
          anthropic = {
            api_key = os.getenv 'ANTHROPIC_API_KEY',
            endpoint = 'https://api.anthropic.com/v1/messages',
            topic_prompt = 'You only respond with 3 to 4 words to summarize the past conversation.',
            -- usually a cheap and fast model to generate the chat topic based on
            -- the whole chat history
            topic = {
              model = 'claude-3-haiku-20240307',
              params = { max_tokens = 32 },
            },
            -- default parameters for the actual model
            params = {
              chat = { max_tokens = 4096 },
              command = { max_tokens = 4096 },
            },
          },
          -- gemini = {
          --   api_key = os.getenv "GEMINI_API_KEY",
          -- },
          -- groq = {
          --   api_key = os.getenv "GROQ_API_KEY",
          -- },
          -- mistral = {
          --   api_key = os.getenv "MISTRAL_API_KEY",
          -- },
          -- pplx = {
          --   api_key = os.getenv "PERPLEXITY_API_KEY",
          -- },
          -- -- provide an empty list to make provider available (no API key required)
          -- ollama = {},
          -- openai = {
          --   api_key = os.getenv 'OPENAI_API_KEY',
          -- },
          -- github = {
          --   api_key = os.getenv 'GITHUB_TOKEN',
          -- },
        },
        -- default system prompts used for the chat sessions and the command routines
        system_prompt = {
          chat = 'idk',
          command = 'idk either',
        },

        -- the prefix used for all commands
        cmd_prefix = 'Prt',

        -- optional parameters for curl
        curl_params = {},

        -- The directory to store persisted state information like the
        -- current provider and the selected models
        state_dir = vim.fn.stdpath('data'):gsub('/$', '') .. '/parrot/persisted',

        -- The directory to store the chats (searched with PrtChatFinder)
        chat_dir = vim.fn.stdpath('data'):gsub('/$', '') .. '/parrot/chats',

        -- Chat user prompt prefix
        chat_user_prefix = '🗨:',

        -- llm prompt prefix
        llm_prefix = '🦜:',

        -- Explicitly confirm deletion of a chat file
        chat_confirm_delete = true,

        -- When available, call API for model selection
        online_model_selection = false,

        -- Local chat buffer shortcuts
        chat_shortcut_respond = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g><C-g>' },
        chat_shortcut_delete = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>d' },
        chat_shortcut_stop = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>s' },
        chat_shortcut_new = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>c' },

        -- Option to move the cursor to the end of the file after finished respond
        chat_free_cursor = false,

        -- use prompt buftype for chats (:h prompt-buffer)
        chat_prompt_buf_type = false,

        -- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
        -- values: popup / split / vsplit / tabnew
        toggle_target = 'vsplit',

        -- The interactive user input appearing when can be "native" for
        -- vim.ui.input or "buffer" to query the input within a native nvim buffer
        -- (see video demonstrations below)
        user_input_ui = 'native',

        -- Popup window layout
        -- border: "single", "double", "rounded", "solid", "shadow", "none"
        style_popup_border = 'single',

        -- margins are number of characters or lines
        style_popup_margin_bottom = 8,
        style_popup_margin_left = 1,
        style_popup_margin_right = 2,
        style_popup_margin_top = 2,
        style_popup_max_width = 160,

        -- Prompt used for interactive LLM calls like PrtRewrite where {{llm}} is
        -- a placeholder for the llm name
        command_prompt_prefix_template = '🤖 {{llm}} ~ ',

        -- auto select command response (easier chaining of commands)
        -- if false it also frees up the buffer cursor for further editing elsewhere
        command_auto_select_response = true,

        -- fzf_lua options for PrtModel and PrtChatFinder when plugin is installed
        fzf_lua_opts = {
          ['--ansi'] = true,
          ['--sort'] = '',
          ['--info'] = 'inline',
          ['--layout'] = 'reverse',
          ['--preview-window'] = 'nohidden:right:75%',
        },

        -- Enables the query spinner animation
        enable_spinner = true,
        -- Type of spinner animation to display while loading
        -- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
        spinner_type = 'star',
      }
    end,
  },
}
