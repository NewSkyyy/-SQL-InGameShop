CREATE procedure purch_itms
@c varchar(20)
AS 
WITH P_I 
AS 
(SELECT п.Имя_персонажа as "Имя персонажа",п.Количество_валюты as "Количество валюты",к.Название as "Название предмета",к.Цена as "Стоимость предмета", 
CASE WHEN к.Тип_предмета='temporary' then (п.Количество_валюты/к.Цена)
	 WHEN (к.Тип_предмета='permanent') and (к.ИД_предмета != пп.ИД_предмета or пп.ИД_предмета is NULL) then 1
END as "Доступное количество"
FROM (select к.* from Каталог к) as к
inner join (select п.* from Персонажи п) as п on к.Цена<п.Количество_валюты
full outer join Приобретенные_предметы as пп on п.ИД_персонажа = пп.ИД_персонажа
where @c=п.Имя_персонажа) 
SELECT * 
FROM P_I
where "Доступное количество" is not NULL
order by "Стоимость предмета"
