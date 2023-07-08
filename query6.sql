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
sum(price) as income --суммируй price назови столбец income
from products p --за счет левого присоединения к таб products
left join sales s -- таб sales
on p.product_id = s.product_id --по общему значению product_id
group by date --сгруппируй по date автоматически по возрастанию


special_offer.csv 
select --выбери
concat (c.first_name, ' ', c.last_name) as customer, --и объедени c.first_name и c.last_name с пробеломб назови столбец customer
min(sale_date) as sale_date, --выбери min(sale_date) из sales
concat (e.first_name, ' ', e.last_name) as seller -- объедени e.first_name и e.last_name с пробеломб назови столбец seller
from products p --за счет левого присоединения к таб products
left join sales s -- таб sales
on p.product_id = s.product_id --по общему значению product_id
Left join employees e --за счет левого присоединения к таб employees
on e.employee_id = s.sales_person_id --по общему значению employee_id
Left join customers c --за счет левого присоединения таб customers
on c.customer_id = s.customer_id --по значению customer_id
where price = 0 --где price =0
group by c.customer_id, seller --сгруппируй по c.customer_id, seller
order by c.customer_id --отсортируй по c.customer_id