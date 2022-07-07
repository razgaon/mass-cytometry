library(cyCombine)
library(tidyverse)
library(reticulate)

use_condaenv()

PBMC <- "/nobackup1/razgaon/PBMC"
filename <-"PBMC_prepared_data.pickle"

panel_B <- prepare_data(data_dir = PBMC,
    down_sample = F, batch_ids = "B", sample_ids = 1)

py_save_object(panel_B, filename, pickle = "pickle")