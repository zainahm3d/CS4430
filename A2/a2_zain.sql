-- Assignment 2, Zain Ahmed

-- for all of database 1

use computer;
-- 1
select model, speed, hdisk
      FROM pc
      WHERE price < 1000;

-- +-------+-------+-------+
-- | model | speed | hdisk |
-- +-------+-------+-------+
-- | 1002  |  2.10 |   250 |
-- | 1003  |  1.42 |    80 |
-- | 1004  |  2.80 |   250 |
-- | 1005  |  3.20 |   250 |
-- | 1007  |  2.20 |   200 |
-- | 1008  |  2.20 |   250 |
-- | 1009  |  2.00 |   250 |
-- | 1010  |  2.80 |   300 |
-- | 1011  |  1.86 |   160 |
-- | 1012  |  2.80 |   160 |
-- | 1013  |  3.06 |    80 |
-- +-------+-------+-------+

-- 2
select distinct maker
      from product
      where type = 'printer';

-- +-------+
-- | maker |
-- +-------+
-- | D     |
-- | E     |
-- | H     |
-- +-------+

-- 3
select model, ram, hdisk, screen
      from laptop
      where price > 1500;

-- +-------+------+-------+--------+
-- | model | ram  | hdisk | screen |
-- +-------+------+-------+--------+
-- | 2001  | 2048 |   240 |  20.10 |
-- | 2005  | 1024 |   120 |  17.00 |
-- | 2006  | 2048 |    80 |  15.40 |
-- | 2010  | 2048 |   160 |  15.40 |
-- +-------+------+-------+--------+

-- 4
select model, price, type
      from printer
      where color = 1;

-- +-------+--------+---------+
-- | model | price  | type    |
-- +-------+--------+---------+
-- | 3001  |  99.00 | ink-jet |
-- | 3003  | 899.00 | laser   |
-- | 3004  | 120.00 | ink-jet |
-- | 3006  | 100.00 | ink-jet |
-- | 3007  | 200.00 | laser   |
-- +-------+--------+---------+

-- 5
select model, hdisk
      from pc
      where (speed = 3.2) and (price < 2000);

-- +-------+-------+
-- | model | hdisk |
-- +-------+-------+
-- | 1005  |   250 |
-- | 1006  |   320 |
-- +-------+-------+

-- 6
select maker, hdisk
      from product, laptop
      where hdisk > 30 and product.model = laptop.model;

-- +-------+-------+
-- | maker | hdisk |
-- +-------+-------+
-- | A     |    60 |
-- | A     |   120 |
-- | A     |    80 |
-- | B     |   120 |
-- | E     |   240 |
-- | E     |    80 |
-- | E     |    60 |
-- | F     |   100 |
-- | F     |    80 |
-- | G     |   160 |
-- +-------+-------+

-- 7
(select product.model, price
      from product, pc
      where product.model = pc.model
      and maker = 'B')

union

(select product.model, price
      from product, laptop
      where product.model = laptop.model
      and maker = 'B')

union

(select product.model, price
      from product, printer
      where product.model = printer.model
      and maker = 'B');

-- +-------+---------+
-- | model | price   |
-- +-------+---------+
-- | 1004  |  649.00 |
-- | 1005  |  630.00 |
-- | 1006  | 1049.00 |
-- | 2007  | 1429.00 |
-- +-------+---------+

-- 8
select distinct maker
      from product
      where type = 'laptop'
      and maker not in ( select maker from product where type = 'pc');

-- +-------+
-- | maker |
-- +-------+
-- | F     |
-- | G     |
-- +-------+

-- 9
select distinct hdisk
      from pc testPC
      where
            (select count(*) from pc p2
            where testPC.hdisk = p2.hdisk) > 1;

-- +-------+
-- | hdisk |
-- +-------+
-- |   250 |
-- |    80 |
-- |   160 |
-- +-------+

-- 10
select pc.model, pc1.model
      from   pc, pc as pc1
      where  pc.model < pc1.model
      and pc.speed = pc1.speed
      and pc.ram = pc1.ram;

-- +-------+-------+
-- | model | model |
-- +-------+-------+
-- | 1004  | 1012  |
-- +-------+-------+

-- 12
select distinct maker
      from product, pc
      where pc.speed >= 3.0;

-- +-------+
-- | maker |
-- +-------+
-- | A     |
-- | B     |
-- | C     |
-- | D     |
-- | E     |
-- | F     |
-- | G     |
-- | H     |
-- +-------+

-- 13
select model from printer
      where price >= all(select price from printer);

-- +-------+
-- | model |
-- +-------+
-- | 3003  |
-- +-------+

-- 14
select model from laptop
      where speed <= all(select speed from pc);

-- empty set

-- 15
with t as
      (
    select model,price from pc
    union select model, price from laptop
    union select model, price from printer
    )
select model
      from t
      where price=(select max(price) from t);

-- +-------+
-- | model |
-- +-------+
-- | 2001  |
-- +-------+

-- 16
select maker from printer, product
      where color = 1
      and printer.model = product.model
      and price = (select min(price) from printer);

-- +-------+
-- | maker |
-- +-------+
-- | E     |
-- +-------+

-- 17
select distinct maker from product, pc
      where product.model = pc.model
      and ram <= all (select ram from pc)
      and speed >= all (select speed from pc where ram=(select min(ram) from pc));

-- +-------+
-- | maker |
-- +-------+
-- | B     |
-- +-------+

-- 18
select avg(speed)
      from pc;

-- +------------+
-- | avg(speed) |
-- +------------+
-- |   2.484615 |
-- +------------+

-- 19
select avg(price)
      from laptop
      where laptop.price > 1000;

-- +-------------+
-- | avg(price)  |
-- +-------------+
-- | 2125.333333 |
-- +-------------+

-- 20
select avg(pc.price)
      from pc, product
      where product.model = pc.model
      and product.maker = 'A';

-- +---------------+
-- | avg(pc.price) |
-- +---------------+
-- |   1195.666667 |
-- +---------------+


-- 22
select speed, avg(price) as prc
      from pc
      group by speed;

-- +-------+-------------+
-- | speed | prc         |
-- +-------+-------------+
-- |  2.66 | 2114.000000 |
-- |  2.10 |  995.000000 |
-- |  1.42 |  478.000000 |
-- |  2.80 |  689.333333 |
-- |  3.20 |  839.500000 |
-- |  2.20 |  640.000000 |
-- |  2.00 |  650.000000 |
-- |  1.86 |  959.000000 |
-- |  3.06 |  529.000000 |
-- +-------+-------------+

-- 23
select product.maker, avg(laptop.screen)
      from laptop, product
      where laptop.model = product.model
      group by product.maker;

-- +-------+--------------------+
-- | maker | avg(laptop.screen) |
-- +-------+--------------------+
-- | A     |          15.233333 |
-- | B     |          13.300000 |
-- | E     |          17.500000 |
-- | F     |          14.750000 |
-- | G     |          15.400000 |
-- +-------+--------------------+


-- 24
select maker
      from product
      where type = 'pc'
      group by maker
      having count(model) >= 3;

-- +-------+
-- | maker |
-- +-------+
-- | A     |
-- | B     |
-- | D     |
-- | E     |
-- +-------+

-- 25
select maker, max(price)
      from product, pc
      where product.model = pc.model
      group by maker;

-- +-------+------------+
-- | maker | max(price) |
-- +-------+------------+
-- | A     |    2114.00 |
-- | B     |    1049.00 |
-- | C     |     510.00 |
-- | D     |     770.00 |
-- | E     |     959.00 |
-- +-------+------------+

-- 26
select speed, avg(price)
      from product, pc
      where pc.speed > 2.0
      group by speed;

-- +-------+-------------+
-- | speed | avg(price)  |
-- +-------+-------------+
-- |  3.06 |  529.000000 |
-- |  2.80 |  689.333333 |
-- |  2.20 |  640.000000 |
-- |  3.20 |  839.500000 |
-- |  2.10 |  995.000000 |
-- |  2.66 | 2114.000000 |
-- +-------+-------------+

-- 27
select maker, avg(hdisk) from pc, product
      where product.model = pc.model
      group by maker
      having maker in
            (
                  select maker from product
                  where type = 'printer'
            );

-- +-------+------------+
-- | maker | avg(hdisk) |
-- +-------+------------+
-- | D     |   266.6667 |
-- | E     |   133.3333 |
-- +-------+------------+

use battleship;

-- 28
select class, country
      from classes
      where guns >= 10;

-- +-----------+---------+
-- | class     | country |
-- +-----------+---------+
-- | Tennessee | USA     |
-- +-----------+---------+

-- 29
select name as shipName
      from ships
      where launched < 1918;

-- +-----------------+
-- | shipName        |
-- +-----------------+
-- | Haruna          |
-- | Hiei            |
-- | Kirishima       |
-- | Kongo           |
-- | Ramillies       |
-- | Renown          |
-- | Repulse         |
-- | Resolution      |
-- | Revenge         |
-- | Royal Oak       |
-- | Royal Sovereign |
-- +-----------------+

-- 30
select ship, battle
      from outcomes
      where result = 'sunk';

-- +-------------+----------------+
-- | ship        | battle         |
-- +-------------+----------------+
-- | Arizona     | Pearl Harbor   |
-- | Bismarck    | Denmark Strait |
-- | Fuso        | Surigao Strait |
-- | Hood        | Denmark Strait |
-- | Kirishima   | Guadalcanal    |
-- | Scharnhorst | North Cape     |
-- | Yamashiro   | Surigao Strait |
-- +-------------+----------------+

-- 31
select name
      from ships
      where name = class;

-- +----------------+
-- | name           |
-- +----------------+
-- | Iowa           |
-- | Kongo          |
-- | North Carolina |
-- | Renown         |
-- | Revenge        |
-- | Tennessee      |
-- | Yamato         |
-- +----------------+

-- 32
select name
      from ships
      where name like 'R%';

-- +-----------------+
-- | name            |
-- +-----------------+
-- | Ramillies       |
-- | Renown          |
-- | Repulse         |
-- | Resolution      |
-- | Revenge         |
-- | Royal Oak       |
-- | Royal Sovereign |
-- +-----------------+

-- 34
select name
      from ships, classes
      where ships.class = classes.class
      and classes.displacement > 35000;

-- +----------------+
-- | name           |
-- +----------------+
-- | Iowa           |
-- | Missouri       |
-- | New Jersey     |
-- | Wisconsin      |
-- | North Carolina |
-- | Washington     |
-- | Musashi        |
-- | Yamato         |
-- +----------------+

-- 35
select name, displacement, guns
      from classes, ships, outcomes
      where classes.class = ships.class
            and ships.name = outcomes.ship
            and battle = 'Guadalcanal';

-- +------------+--------------+------+
-- | name       | displacement | guns |
-- +------------+--------------+------+
-- | Kirishima  |        32000 |    8 |
-- | Washington |        37000 |    9 |
-- +------------+--------------+------+

-- 36
select country
      from classes
      group by country
      having count(distinct classes.type) = 2;

-- +-------------+
-- | country     |
-- +-------------+
-- | Gt. Britain |
-- | Japan       |
-- +-------------+

-- 38
select battle
      from outcomes, ships, classes
      where outcomes.ship = ships.name
            and ships.class = classes.class
      group by classes.country, outcomes.battle
      having count(outcomes.ship) > 3;

-- empty

-- 39
select country
      from classes
      where guns in
      (
            select max(guns)
            from classes
      );

-- +---------+
-- | country |
-- +---------+
-- | USA     |
-- +---------+

-- 40
select distinct classes.class
      from classes, ships
      where ships.class = classes.class
      and ships.name in
      (
            select ship
            from outcomes
            where outcomes.result = 'sunk'
      ) ;

-- +-------+
-- | class |
-- +-------+
-- | Kongo |
-- +-------+

-- 41
select name, bore
      from ships, classes
      where ships.class = classes.class
      and classes.bore = 16;

-- +----------------+------+
-- | name           | bore |
-- +----------------+------+
-- | Iowa           |   16 |
-- | Missouri       |   16 |
-- | New Jersey     |   16 |
-- | Wisconsin      |   16 |
-- | North Carolina |   16 |
-- | Washington     |   16 |
-- +----------------+------+

-- 42
select distinct battle from outcomes
      where ship = any (select name from ships where class = 'Kongo');

-- +-------------+
-- | battle      |
-- +-------------+
-- | Guadalcanal |
-- +-------------+

-- 47
select c.class, min(s.launched) as launchedData from classes c, ships s
      where c.class = s.class
      group by c.class;

-- +-------------+
-- | battle      |
-- +-------------+
-- | Guadalcanal |
-- +-------------+

-- 48
select count(ship)
      from outcomes, ships
      where outcomes.ship = ships.name and outcomes.result = 'Sunk';

-- +-------------+
-- | count(ship) |
-- +-------------+
-- |           1 |
-- +-------------+