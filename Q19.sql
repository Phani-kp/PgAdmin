SELECT DISTINCT city
FROM city
WHERE city ~'[aeiou]$'; -- ~ expression is used to match the character and []$ is used for ending words