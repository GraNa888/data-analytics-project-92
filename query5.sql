top_10_total_income.csv 
select 
concat ("first_name", ' ', "last_name") as name, --  объедени first_name и last_name (с пробелом посередине) и назови столбец name
count (quantity) as operations, --  посчитай quantity и назови столбец operations, для этого объедени таблицы sales и employees по общему значению где sales_person_id = employee_id 
sum(price) as income --суммируй price и назови столбец income, для этого объедени таблицы sales и products по общему значению product_id
from sales
inner join employees
on sales.sales_person_id = employees.employee_id
inner join products 
on sales.product_id = products.product_id
group by first_name, last_name --  сгруппируй таблицу по first_name, last_name 
order by income DESC, operations desc
limit 10 --  отсортируй 10 позиций в порядке убывания по income и operations



lowest_average_income.csv 
select concat ("first_name", ' ', "last_name") as name, --объедени first_name и last_name (с пробелом посередине) и назови столбец name в таблице employees
round(sum(price)) as income --суммируй и округли до целых price и назови столбец income, для этого объедени таблицы sales и products по общему значению product_id 
from sales
inner join employees
on sales.sales_person_id = employees.employee_id
inner join products 
on sales.product_id = products.product_id
group by first_name, last_name --сгруппируй по имени и фамилии и отсей
having round(sum(price)) < (select avg(income) as average_income from( --округление по сумме до целых price МЕНЬШЕ при условии что выбран средний income и назван столбец average_income
  select --с помощью подзапроса выбери sales_person_id, sum(price) as income из таблицы products и присоедени по общему значению sales sales.product_id = products.product_id 
  sales_person_id, sum(price) as income
  from products
  inner join sales 
  on sales.product_id = products.product_id
  group by sales_person_id
) as a) --сгруппируй по sales_person_id и назави а
order by income;
--отсортируй все по income по возрастанию




day_of_the_week_income.csv 
select 
concat ("first_name", ' ', "last_name") as name, --объедени first_name и last_name (с пробелом посередине) и назови столбец name в таблице employees
to_char (sale_date, 'Day') as weekday, --преобразуй sale_date по дню недели, назови столбец weekday из sales
sum(price) as income --суммируй price и назови столбец income, для этого объедени таблицы sales и products по общему значению product_id
from sales 
right join employees
on sales.sales_person_id = employees.employee_id
left join products 
on sales.product_id = products.product_id
group by --сгруппируй по 
to_char (sale_date, 'ID'), --преобразованному sale_date по дню недели пон (1) - вск (7)
to_char (sale_date, 'Day'), --преобразованному sale_date дни недели
concat ("first_name", ' ', "last_name") --объедени first_name и last_name (с пробелом посередине)
order by --отсортируй по 
to_char(sale_date, 'ID'), --преобразованному sale_date по дню недели пон (1) - вск (7)
name --имени
