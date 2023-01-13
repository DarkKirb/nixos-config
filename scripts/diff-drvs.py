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


def get_name(drv):
    if "pname" in drv["env"]:
        return drv["env"]["pname"]
    name = drv["env"]["name"]
    if "version" in drvData["env"]:
        return name.removesuffix("-" + drvData["env"]["version"])
    return name


for drv in old_derivation:
    drvData = old_derivation[drv]
    if not "pname" in drvData["env"] and not "name" in drvData["env"]:
        continue
    used_name = get_name(drvData)
    if not "version" in drvData["env"]:
        continue
    version = drvData["env"]["version"]
    if used_name in packages:
        packages[used_name]["old"].add(version)
    else:
        packages[used_name] = {"old": {version}}

for drv in new_derivation:
    drvData = new_derivation[drv]
    if not "pname" in drvData["env"] and not "name" in drvData["env"]:
        continue
    used_name = get_name(drvData)
    if not "version" in drvData["env"]:
        continue
    version = drvData["env"]["version"]
    if used_name in packages:
        if "new" in packages[used_name]:
            packages[used_name]["new"].add(version)
        else:
            packages[used_name]["new"] = {version}
    else:
        packages[used_name] = {"new": {version}}

pkg_names = sorted(packages)

print("New packages")
for package in pkg_names:
    if "new" in packages[package] and "old" not in packages[package]:
        print(package + ": " + ", ".join(sorted(packages[package]["new"])))

print()
print("Old packages")
for package in pkg_names:
    if "old" in packages[package] and "new" not in packages[package]:
        print(package + ": " + ", ".join(sorted(packages[package]["old"])))

print()
print("Updated packages")
for package in pkg_names:
    if "old" in packages[package] and "new" in packages[package]:
        if packages[package]["old"] == packages[package]["new"]:
            continue
        common_versions = packages[package]["old"].intersection(
            packages[package]["new"])
        removed_versions = packages[package]["old"].difference(common_versions)
        added_versions = packages[package]["new"].difference(common_versions)
        common_versions_string = ", ".join(sorted(common_versions))
        removed_versions_string = ", ".join(sorted(removed_versions))
        added_versions_string = ", ".join(sorted(added_versions))
        print(
            f"{package}: [{removed_versions_string}] -> [{added_versions_string}] (common: {common_versions_string})"
        )
