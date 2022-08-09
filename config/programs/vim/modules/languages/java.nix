{
  pkgs,
  lib,
  ...
}:
with lib; {
  output.config_file = ''
    lua << EOF
    vim.api.nvim_create_autocmd({"FileType"}, {
      local jdtls = require('jdtls')
      local root_markers = {'gradlew', '.git'}
      local root_dir = require('jdtls.setup').find_root(root_markers)
      local home = os.getenv('HOME')
      local workspace_folder = home .. "/.cache/nvim/java/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
      local config = {
        cmd = {
          '${pkgs.jdt-language-server}/bin/jdt-language-server',
          '-data', workspace_folder
        },
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = 'fernflower' },
          codeGeneration = {
            toString = {
              template = "\${object.className}{\${member.name()}=\${member.value}, \${otherMembers}}"
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          configuration = {
            runtimes = {
              {
                name = "JavaSE-17",
                path = "${pkgs.openjdk}",
              },
            }
          }
        },
        onAttach = function(client, bufnr)
          require('me.lsp.conf').on_attach(client, bufnr, {
            server_side_fuzzy_completion = true,
          })

          jdtls.setup_dap({hotcodereplace = 'auto'})
          jdtls.setup.add_commands()
          local opts = { silent = true, buffer = bufnr }
          vim.keymap.set('n', "<A-o>", jdtls.organize_imports, opts)
          vim.keymap.set('n', "<leader>df", jdtls.test_class, opts)
          vim.keymap.set('n', "<leader>dn", jdtls.test_nearest_method, opts)
          vim.keymap.set('n', "crv", jdtls.extract_variable, opts)
          vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
          vim.keymap.set('n', "crc", jdtls.extract_constant, opts)
          local create_command = vim.api.nvim_buf_create_user_command
          create_command(bufnr, 'W', require('me.lsp.ext').remove_unused_imports, {
            nargs = 0,
          })
        end
      }
    })
    EOF
  '';
}
