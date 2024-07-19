CREATE PROC buy_itm @cell_id VARCHAR(8), 
                    @char_id CHAR(10),
					@itm_id CHAR(5)
AS 
  BEGIN
      IF (SELECT к.Тип_предмета 
	      FROM Каталог к 
		  WHERE к.ИД_предмета = @itm_id) = 'permanent'
	  BEGIN
	      BEGIN TRANSACTION;

		  IF NOT EXISTS((SELECT пп.ИД_персонажа
		                 FROM Приобретенные_предметы пп 
						 WHERE (пп.ИД_предмета = @itm_id 
						        AND пп.ИД_персонажа = @char_id)))
			AND (SELECT п.Количество_валюты 
			     FROM Персонажи п 
				 WHERE п.ИД_персонажа = @char_id) >= 
				     (SELECT к.Цена
					  FROM Каталог к 
					  WHERE к.ИД_предмета = @itm_id) 
			BEGIN
			   UPDATE Персонажи
				  SET Персонажи.Количество_валюты = п.Количество_валюты - (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id)
				  FROM Персонажи п WHERE п.ИД_персонажа = @char_id
			   INSERT INTO Приобретенные_предметы 
			   (ИД_ячейки, ИД_пользователя, ИД_персонажа, ИД_предмета, Цена, Количество)
			   VALUES (@cell_id, 
					   (SELECT п.ИД_Пользователя FROM Персонажи п WHERE п.ИД_персонажа = @char_id), 
					   @char_id, 
					   @itm_id, 
					   (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id), 
					   1
					  )
			   INSERT INTO История_операций 
			   (ИД_пользователя, ИД_персонажа, ИД_предмета, Цена, Номер_операции, Дата, Тип_операции)
			   VALUES ((SELECT п.ИД_Пользователя FROM Персонажи п WHERE п.ИД_персонажа = @char_id), 
						@char_id, 
						@itm_id, 
						(SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id), 
						(SELECT MAX(ио.Номер_Операции) FROM История_операций as ио)+1,
						GETDATE(),
						'BUY'
					  )
			   print('Предмет был успешно приобретен')
			   COMMIT
			END
		 ELSE
			BEGIN
			PRINT('Недостаточно валюты для приобретения предмета или этот предмет типа "постоянный" уже присутствует у персонажа')
			ROLLBACK
			END
	  END
   ELSE 
	  BEGIN
		 BEGIN TRANSACTION;
		 IF (SELECT п.Количество_валюты FROM Персонажи п WHERE п.ИД_персонажа = @char_id) >= (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id) 
			BEGIN
			   UPDATE Персонажи
				  SET Персонажи.Количество_валюты = п.Количество_валюты - (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id)
				  FROM Персонажи п WHERE п.ИД_персонажа = @char_id
			   IF EXISTS(SELECT пп.ИД_предмета FROM Приобретенные_предметы пп WHERE (пп.ИД_предмета = @itm_id and пп.ИД_персонажа = @char_id))
				  BEGIN
					 UPDATE Приобретенные_предметы
					 SET Приобретенные_предметы.Количество = пп.Количество + 1
					 FROM Приобретенные_предметы пп WHERE (пп.ИД_предмета = @itm_id and пп.ИД_персонажа = @char_id)
				  END
			   ELSE
				  BEGIN
					 INSERT INTO Приобретенные_предметы 
					 (ИД_ячейки, ИД_пользователя, ИД_персонажа, ИД_предмета, Цена, Количество)
					 VALUES (@cell_id, 
							 (SELECT п.ИД_Пользователя FROM Персонажи п WHERE п.ИД_персонажа = @char_id), 
							 @char_id, 
							 @itm_id, 
							 (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id), 
							 1
							)
				  END
			   INSERT INTO История_операций 
			   (ИД_пользователя, ИД_персонажа, ИД_предмета, Цена, Номер_операции, Дата, Тип_операции)
			   VALUES ((SELECT п.ИД_Пользователя FROM Персонажи п WHERE п.ИД_персонажа = @char_id), 
						@char_id, 
						@itm_id, 
						(SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id), 
						(SELECT MAX(ио.Номер_Операции) FROM История_операций as ио)+1,
						GETDATE(),
						'BUY'
					  )
			   print('Предмет был успешно приобретен')
			   COMMIT
			END
		 ELSE
			BEGIN
			PRINT('Недостаточно валюты для приобретения предмета')
			ROLLBACK
			END
	  END
   END