{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.vscode];
  home.activation.vscode-server = lib.hm.dag.entryAfter ["write-boundary"] ''
    if test -f ~/.vscode-server; then
      if test -f "~/.vscode/extensions"; then
        if ! test -L "~/.vscode-server/extensions"; then
          $DRY_RUN_CMD ln -s $VERBOSE_ARG ~/.vscode/extensions ~/.vscode-server/
        fi
      fi
      if test -f "~/vscode-server/bin"; then
        for f in ~/.vscode-server/bin/*/node; do
          if ! test -L $f; then
            $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${pkgs.nodejs}/bin/node $f
          fi
        done
      fi
    fi
  '';
}
