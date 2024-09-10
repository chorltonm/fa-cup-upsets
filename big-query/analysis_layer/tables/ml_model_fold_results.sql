CREATE OR REPLACE TABLE `birkbeck-msc-project-422917.analysis_layer.ml_model_fold_results`

(
`Unnamed: 0` INT64,
    `model_name_ranking` STRING,
    `fold` INT64,
    `best_parameters_gridsearchcv` STRING,
    `best_recall_gridsearchcv` FLOAT64,
    `train_accuracy` FLOAT64,
    `train_recall` FLOAT64,
    `test_accuracy` FLOAT64,
    `test_recall` FLOAT64
)
