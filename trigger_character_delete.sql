CREATE TRIGGER del_char
ON Персонажи
AFTER DELETE
AS 
   BEGIN
      DECLARE @del_usr_id CHAR(9), @del_char_id CHAR(10)
      SELECT @del_char_id = deleted.ИД_персонажа, @del_usr_id = deleted.ИД_пользователя
      FROM deleted
      
	  IF EXISTS(SELECT п.ИД_пользователя FROM Персонажи п WHERE п.ИД_пользователя = @del_usr_id)
	     BEGIN
		    DECLARE @num_of_chars INTEGER
		    SELECT @num_of_chars = COUNT(*) 
		    FROM Персонажи п
			WHERE п.ИД_пользователя = @del_usr_id
			print(concat('Количество оставшихся персонажей у пользователя: ',@num_of_chars))
	     END
	  ELSE 
	     BEGIN
	        DELETE FROM Пользователи
		    WHERE Пользователи.ИД_пользователя = @del_usr_id
		    print('Все персонажи этого пользователя были удалены')
	     END
   END
GO