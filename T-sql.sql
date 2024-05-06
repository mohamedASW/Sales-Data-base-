use SampleDB
go
SELECT category_name  FROM production.categories
order by category_name desc

SELECT Upper(ProDuct_Name) as [product name] from production.products

select * from sales.orders

select * from sales.order_items

go

CREATE OR ALTER FUNCTION GET_TOTAL_DISCOUNT(@list_price decimal(10,2) ,@discount decimal(4,2))
returns money 
as
begin 

declare @result money; 
select @result = convert(money,(1-@discount)*@list_price);
return @result;
end 

Select p.product_name , SUM(dbo.GET_TOTAL_DISCOUNT(OI.list_price,OI.discount)) AS "TOTALPRICE" from production.products P
inner join sales.order_items OI
ON P.product_id=OI.product_id
GROUP BY P.product_name

select * from sales.customers
where  customer_id <> 1 and first_name like '_%a%'
order by customer_id

Select e.staff_id AS "Employee ID" ,CONCAT(e.first_name,' ',e.last_name) AS "Employee Name" , m.staff_id AS "Manger ID" ,CONCAT(M.first_name,' ',M.last_name) AS "Manger Name" from 
sales.staffs e
inner join 
sales.staffs m
on e.manager_id = m.staff_id
go 
create or alter  trigger sales.orderdetailtriger on sales.order_items
  after insert 
  as 
  begin 
  update PRODUCTION.Stocks
  set Quantity = st.Quantity-i.quantity
  from sales.orders o
  join 
  inserted i on 
  i.order_id = o.order_id
  join PRODUCTION.Stocks st
  on 
  st.product_id = i.product_id
  and st.store_id = o.store_id
  end
 



  insert into SALES.Orders(Order_id,Customer_id,Store_id)
  values 
  (800,2,100)
  insert into SALES.Order_Items
  values 
  (800,17,6,190,0.5)


  

  update production.stocks
  set  quantity= 100
  where store_id=100 and product_id=17

  insert into SALES.Orders(Order_id,Customer_id,Store_id)
  values 
  (800,2,100)

  delete from SALES.Order_Items
  where order_id =800


  insert into SALES.Order_Items
  values 
  (800,17,10,190,0.5),
  (800,21,95,190,0.5)

  SELECT * from SALES.Orders
  SELECT * from SALES.Order_Items
  SELECT * from SALES.Stores
  select*from PRODUCTION.Stocks
  select * from production.products


  go
  create or alter  trigger sales.orderdetailtriger on sales.order_items
  instead of insert 
  as   
  begin
  declare @order_detail table(
  order_id int ,
  produt_id int,
  quantity int ,
  list_price decimal,
  discount int,
  store_id int
  )
  insert into @order_detail(order_id,produt_id,quantity,list_price,discount,store_id)
  select i.order_id,i.product_id,i.quantity,i.list_price,i.discount,o.store_id 
  from 
 sales.orders o
  join 
  inserted i on 
  i.order_id = o.order_id
  join PRODUCTION.Stocks st
  on 
  st.product_id = i.product_id
  and st.store_id = o.store_id
  where st.quantity > i.quantity
  update production.stocks
  set quantity = s.quantity - od.quantity
  from production.stocks s
  join @order_detail od
  on s.product_id=od.produt_id 
  and s.store_id =od.store_id
  insert into sales.order_items(order_id,product_id,quantity,list_price,discount)
  select order_id,produt_id,quantity,list_price,discount from @order_detail


  select i.order_id,i.product_id,i.quantity,i.list_price,i.discount ,'row not added' as [status] from inserted i , @order_detail od
  where i.order_id<>od.order_id or i.product_id<>od.produt_id
  end
 
 drop trigger sales.orderdetailtriger

