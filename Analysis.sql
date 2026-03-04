create database END_TO_END_PROJECTS;
select * from customer_behaviour limit 5;

alter table customer_behaviour rename column `purchase amount` to purchase_amount;

-- 1)  What is the Total Revenue genrated by  male vs female customers  ?
select gender,SUM(purchase_amount) as REVENUE
 from customer_behaviour
group by gender;

-- 2) Which customer used a discount and but still spent more than the average purchase amount  ?
select customer_id,purchase_amount 
from customer_behaviour 
where discount_applied='Yes' and 
purchase_amount >= (select avg(purchase_amount) from customer_behaviour);


-- 3) Which are the top 5 products with the highest average review rating ?
select item_purchased,ROUND(AVG(review_rating),2) as Avg_Product_Rating
from customer_behaviour
group by item_purchased
order by AVG(review_rating) DESC
limit 5;

-- 4) Compare the average purchase amount between Standard and express shipping ?
select shipping_type,
ROUND(AVG(purchase_amount),2) as Avg_Purchase_Amount
from customer_behaviour
where shipping_type in ('Express','Standard')
group by shipping_type; 


-- 5) Do subscribed customers spend more ? Compare average spend and total revenue between subscribers and non subscribers.
select * from customer_behaviour limit 3;
select subscription_status,
COUNT(customer_id) as Total_Customers,
ROUND(AVG(purchase_amount),2) as Avg_Spend,
SUM(purchase_amount) as Total_Revenue
from customer_behaviour
group by subscription_status
order by Total_Revenue,Avg_Spend DESC;


-- 6) Which 5 products have highest percentage of purchases with discount applied ?

select item_purchased,
ROUND(100*SUM(case when discount_applied='Yes' then 1 else 0 end)/count(*),2) as discount_rate
from customer_behaviour 
group by item_purchased
order by discount_rate desc
limit 5;


-- 7) Segment customer into New, returning, and Loyal based on their
--  total number of previous purchases  and  show the count of each segment. 

-- (if purchase only one time -New , between 2-10-Returning customer,More than 10 time -Loyal customer)


with customer_type as (
select customer_id,previous_purchases,
case 
	when previous_purchases=1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal'
    end as customer_segment
from customer_behaviour)

select customer_segment,count(*) as 'No Of customers' 
from customer_type
group by customer_segment;
 
 
 -- 8) What are the top 3 most purchased products in each category  ?
 
 with item_count as(
 select category,item_purchased,
 count(customer_id) as total_orders,
 row_number() over(partition by category order by count(customer_id) desc) as item_rank
 from customer_behaviour
 group by category,item_purchased
 )
 select item_rank,category,item_purchased,total_orders
 from item_count
 where item_rank<=3;
 
 
 
 -- 9) Are customers who are repeat buyers (more than 5 previous purchases) also likely to be subscribe ?
 
 select subscription_status,
 count(customer_id) as repeat_buyers
 from customer_behaviour 
 where previous_purchases > 5
 group by subscription_status;
 
 select * from customer_behaviour;
 
 
 -- 10) What is the revenue contribution of each age group ?
 
 select age_group,
 sum(purchase_amount) as total_revenue
 from customer_behaviour
 group by age_group
 order by total_revenue desc;