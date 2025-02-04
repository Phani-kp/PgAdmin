select customer_id, sum(amount) from payment
group by customer_id
having sum(amount)>100; -- Having clause allows us to fiter after an aggregation already taken place