top_10_popular_products
  это ведь задание было в гугл шитс и я сделала сводную таблицу:
  по строке (ProductID) 
  по значениям Total Quantity (SUM), Quantity (MAX)
  Далее по формуле =MAX(B2:B72) посчитала максимальное значение Total Quantity 
  и от него уже отфильтровала значения по столбцам ProductID и MAX Quantity = FILTER(A2:C72,B2:B72>12000)

 top_10_profitable_products
  в сводной таблице добавила добавила таблицу продаж и через =VLOOKUP(A:A, E:F,2,false) где А = ProductID, E = ProductId (not sort), F = Price 
  посчитала Price for product
  Далее посчитала Amount (not sort) =B2*G2 где B = Total Quantity G = Price for product
  И отсортировала =SORT(D2:E72,{1},false) где D = Amount (not sort), E = ProductId (not sort)
  Далее снова сводная таблица по ProductID в порядке возрастания и Amount SUM
  Вывела на отдельную вкладку top_10_profitable_products.csv22 значения и округлила через =ROUNDUP($B$2:$B$11,0)
  https://docs.google.com/spreadsheets/d/1bpqzpNynzSUKqbCcqEbYVwCL8I15ldmCozWt8sKdT2Q/edit#gid=1057792642

  

SELECT COUNT(*) AS customers_count 
FROM customers; 
--посчитай уникальные значения customer_id из таблицы customers и переименуй столбец в customers_count
--SELECT COUNT(*) AS customers_count FROM customers; дополнительный запрос если нужно со значением NULL

top_10_total_income.csv 
select 
concat ("first_name", ' ', "last_name") as name, --  объедени first_name и last_name (с пробелом посередине) и назови столбец name
count (*) as operations, --  посчитай количество sales_id и назови столбец operations, для этого объедени таблицы sales и employees по общему значению где sales_person_id = employee_id 
floor(sum(price*quantity)) as income --суммируй произведение price и quantity и назови столбец income, для этого объедени таблицы sales и products по общему значению product_id
from sales
inner join employees
on sales.sales_person_id = employees.employee_id
inner join products 
on sales.product_id = products.product_id
group by first_name, last_name --  сгруппируй таблицу по first_name, last_name 
order by income DESC
limit 10 --  отсортируй 10 позиций в порядке убывания по income и operations


lowest_average_income.csv 
select 
	concat ("first_name", ' ', "last_name") as name, --объедени first_name и last_name (с пробелом посередине) и назови столбец name в таблице employees
	round(avg(price * quantity)) as average_income --найди среднне значение за сделку и назови столбец average_income, для этого объедени таблицы sales и products по общему значению product_id 
from sales
inner join employees 
on sales.sales_person_id = employees.employee_id
inner join products 
on sales.product_id = products.product_id
group by first_name, last_name --сгруппируй по имени и фамилии и отсей
having round(avg(price * quantity)) < 
(select sum(average_income) from (select avg(price * quantity) as average_income --найди среднне значение за сделку и назови столбец average_income, для этого объедени таблицы sales и products по общему значению product_id 
	from sales
	inner join employees 
	on sales.sales_person_id = employees.employee_id
	inner join products 
	on sales.product_id = products.product_id) as a)
order by average_income


day_of_the_week_income.csv 
select 
concat ("first_name", ' ', "last_name") as name, --объедени first_name и last_name (с пробелом посередине) и назови столбец name в таблице employees
to_char(sale_date, 'day') as weekday, --преобразуй sale_date по дню недели, назови столбец weekday из sales
round(sum(price*quantity)) as income --суммируй price и назови столбец income, для этого объедени таблицы sales и products по общему значению product_id
from sales 
inner join employees
on sales.sales_person_id = employees.employee_id
left join products 
on sales.product_id = products.product_id
group by --сгруппируй по 
to_char(sale_date, 'ID'), --преобразованному sale_date по дню недели пон (1) - вск (7)
to_char(sale_date, 'day'), --преобразованному sale_date дни недели
concat("first_name", ' ', "last_name") --объедени first_name и last_name (с пробелом посередине)
order by --отсортируй по 
to_char(sale_date, 'ID'), --преобразованному sale_date по дню недели пон (1) - вск (7)
name --имени

age_groups.csv

select (case  --выбери age_category с условием и посчитай customer_id из таблицы customers
when age between 16 and 25 then '16-25' --где возраст между 16 и 25, то назови столбец 16-25
when age between 26 and 40 then '26-40' --где возраст между 26 и 40, то назови столбец 26-40
when age >40 then '40+' --где возраст больше 40, то назови столбец 40+
end) as age_category, count(customer_id)
from customers 
group by age_category --сгруппируй по age_category
order by age_category --отсортируй по age_category

customers_by_month.csv
select --выбери
to_char(sale_date, 'YYYY-MM') as date, --преобразуй sale_date в YYYY-MM назови столбец date
count(distinct customer_id) as total_customers, -- посчитай уникальные значения customer_id назови столбец total_customers
round(sum(price * quantity),0) as income --суммируй price умноженный на quantity назови столбец income
from products p --за счет присоединения к таб products
inner join sales s -- таб sales
on p.product_id = s.product_id --по общему значению product_id
group by date -- сгруппируй по date 
order by date -- отсортируй по date автоматически по возрастанию


special_offer.csv 
select --выбери
concat (c.first_name, ' ', c.last_name) as customer, --и объедени c.first_name и c.last_name с пробеломб назови столбец customer
min(sale_date) as sale_date, --выбери min(sale_date) из sales
min(concat(e.first_name, ' ', e.last_name)) as seller -- объедени e.first_name и e.last_name с пробеломб назови столбец seller
from customers c 
inner join sales s -- таб sales
on c.customer_id = s.customer_id
inner join employees e --за счет левого присоединения к таб employees
on e.employee_id = s.sales_person_id --по общему значению employee_id
inner join products p
on p.product_id = s.product_id
where price = 0 --где price =0
group by c.customer_id, customer  --сгруппируй по c.customer_id, seller
order by c.customer_id --отсортируй по c.customer_id
