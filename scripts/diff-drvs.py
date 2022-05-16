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
    if "pname" in drvData["env"]:
        version = drvData["env"]["version"] if "version" in drvData["env"] else drv
        if drvData["env"]["pname"] in packages:
            packages[drvData["env"]["pname"]]["old"].add(version)
        else:
            packages[drvData["env"]["pname"]] = { "old": {version} }

for drv in new_derivation:
    drvData = new_derivation[drv]
    if "pname" in drvData["env"]:
        version = drvData["env"]["version"] if "version" in drvData["env"] else drv
        if drvData["env"]["pname"] in packages:
            if "new" in packages[drvData["env"]["pname"]]:
                packages[drvData["env"]["pname"]]["new"].add(version)
            else:
                packages[drvData["env"]["pname"]]["new"] = {version}
        else:
            packages[drvData["env"]["pname"]] = { "new": {version} }

for package in packages:
    if "old" in packages[package] and "new" in packages[package]:
        if packages[package]["old"] != packages[package]["new"]:
            print(f"{package}: {packages[package]['old']} -> {packages[package]['new']}")
    elif "old" in packages[package]:
        print(f"{package}: {packages[package]['old']} -> removed")
    elif "new" in packages[package]:
        print(f"{package}: added -> {packages[package]['new']}")
