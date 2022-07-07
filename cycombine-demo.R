library(cyCombine)
library(tidyverse)

###

data_dir <- "/nobackup1/razgaon/FR-FCM-ZYV2/"

# Load five panels' data - here we assume no substantial
# batch effects between the five samples
panel_A <- prepare_data(data_dir = data_dir, pattern = "#A",
    down_sample = F, batch_ids = "A", sample_ids = 1)
panel_B <- prepare_data(data_dir = data_dir, pattern = "#B",
    down_sample = F, batch_ids = "B", sample_ids = 1)
panel_C <- prepare_data(data_dir = data_dir, pattern = "#C",
    down_sample = F, batch_ids = "C", sample_ids = 1)
panel_D <- prepare_data(data_dir = data_dir, pattern = "#D",
    down_sample = F, batch_ids = "D", sample_ids = 1)
panel_E <- prepare_data(data_dir = data_dir, pattern = "#E",
    down_sample = F, batch_ids = "E", sample_ids = 1)
    
# Define the overlap (16 markers)
overlap_AB <- intersect(get_markers(panel_A), get_markers(panel_B))

# Define markers unique to each panel
missing_A <- get_markers(panel_B)[!(get_markers(panel_B) %in%
    overlap_AB)]
missing_B <- get_markers(panel_A)[!(get_markers(panel_A) %in%
    overlap_AB)]

# Perform imputations (and measure runtime)
start_time_cC <- Sys.time()
panel_AB <- impute_across_panels(dataset1 = panel_A, dataset2 = panel_B,
    overlap_channels = overlap_AB, impute_channels1 = missing_A,
    impute_channels2 = missing_B)
end_time_cC <- Sys.time()

# Combine the dataframes for each set
panel_AB <- rbind(panel_AB$dataset1, panel_AB$dataset2)

# Define the overlap (16 markers)
overlap_CD <- intersect(get_markers(panel_C), get_markers(panel_D))

# Define markers unique to each panel
missing_C <- get_markers(panel_D)[!(get_markers(panel_D) %in%
    overlap_CD)]
missing_D <- get_markers(panel_C)[!(get_markers(panel_C) %in%
    overlap_CD)]

# Perform imputations
panel_CD <- impute_across_panels(dataset1 = panel_C, dataset2 = panel_D,
    overlap_channels = overlap_CD, impute_channels1 = missing_C,
    impute_channels2 = missing_D)


# Combine the dataframes for each set
panel_CD <- rbind(panel_CD$dataset1, panel_CD$dataset2)

# And let's look at the marker density of A+B and C+D
# relative to the full panel (E)
plot_density(uncorrected = panel_E, corrected = rbind(panel_AB[,
    colnames(panel_E)], panel_CD[, colnames(panel_E)]), dataset_names = c("Panel E",
    "Panel A+B and C+D"), ncol = 5)
    
    
x <- 1
x
