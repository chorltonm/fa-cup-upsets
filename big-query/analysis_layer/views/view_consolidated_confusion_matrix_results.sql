CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.analysis_layer.view_consolidated_confusion_matrix_results` AS

SELECT  

rcmr.metric_id, 
rcmr.metric,
basic_position, 
massey,
colley,
keener,
trueskill


FROM analysis_layer.ratings_model_confusion_matrix_results rcmr


ORDER BY rcmr.metric_id ASC
