--we have two staff members, with staff IDs 1 and 2 so we want to
--give bonus to the staff member thta handled the most payments,
--{most in terns of number of payments processed, not total dollar amount}

select count(payment_id), staff_id from payment
group by staff_id
order by count(payment_id)  asc
;
-- solution also works as select staff_id, count(amount) from payment group by staff_id

