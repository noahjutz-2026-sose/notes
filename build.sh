#!/bin/bash

OUTPUT=$1

TARGET_DIRS=(
    "CG"
    "CR"
    "DW"
    "OR"
    "OS"
    "BA"
)

for dir in "${TARGET_DIRS[@]}"; do
    file="src/${dir}/main.typ"

    if [ ! -f "$file" ]; then
        echo $file not found.
        exit 1
    fi

    typst compile "$file" "$OUTPUT/${dir}.pdf" \
        --font-path . \
        --ignore-system-fonts \
        --pdf-standard a-4 \
        --root src
done
