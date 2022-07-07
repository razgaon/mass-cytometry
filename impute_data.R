library(flowCore)
library(cyCombine)
library(tidyverse)
library(reticulate)

use_condaenv()


NSCLC <-"NSCLC_prepared_data.pickle"
PBMC <-"PBMC_prepared_data.pickle"

panel_NSCLC <- py_load_object(NSCLC)
print("Loaded NSCLC")

panel_PBMC <- py_load_object(PBMC)
print("Loaded PBMC")



impute_with_batching <- function(dataset1, dataset2, num_of_batches){
    print("Starting imputation with batching")

    dataset1_total_entries <- nrow(dataset1)    
    dataset1_batch_size <- dataset1_total_entries / num_of_batches
    
    dataset2_total_entries <- nrow(dataset2)    
    dataset2_batch_size <- dataset2_total_entries / num_of_batches
    
    dataset1_index <- 1
    dataset2_index <- 1
    # TODO: CHANGE
    for (i in 1:3) {
        print(paste("Imputing batch ", i))
        dataset1_batch <- dataset1[dataset1_index: dataset1_index + dataset1_batch_size,]
        dataset2_batch <- dataset2[dataset2_index: dataset2_index + dataset2_batch_size,]
        
        print(nrow(dataset1_batch))
        print(nrow(dataset2_batch))
        
        dataset1_index <- dataset1_index + dataset1_batch_size
        dataset2_index <- dataset2_index + dataset2_batch_size
        
        imputed_panel = impute_panels(dataset1_batch, dataset2_batch)
        if(i == 1){
            total_imputed <- imputed_panel
        }else{
            total_imputed <- rbind(total_imputed, imputed_panel)
        }
        
        
        print(paste("Completed imputation of batch ", i))
    }
    
    print("Completing imputation with batching")
    return(total_imputed)
    
}

impute_panels <- function(dataset1, dataset2){
    overlap_AB <- intersect(get_markers(dataset1), get_markers(dataset2))

    # Define markers unique to each panel
    missing_A <- get_markers(dataset2)[!(get_markers(dataset2) %in%
        overlap_AB)]
    missing_B <- get_markers(dataset1)[!(get_markers(dataset1) %in%
        overlap_AB)]
    
    # Perform imputations
    panel_AB <- impute_across_panels(dataset1 = dataset1, dataset2 = dataset2,
        overlap_channels = overlap_AB, impute_channels1 = missing_A,
        impute_channels2 = missing_B)
    
    # Combine the dataframes for each set
    panel_AB <- rbind(panel_AB$dataset1, panel_AB$dataset2)
    
    return(panel_AB)
}

imputed_panel <- impute_with_batching(panel_NSCLC, panel_PBMC, 10)

py_save_object(imputed_panel, "imputed_data.pickle", pickle = "pickle")
