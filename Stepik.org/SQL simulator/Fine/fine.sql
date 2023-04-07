--Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation.
--При этом суммы заносить только в пустые поля столбца  sum_fine.

update fine f, traffic_violation tv
set f.sum_fine=tv.sum_fine
where f.sum_fine is null
and f.violation=tv.violation;

--Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило два и более раз.
 --При этом учитывать все нарушения, независимо от того оплачены они или нет.
 --Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
 
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(violation)>=2
order by name, name, number_plate, violation;

--В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 
--1:

update fine f, (
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(violation)>=2) qi
set f.sum_fine = f.sum_fine*2
where f.date_payment is null
and f.name=qi.name
and f.number_plate=qi.number_plate
and f.violation=qi.violation;

--2:
create table qi as
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(violation)>=2;

update fine f, qi
set f.sum_fine = f.sum_fine*2
where f.date_payment is null
and f.name=qi.name
and f.number_plate=qi.number_plate
and f.violation=qi.violation;

--В таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
--уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment), 
--если оплата произведена не позднее 20 дней со дня нарушения.

update fine f, payment p
set f.date_payment = p.date_payment,
f.sum_fine = if(datediff(f.date_payment, f.date_violation)<=20, f.sum_fine/2, f.sum_fine)
where f.date_payment is null
and f.name=p.name
and f.number_plate=p.number_plate
and f.violation=p.violation;

--Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа
--и  дату нарушения) из таблицы fine.

create table back_payment as
select name, number_plate, violation, sum_fine, date_violation
from fine
where date_payment is null;

--Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 

delete from fine
where date_violation<'2020-02-01'
