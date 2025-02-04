SELECT distinct * FROM city
FULL OUTER JOIN country ON city.country_id = country.country_id; -- Full outer join