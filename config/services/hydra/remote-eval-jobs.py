#!@python3@
import sys
import subprocess
import os
import json

# First check if the server is up

if subprocess.run(["@ping@", "-c", "1", "rainbow-resort.int.chir.rs"], stdout=subprocess.DEVNULL).returncode != 0:
    os.execv("@nix-eval-jobs@", ["@nix-eval-jobs@"] + sys.argv[1:])

inputs_to_copy = set()

remote_args = []
skip_next = 0
next_to_copy = False
next_to_gcroots = False
gcroots = None

# parse arguments and add them to a list

for arg in sys.argv[1:]:
    if arg == "--gc-roots-dir" or arg == "--max-jobs" or arg == "--workers":
        skip_next = 2
    if arg == "--gc-roots-dir":
        next_to_gcroots = True
    if next_to_gcroots:
        next_to_gcroots = false    
        gcroots = arg
    if skip_next > 0:
        skip_next -= 1
        continue
    if next_to_copy:
        inputs_to_copy.add('='.join(arg.split('=')[1:]))
        next_to_copy = False
    if arg == "-I":
        next_to_copy = True
    remote_args.append(arg)

remote_args += ["--workers" "4"]

# copy over what files we need to ensure are present on the target

subprocess.run(["@nix@", "copy"] + list(inputs_to_copy) + ["--to", "ssh://build-rainbow-resort", "--no-check-sigs"], check=True, stdout=subprocess.DEVNULL)

# Evaluate on target
result = subprocess.run(["@ssh@", "build-rainbow-resort", "nix-eval-jobs"] + remote_args, check=True, stdout=subprocess.PIPE, text=True)

for line in result.stdout:
    try:
        data = json.loads(line)
        # copy .drv file home
        subprocess.run(["@nix@", "copy", data["drvPath"], "--from", "ssh://build-rainbow-resort", "--no-check-sigs"], check=True, stdout=subprocess.DEVNULL)
        # if we have a gcroot, add it to it
        if gcroots is not None:
            drvBasename = os.path.basename(data["drvPath"])
            os.symlink(data["drvPath"], os.path.join(gcroots, drvBasename))
        # Now we are done with this job, we can tell hydra about it
        print(line)
    except e:
        print(e, file=sys.stderr)