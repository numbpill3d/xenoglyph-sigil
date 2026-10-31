#!/usr/bin/env bash
# Xenoglyph — Sigil Clock (Plasma Widget): install.  ./install.sh
set -euo pipefail
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DST=${XDG_DATA_HOME:-$HOME/.local/share}/plasma/plasmoids/scorn.xenoglyph.sigil
rm -rf "$DST"; mkdir -p "$DST"
for f in "$HERE"/* "$HERE"/.[!.]*; do
    [[ -e $f ]] || continue
    case ${f##*/} in README.md|LICENSE|install.sh|screenshots|.git) continue ;; esac
    cp -r "$f" "$DST"/
done
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/fonts/xenoglyph"; cp "$HERE"/fonts/*.otf "${XDG_DATA_HOME:-$HOME/.local/share}/fonts/xenoglyph/"; fc-cache -f >/dev/null 2>&1 || true
echo "Installed. Right-click a panel > Add Widgets > Xenoglyph Sigil"
