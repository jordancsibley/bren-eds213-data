#!/bin/bash

# Jordan Sibley 
# May 7, 2025 

# bash query_timer.sh label num_reps query db_file csv_file

# arguments 
label="$1"
num_reps="$2"
query="$3"
db_file="$4"
csv_file="$5"

# create start timer
start_time=$(date +%s)

# run the query num_reps times
for i in $(seq "$num_reps"); do
    duckdb "$db_file" "$query" > /dev/null 2>&1
done

# end timer
end_time=$(date +%s)

# take difference of times to find total time 
total_time=$((end_time - start_time))

# compute average time by number of reps 
avg_time=$(echo "scale=6; $total_time / $num_reps" | bc)

# output avg time for each csv file 
echo "${label},${avg_time}" >> "$csv_file"