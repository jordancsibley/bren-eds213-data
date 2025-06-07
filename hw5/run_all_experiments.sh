#!/bin/bash

query="SELECT Nest_ID FROM Bird_nests WHERE Site = 'nome' AND Species = 'ruff' AND Year = 1983 AND Observer = 'cbishop' AND ageMethod = 'float';"
db="big-fat.sqlite3"
csv="index_results.csv"

# Clear the CSV file first
echo "\"label\",\"avg_time\",\"num_distinct\"" > $csv

# Experiment 1: no index
./query_timer_bash.sh "none" 1 "$query" "$db" "$csv"

# Single-column indexes
for col in Site Species Year Observer ageMethod; do
    sqlite3 $db "CREATE INDEX idx_${col} ON Bird_rnests(${col});"
    ./query_timer_bash.sh "$col" 1 "$query" "$db" "$csv"
    sqlite3 $db "DROP INDEX idx_${col};"
done

# Multi-column indexes
declare -a combos=(
    "Site,Species"
    "Site,Observer"
    "Species,Observer"
    "Year,Observer"
    "Observer,ageMethod"
    "Site,Species,Observer"
    "Site,Year,Observer"
    "Species,ageMethod,Year,Observer"
    "Species,ageMethod,Year"
)

for combo in "${combos[@]}"; do
    index_name="idx_$(echo $combo | tr ', ' '_')"
    sqlite3 $db "CREATE INDEX $index_name ON Bird_nests($combo);"
    "./query_timer_bash.sh" "$combo" 1 "$query" "$db" "$csv"
    sqlite3 $db "DROP INDEX $index_name;"
done
