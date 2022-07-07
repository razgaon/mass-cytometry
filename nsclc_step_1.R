library(flowCore)
library(cyCombine)
library(tidyverse)
library(reticulate)

use_condaenv()

NSCLC <- "/nobackup1/razgaon/NSCLC"

filename <-"NSCLC_prepared_data.pickle"

fs_NSCLC <- NSCLC %>%
  cyCombine::compile_fcs()

# Rename the duplicate DNA channels in NSCLC to DNA1 and DNA2
chnls <- c("Ir191Di", "Ir193Di")
markers <- c("DNA1", "DNA2")
names(markers) <- chnls
markernames(fs_NSCLC) <- markers


panel_A <- prepare_data(flowset=fs_NSCLC,
    down_sample = F, batch_ids = "A", sample_ids = 1)
    
py_save_object(panel_A, filename, pickle = "pickle")
