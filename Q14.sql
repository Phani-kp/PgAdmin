Select ROUND(avg(replacement_cost),2),--IT TAKES TO PARAMETERS AND SHOULD BE USED IN (), TO CALL DECIMAL PLACES USE USE ROUND
min(replacement_cost),
max(replacement_cost),
sum(replacement_cost),
count(replacement_cost) from film -- aggreration functions