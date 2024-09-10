CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.analysis_layer.view_ml_models_best_recall_param_grid` AS

WITH best_model_params

AS 
(
SELECT 

model_name_ranking,
best_parameters_gridsearchcv AS param_grid,
fold,
ROW_NUMBER() OVER (PARTITION BY model_name_ranking ORDER BY train_recall DESC) AS row_num,
train_recall

FROM birkbeck-msc-project-422917.analysis_layer.ml_model_fold_results

ORDER BY model_name_ranking ASC, train_recall DESC

)

SELECT 
model_name_ranking,
param_grid

FROM best_model_params

WHERE row_num = 1

