CREATE PROC sell_itm
@char_id CHAR(10), @itm_id CHAR(5)
AS BEGIN
   IF (SELECT к.Тип_предмета FROM Каталог к WHERE к.ИД_предмета = @itm_id) = 'permanent'
      BEGIN
	   BEGIN TRANSACTION;
         IF EXISTS((SELECT пп.ИД_персонажа FROM Приобретенные_предметы пп WHERE (пп.ИД_предмета = @itm_id and пп.ИД_персонажа = @char_id)))
            BEGIN
               UPDATE Персонажи
		          SET Персонажи.Количество_валюты = п.Количество_валюты + (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id)
			      FROM Персонажи п WHERE п.ИД_персонажа = @char_id
		       DELETE FROM Приобретенные_предметы
		       WHERE (Приобретенные_предметы.ИД_предмета = @itm_id and Приобретенные_предметы.ИД_персонажа = @char_id)
		       INSERT INTO История_операций 
		       (ИД_пользователя, ИД_персонажа, ИД_предмета, Цена, Номер_операции, Дата, Тип_операции)
		       VALUES ((SELECT п.ИД_Пользователя FROM Персонажи п WHERE п.ИД_персонажа = @char_id), 
		                @char_id, 
			   	        @itm_id, 
			   	        (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id), 
				        (SELECT MAX(ио.Номер_Операции) FROM История_операций as ио)+1,
				        GETDATE(),
				        'SELL'
				      )
		       COMMIT
            END
	     ELSE
	        BEGIN
	        PRINT('У этого персонажа отсутствует данный предмет')
            ROLLBACK
	        END
      END
   ELSE 
      BEGIN
	     BEGIN TRANSACTION;
         IF EXISTS((SELECT пп.ИД_персонажа FROM Приобретенные_предметы пп WHERE (пп.ИД_предмета = @itm_id and пп.ИД_персонажа = @char_id)))
            BEGIN
               UPDATE Персонажи
		          SET Персонажи.Количество_валюты = п.Количество_валюты + (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id)
			      FROM Персонажи п WHERE п.ИД_персонажа = @char_id
			   IF (SELECT пп.Количество FROM Приобретенные_предметы пп WHERE (пп.ИД_предмета = @itm_id and пп.ИД_персонажа = @char_id)) > 1
			      BEGIN
				     UPDATE Приобретенные_предметы
		             SET Приобретенные_предметы.Количество = пп.Количество - 1
			         FROM Приобретенные_предметы пп WHERE (пп.ИД_предмета = @itm_id and пп.ИД_персонажа = @char_id)
			      END
			   ELSE
			      BEGIN
		              DELETE FROM Приобретенные_предметы
		              WHERE (Приобретенные_предметы.ИД_предмета = @itm_id and Приобретенные_предметы.ИД_персонажа = @char_id)
			      END
		       INSERT INTO История_операций 
		       (ИД_пользователя, ИД_персонажа, ИД_предмета, Цена, Номер_операции, Дата, Тип_операции)
		       VALUES ((SELECT п.ИД_Пользователя FROM Персонажи п WHERE п.ИД_персонажа = @char_id), 
		                @char_id, 
			   	        @itm_id, 
			   	        (SELECT к.Цена FROM Каталог к WHERE к.ИД_предмета = @itm_id), 
				        (SELECT MAX(ио.Номер_Операции) FROM История_операций as ио)+1,
				        GETDATE(),
				        'SELL'
				      )
		       COMMIT
            END
	     ELSE
	        BEGIN
	        PRINT('У этого персонажа отсутствует данный предмет')
            ROLLBACK
	        END
      END
   END