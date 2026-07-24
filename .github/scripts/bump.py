#!/usr/bin/env python3
# Bump Formula/anyvm.rb to the latest anyvm.py release on PyPI.
# Exits 0 with no file change when the formula is already current.

import json
import re
import urllib.request

FORMULA = "Formula/anyvm.rb"
PYPI_API = "https://pypi.org/pypi/anyvm.py/json"


def main():
    with urllib.request.urlopen(PYPI_API, timeout=30) as resp:
        data = json.load(resp)
    latest = data["info"]["version"]

    sdist = None
    for entry in data["releases"][latest]:
        if entry["packagetype"] == "sdist":
            sdist = entry
            break
    if sdist is None:
        raise SystemExit("no sdist on PyPI for anyvm.py " + latest)

    with open(FORMULA, "r", encoding="ascii") as fh:
        text = fh.read()

    m = re.search(r'url "([^"]*/anyvm_py-([0-9][^"]*)\.tar\.gz)"', text)
    if m is None:
        raise SystemExit("could not find the sdist url in " + FORMULA)
    current = m.group(2)
    if current == latest:
        print("formula already at " + latest)
        return

    text = text.replace(m.group(1), sdist["url"], 1)
    text = re.sub(
        r'sha256 "[0-9a-f]{64}"',
        'sha256 "' + sdist["digests"]["sha256"] + '"',
        text,
        count=1,
    )

    with open(FORMULA, "w", encoding="ascii", newline="\n") as fh:
        fh.write(text)
    print("bumped " + current + " -> " + latest)


if __name__ == "__main__":
    main()
