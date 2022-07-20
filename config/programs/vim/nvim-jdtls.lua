vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"java"},
    callback = function()
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        local workspace_dir = '@userhome@/.cache/jdtls/' .. project_name

        local config = {
            cmd = {
                '@java@',
                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                '-Dosgi.bundles.defaultStartLevel=4',
                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                '-Dlog.protocol=true',
                '-Dlog.level=ALL',
                '-Xms1g',
                '--add-modules=ALL-SYSTEM',
                '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                '-jar', '@launcher@',
                '-configuration', '@jdtLanguageServer@/share/config',
                '-data', workspace_dir,
            }

            root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
            settings = {
                java = {
                }
            },
            init_options = {
                bundles = {}
            },
        };

        require('jdtls').start_or_attach(config)
    end
})
