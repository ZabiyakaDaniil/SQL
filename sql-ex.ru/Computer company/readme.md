# Schema of Database:

### Product(maker, model, type)

### PC(code, model, speed, ram, hd, cd, price)

### Laptop(code, model, speed, ram, hd, price, screen)

### Printer(code, model, color, type, price)
 
 
 
### Task 1

Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd

### Query

Select model, speed, hd from PC

where price<500

