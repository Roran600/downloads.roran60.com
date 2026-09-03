#!/usr/bin/env bash
set -euo pipefail

readonly SOURCE_ROOT="static/files"
readonly GENERATED_ROOT="content/files"

rm -rf "${GENERATED_ROOT}"
mkdir -p "${GENERATED_ROOT}"

generate_directory_page() {
  local source_dir="$1"
  local relative_dir="$2"
  local target_dir="${GENERATED_ROOT}"

  if [[ -n "${relative_dir}" ]]; then
    target_dir="${GENERATED_ROOT}/${relative_dir}"
  fi

  mkdir -p "${target_dir}"
  printf '%s\n' \
    '---' \
    'title: Files' \
    "file_directory: '${relative_dir}'" \
    '---' \
    '' \
    "{{< directory-browser \"${relative_dir}\" >}}" \
    > "${target_dir}/_index.md"

  local entry name child_relative
  for entry in "${source_dir}"/*; do
    [[ -e "${entry}" ]] || continue
    name="${entry##*/}"
    [[ "${name}" == .* ]] && continue
    [[ -d "${entry}" ]] || continue

    child_relative="${name}"
    if [[ -n "${relative_dir}" ]]; then
      child_relative="${relative_dir}/${name}"
    fi
    generate_directory_page "${entry}" "${child_relative}"
  done
}

if [[ -d "${SOURCE_ROOT}" ]]; then
  generate_directory_page "${SOURCE_ROOT}" ""
fi
