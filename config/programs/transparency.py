#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.i3ipc

import i3ipc
import signal
import sys
from functools import partial

foreground_transparency = "0.9"
background_transparency = "0.7"


def on_window_focus(ipc, event):
    global prev_focused

    focused = event.container

    if focused.id != prev_focused.id:  # https://github.com/swaywm/sway/issues/2859
        if focused.fullscreen_mode > 0:
            focused.command("opacity 1")
        else:
            focused.command("opacity " + foreground_transparency)
        if prev_focused.fullscreen_mode == 0:
            prev_focused.command("opacity " + background_transparency)
        prev_focused = focused


def on_fullscreen_mode(ipc, event):
    global prev_focused
    if event.container.id == prev_focused.id:
        prev_focused = event.container

    if event.container.fullscreen_mode > 0:
        event.container.command("opacity 1")
    elif event.container.focused:
        event.container.command("opacity " + foreground_transparency)
    else:
        event.container.command("opacity " + background_transparency)


def remove_opacity(ipc):
    for workspace in ipc.get_tree().workspaces():
        for w in workspace:
            w.command("opacity 1")
    ipc.main_quit()
    sys.exit(0)


if __name__ == '__main__':
    ipc = i3ipc.Connection()
    prev_args = None

    for window in ipc.get_tree():
        if window.fullscreen_mode > 0:
            window.command("opacity 1")
        elif window.focused:
            prev_focused = window
            window.command("opacity " + foreground_transparency)
        else:
            window.command("opacity " + background_transparency)
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: remove_opacity(ipc))
    ipc.on("window::focus", on_window_focus)
    ipc.on("window::fullscreen_mode", on_fullscreen_mode)
    ipc.main()
