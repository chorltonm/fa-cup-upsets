CREATE VIEW analysis_layer.view_consolidated_confusion_matrix_results 

AS

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