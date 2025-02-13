/* Question 1: write a query for a specific market date to determine which vendor are new changing 
the booth that day, so we can contact them and ensure setup was smooth.
check it for date '2019-04-10'.  */

select * from
(select 
market_date, 
vendor_id, 
booth_number,
LAG(booth_number,1) over(partition by vendor_id order by market_date) as previous_booth_number
from vendor_booth_assignments ) t
where market_date = '2019-04-10'
and (t.booth_number <> t. previous_booth_number or t.previous_booth_number is not null)





/* Question 2: Find out if the total sales on each market date are higher or 
 lower than they were on the previous market day? */
 
 select *, 
    t.market_date_total_sales - t.previous_market_date_total_sales as increase_or_decrease
 from 
 (
 select 
    market_date,
    sum(quantity*cost_to_customer_per_qty) as market_date_total_sales,
    lag(sum(quantity*cost_to_customer_per_qty),1) over(order by market_date) as previous_market_date_total_sales
 from customer_purchases
 group by market_date
 ) t
 
 
 
 
/* Question 3:  Using the Vendor_boooth_assignment table in farmers_market database, display each 
vendor booth asssinment for each maket date alongside their previous booth assignments and order it by market_date */

select
   market_date, 
   vendor_id, 
   booth_number, 
   lag(booth_number,1) over(partition by vendor_id order by market_date) as previous_allocation,
   lead(booth_number,1) over(partition by vendor_id order by market_date) as previous_allocation
from vendor_booth_assignments
order by market_date
   
   
   
   
/* Question 4: Find the average amount spent on each market date. we want to consider only those
 days where the number of purchase were more than 3 the transaction amount was greater than 5. */
 
select 
   market_date,
   Round(avg(quantity * cost_to_customer_per_qty),2) as average_spent
from customer_purchases
where quantity*cost_to_customer_per_qty > 5
group by market_date 
having count(*) > 3




/*Question 5: Lets add customer details and vendor details to these results. Customers details are in the customer table 
and vendor details are in vendor table. */ 
select
 v.vendor_id,
 v.vendor_name,
 c.customer_id,
 concat(c.customer_first_name,' ',c.customer_last_name) as full_name,
 SUM(quantity * cost_to_customer_per_qty) as total_price
from customer_purchases cp
LEFT JOIN customer c ON cp.customer_id = c.customer_id
LEFT JOIN vendor v ON v.vendor_id = cp.vendor_id
group by
v.vendor_id,c.customer_id,v.vendor_name,c.customer_first_name,c.customer_last_name
order by v.vendor_id,c.customer_id;





/* Question 6: Filter out the vendors who bought least 100 items to the farmer's market over the
 period 2019-04-03 and 2019-05-16. */
 
 select 
   vendor_id,
   sum(quantity) as total_inventory 
 from vendor_inventory
 where market_date between 2019-04-03 and 2019-05-16
 group by vendor_id
 having sum(quantity) >=100
  
  
  
  
/* Question 7: Find out average amount spent on each market day. We want to consider only those days
where the number of purchase were more than 3 and the transaction amount was greater than 5 .  */  
  select 
   market_date,
   Round(avg(quantity * cost_to_customer_per_qty),2) as avg_spent
  from customer_purchases
  where quantity * cost_to_customer_per_qty > 5
  group by market_date
  having count(*)  > 3;




/* Question 8: Calculate the total price paid by custome_id 3 per market date? */
SELECT  
   market_date, 
   SUM(quantity * cost_to_customer_per_qty) AS total_price
FROM customer_purchases
WHERE customer_id = 3
GROUP BY market_date
ORDER BY market_date;




/*Question 9: What if we wanted to determine how much this customer has spent at each vendor, regardless of date? */
Select 
  market_date,
  vendor_id,
  sum(quantity * cost_to_customer_per_qty) as total_price
from customer_purchases 
where customer_id = 3
group by market_date, vendor_id
order by market_date





/* Question 10: What if we wanted to determine how much all customer has spent at each vendor, regardless of date. Data should
be in descending order on customer_id? */
Select 
  vendor_id,
  customer_id,
  sum(quantity * cost_to_customer_per_qty) as total_price
from customer_purchases 
group by 1,2
order by 2 desc,1




/* Question 11: Calculate the total quantity purchased by each customer per market date? */

select 
   market_date,
   sum(quantity) as total_quantity
   from customer_purchases
group by market_date
order by market_date