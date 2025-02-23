WITH lawyer_pairs AS(
    SELECT 
        a1.lawyer_id AS lawyer1_id,
        a2.lawyer_id AS lawyer2_id,
        t.title
    FROM attorney a1
    JOIN attorney a2 
        ON a1.trial_id = a2.trial_id 
        AND a1.lawyer_id < a2.lawyer_id  -- Avoid duplicate pairs (A, B) and (B, A)
    JOIN trial t 
        ON a1.trial_id = t.trial_id
), 
lawyer_names AS (
    SELECT 
        lawyer_id, 
        CONCAT(first_name, ' ', last_name) AS full_name
    FROM lawyer
), 
pair_counts AS (
    SELECT 
        lawyer1_id, 
        lawyer2_id, 
        COUNT(*) AS trial_count  -- Count how many times each pair appeared together
    FROM lawyer_pairs
    GROUP BY lawyer1_id, lawyer2_id
    ORDER BY trial_count DESC  -- Sort by most trials together
    LIMIT 1  -- Only select the pair with the most trials together
)
SELECT 
    ln1.full_name AS first_lawyer,
    ln2.full_name AS second_lawyer,
    lp.title
FROM lawyer_pairs lp
JOIN pair_counts pc 
    ON lp.lawyer1_id = pc.lawyer1_id AND lp.lawyer2_id = pc.lawyer2_id
JOIN lawyer_names ln1 
    ON lp.lawyer1_id = ln1.lawyer_id
JOIN lawyer_names ln2 
    ON lp.lawyer2_id = ln2.lawyer_id
ORDER BY lp.title;  -- Alphabetically by trial title
