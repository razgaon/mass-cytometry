library(cyCombine)
library(tidyverse)
library(reticulate)

use_condaenv()

PBMC <- "/nobackup1/razgaon/PBMC_TEST_1"
filename <-"PBMC_prepared_data_test.pickle"

panel_B <- prepare_data(data_dir = PBMC, filename_col = "name",
    down_sample = F, batch_ids = "0", sample_ids = 1)

py_save_object(panel_B, filename, pickle = "pickle")