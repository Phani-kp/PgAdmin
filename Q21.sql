SELECT DISTINCT city
FROM city
WHERE city ~'^[AEIOU]'
AND city ~'[aeiou]$'; 