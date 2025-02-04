SELECT DISTINCT city
FROM city
WHERE city ~'^[AEIOU]'; -- ~ expression is used to match the character sequence and ^[] is used for Starting words