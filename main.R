library(flowCore)
library(cyCombine)
library(tidyverse)

setwd("/nobackup1/razgaon")

GBM <- "/nobackup1/razgaon/GBM"
NSCLC <- "/nobackup1/razgaon/NSCLC"
PBMC <- "/nobackup1/razgaon/PBMC"


# fs_NSCLC <- read.FCS("/nobackup1/razgaon/NSCLC/236_Tcell_lung_Tcells-cd3.fcs")
fs_NSCLC <- NSCLC %>%
  cyCombine::compile_fcs()

# fs_PBMC <- read.FCS("/nobackup1/razgaon/PBMC/export_116183_Live CD45.fcs")
fs_PBMC <- PBMC %>%
 cyCombine::compile_fcs()


# Rename the duplicate DNA channels in NSCLC to DNA1 and DNA2
chnls <- c("Ir191Di", "Ir193Di")
markers <- c("DNA1", "DNA2")
names(markers) <- chnls
markernames(fs_NSCLC) <- markers

# Try to compile to flowset so we can change duplicate columns first (DNA -> DNA1 and DNA2)
# markernames(fs)

panel_A <- prepare_data(flowset=fs_NSCLC,
    down_sample = F, batch_ids = "A", sample_ids = 1)

panel_B <- prepare_data(flowset = fs_PBMC,
    down_sample = F, batch_ids = "B", sample_ids = 1)
    
    
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

start_time_cC
end_time_cC
