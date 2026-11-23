#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <input_xml_file> <output_txt_file>"
    echo "Example (from sophpi/scripts): $0 subtree-licheervnano.xml git_version_licheervnano.txt"
    echo "Example (from workspace root): $0 sophpi/scripts/subtree-licheervnano.xml sophpi/scripts/git_version_licheervnano.txt"
    exit 1
fi

XML_FILE="$1"
OUT_FILE="$2"

if [[ ! -f "$XML_FILE" ]]; then
    echo "ERROR: XML file not found: $XML_FILE"
    exit 1
fi

# Вычисляем корень <WORKSPACE> на два уровня выше папки, где лежит сам скрипт (sophpi/scripts/../../)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Workspace root: $WORKSPACE_DIR"
> "$OUT_FILE"

while IFS= read -r line; do
    # Пропускаем комментарии
    [[ "$line" =~ ^[[:space:]]*\<!-- ]] && continue

    repo=$(echo "$line" | grep -o '<project[^>]*name="[^"]*"' | sed 's/.*name="\([^"]*\)".*/\1/')
    [[ -z "$repo" ]] && continue

    remote_url=$(echo "$line" | grep -o 'remote_url="[^"]*"' | sed 's/.*remote_url="\([^"]*\)".*/\1/')
    path=$(echo "$line" | grep -o 'path="[^"]*"' | sed 's/.*path="\([^"]*\)".*/\1/')
    [[ -z "$path" ]] && path="$repo"

    # Пропускаем ваши форки (у которых задан кастомный remote_url не на sophgo)
    if [[ -n "$remote_url" && "$remote_url" != *"sophgo"* ]]; then
        echo "Skip fork: $repo ($path)"
        continue
    fi

    full_repo_path="$WORKSPACE_DIR/$path"

    if [[ -d "$full_repo_path/.git" ]]; then
        proj_name=$(basename "$repo")
        commit_info=$(git -C "$full_repo_path" log -1 --format="%H %s")

        echo "project_name: $proj_name" >> "$OUT_FILE"
        echo "commit_id: $commit_info" >> "$OUT_FILE"
        echo "" >> "$OUT_FILE"
        echo "Added: $proj_name -> $(echo "$commit_info" | cut -c1-12)"
    else
        echo "Warning: directory $full_repo_path not found!"
    fi
done < "$XML_FILE"

echo -e "\nГотово! Файл сохранен: $OUT_FILE"
