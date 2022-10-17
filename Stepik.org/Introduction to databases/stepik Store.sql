--Вывод списка продуктов с наименование категории для каждого продукта.
select * from product p
inner join category c
on p.category_id = c.category_id

--Вывод названия продукта, категории и цены.
select product.product_name, category.category_name, product.price 
from product p
inner join category c
on p.category_id = c.category_id

--Выведите все позиции списка товаров принадлежащие какой-либо категории с названиями товаров и названиями категорий. 
--Список должен быть отсортирован по названию товара, названию категории.
select g.name as good_name,  c.name as category_name
from good g
inner join category_has_good ch
on g.id = ch.good_id
inner join category c
on ch.category_id = c.id
order by 1, 2

--Выведите список клиентов (имя, фамилия) и количество заказов данных клиентов, имеющих статус "new".
select c.first_name as first_name,  c.last_name as last_name, count(sl.id) as new_sale_num
from client c
inner join sale sl
on c.id = sl.client_id
inner join status st
on sl.status_id = st.id
where st.name = 'new'
group by first_name, last_name;

--Выведите список товаров с названиями товаров и названиями категорий, в том числе товаров, не принадлежащих ни одной из категорий.
select g.name as good_name, c.name as category_name
from good g
left join category_has_good ch
on g.id=ch.good_id
left join category c
on ch.category_id=c.id
order by good_name

--Выведите список товаров с названиями категорий, в том числе товаров, не принадлежащих ни к одной из категорий,
--в том числе категорий не содержащих ни одного товара.
select g.name as good_name, c.name as category_name
from good g
left join category_has_good ch
on g.id=ch.good_id
left join category c
on ch.category_id=c.id
union
select g.name as good_name, c.name as category_name
from good g
left join category_has_good ch
on g.id=ch.good_id
right join category c
on ch.category_id=c.id
order by good_name

--Выведите названия товаров, которые относятся к категории 'Cakes' или фигурируют в заказах текущий статус которых 'delivering'.
--Результат не должен содержать одинаковых записей.
select g.name as good_name
from good g
join category_has_good ch
on g.id=ch.good_id
join category c
on ch.category_id=c.id
where c.name = 'Cakes'
union
select g.name as good_name
from good g
join sale_has_good sh
on g.id=sh.good_id
join sale sl
on sh.sale_id=sl.id
join status st
on sl.status_id=st.id
where st.name='delivering'
order by good_name

--Выведите список всех категорий продуктов и количество продаж товаров, относящихся к данной категории.
--Под количеством продаж товаров подразумевается суммарное количество единиц товара данной категории, фигурирующих в заказах с любым статусом.
select c.name as name, count(sl.id) as sale_num
from category c
left join category_has_good ch
on c.id=ch.category_id
left join good g
on ch.good_id=g.id
left join sale_has_good sh
on g.id=sh.good_id
left join sale sl
on sh.sale_id=sl.id
group by name
order by name

--Выведите список источников, из которых не было клиентов, либо клиенты пришедшие из которых не совершали заказов или отказывались от заказов.
--Под клиентами, которые отказывались от заказов, необходимо понимать клиентов, у которых есть заказы,
--которые на момент выполнения запроса находятся в состоянии 'rejected'.
select s.name as source_name
from source s
where not exists (select * from client c
where c.source_id=s.id)
Union
select s.name as source_name
from source s
join client c
on s.id=c.source_id
join sale sl
on c.id=sl.client_id
join status st
on sl.status_id=st.id
where st.name='rejected'
order by source_name

--Удалите из таблицы client поля code и source_id.

alter table store.client
drop column code,
drop column source_id,
drop foreign key fk_client_source1

--Добавьте в таблицу sale_has_good следующие поля:
--Название: num, тип данных: INT, возможность использования неопределенного значения: Нет
--Название: price, тип данных: DECIMAL(18,2), возможность использования неопределенного значения: Нет

alter table sale_has_good
add column num int not null,
add column price decimal(18,2) not null

--Добавьте в таблицу client поле source_id тип данных: INT, возможность использования неопределенного значения: Да.
--Для данного поля определите ограничение внешнего ключа как ссылку на поле id таблицы source.

alter table client
add column source_id int,
add constraint fk_source_id foreign key (source_id) references source(id)

--Добавить таблицу best_offer_sale со следующими полями:
--Название: id, тип данных: INT, возможность использования неопределенного значения: Нет, первичный ключ
--Название: name, тип данных: VARCHAR(255), возможность использования неопределенного значения: Да
--Название: dt_start, тип данных: DATETIME, возможность использования неопределенного значения: Нет
--Название: dt_finish, тип данных: DATETIME, возможность использования неопределенного значения: Нет

create table best_offer_sale(
id int not null,
name varchar(255),
dt_start DATETIME not null,
dt_finish DATETIME not null,
primary key (id))





