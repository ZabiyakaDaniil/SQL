--Total Sales
select
sum(sales)
from orders

--Total Profit
select
sum(profit)
from orders

--Profit Ratio
select
sum(sales), sum(profit), sum(profit)/sum(sales)*100 as Profit_ratio
from orders

--Avg.Discount
select
avg(discount)*100
from orders

