--Write your MySQL query statement below

 select name as Customers from Customers left join Orders on Customers.id = Orders.customerId where Orders.customerId is NULL;
-- left join takes all the customers, now searches the orders table if doesnt exist then for that customer customerId in Order table will be NULL so we check those

 select name as Customers from Customers c where not exists(
     select 1 from Orders o where o.customerId = c.id
 );
--for EVERY customer c:
    -- check whether an order exists for c.id

    -- if NO order exists:
    --     output that customer
