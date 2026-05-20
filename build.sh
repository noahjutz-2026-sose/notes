#!/bin/bash

OUTPUT=$1

TARGET_DIRS=(
    "CG"
    "CR"
    "DW"
    "OR"
    "OS"
)

for dir in "${TARGET_DIRS[@]}"; do
    file="${dir}/main.typ"

    if [ ! -f "$file" ]; then
        exit 1
    fi

    typst compile "$file" "$OUTPUT/${dir}.pdf" \
        --font-path . \
        --ignore-system-fonts \
        --pdf-standard a-4 \
        --root src
done
