library(ggplot2)

# Load the CSV
results <- read.csv("index_results.csv")

# Preview it
head(results)

ggplot(results, aes(x = log(num_distinct), y = log(avg_time))) +
    geom_point() +
    coord_flip() +
    labs(title = "Average Query Time by Index",
         x = "Log of Number of Distinct Values",
         y = "Log of Average Query Time (s)") +
    theme_minimal()

