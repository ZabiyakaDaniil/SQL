--Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
Select model, speed, hd 
from PC
where price<500

--Найдите производителей принтеров. Вывести: maker
Select distinct maker 
from Product
where type='Printer'

--Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
Select model, ram, screen 
from laptop
where price>1000

--Найдите все записи таблицы Printer для цветных принтеров.
Select * 
from Printer
where color='y'

--Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
Select model, speed, hd 
from PC
where (cd='12x'OR cd='24x') AND price<600

--Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
Select Distinct Product.maker, Laptop.speed
from Product Join
Laptop ON Product.model=Laptop.model
Where Laptop.hd>=10

--Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
Select pc.model, pc.price 
from PC Join Product on PC.model=Product.model
where Product.maker='B'
Union
Select Laptop.model, Laptop.price 
from Laptop Join Product on Laptop.model=Product.model
where Product.maker='B'
Union
Select Printer.model, Printer.price 
from Printer Join Product on Printer.model=Product.model
where Product.maker='B'
Order By price Desc