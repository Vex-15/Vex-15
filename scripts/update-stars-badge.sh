#!/usr/bin/env bash
# Computes total stars across all public repos for GITHUB_USER
# and writes a shields.io "endpoint" schema JSON file that the
# README badge reads directly from raw.githubusercontent.com.
set -euo pipefail

GITHUB_USER="Vex-15"
OUTPUT_FILE="badges/stars.json"

page=1
total=0
while :; do
  response=$(curl -s "https://api.github.com/users/${GITHUB_USER}/repos?per_page=100&page=${page}")
  count=$(echo "$response" | jq 'length')
  if [ "$count" -eq 0 ]; then
    break
  fi
  page_total=$(echo "$response" | jq '[.[].stargazers_count] | add')
  total=$((total + page_total))
  page=$((page + 1))
done

mkdir -p badges
cat > "$OUTPUT_FILE" << EOF
{
  "schemaVersion": 1,
  "label": "Total Stars",
  "message": "${total}",
  "color": "1F6FEB",
  "labelColor": "0d1117"
}
EOF

echo "Total stars: ${total}"
