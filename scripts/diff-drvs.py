#!/usr/bin/env python3

import sys
import subprocess
import json

old_drv = sys.argv[1]
new_drv = sys.argv[2]

# Read both derivations recursively

old_derivation = json.load(open(old_drv))
new_derivation = json.load(open(new_drv))

packages = {}

for drv in old_derivation:
    drvData = old_derivation[drv]
    used_name = drvData["env"]["pname"] if "pname" in drvData["env"] else drvData["env"]["name"]
    version = drvData["env"]["version"] if "version" in drvData["env"] else drv
    if used_name in packages:
        packages[used_name]["old"].add(version)
    else:
        packages[used_name] = {"old": {version}}

for drv in new_derivation:
    drvData = new_derivation[drv]
    used_name = drvData["env"]["pname"] if "pname" in drvData["env"] else drvData["env"]["name"]
    version = drvData["env"]["version"] if "version" in drvData["env"] else drv
    if used_name in packages:
        if "new" in packages[used_name]:
            packages[used_name]["new"].add(version)
        else:
            packages[used_name]["new"] = {version}
    else:
        packages[used_name] = {"new": {version}}

for package in packages:
    if "old" in packages[package] and "new" in packages[package]:
        if packages[package]["old"] != packages[package]["new"]:
            print(
                f"{package}: {sorted(packages[package]['old'])} -> {sorted(packages[package]['new'])}"
            )
    elif "old" in packages[package]:
        print(f"{package}: {sorted(packages[package]['old'])} -> removed")
    elif "new" in packages[package]:
        print(f"{package}: added -> {sorted(packages[package]['new'])}")
