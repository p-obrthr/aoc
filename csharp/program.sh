#!/bin/sh
set -e
day_dir="$1"
if [ -z "$day_dir" ]; then
    echo "Usage: $0 <day-folder>"
    exit 1
fi
project_file="aoc.csproj"
output_dir="/tmp/aoc/csharp"
tmp_build_dir=$(mktemp -d)
cp "$project_file" "$tmp_build_dir"
cp "$day_dir/main.cs" "$tmp_build_dir"
cp "$day_dir/input.txt" "$tmp_build_dir"
cd "$tmp_build_dir"
dotnet build --configuration Release --output "$output_dir"
exec dotnet "$output_dir/aoc.dll" "input.txt"
