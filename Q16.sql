SELECT staff_id, ROUND(MIN(payment_id),2), SUM(payment_id) FROM Payment
GROUP BY payment_id, staff_id 
ORDER BY SUM(payment_id) ASC;