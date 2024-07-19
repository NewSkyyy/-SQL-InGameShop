CREATE PROC cng_price
@itm_id CHAR(5), @new_itm_id CHAR(5), @itm_price INTEGER
AS BEGIN
   BEGIN TRANSACTION;
   IF EXISTS(SELECT * FROM Каталог WHERE ИД_предмета = @itm_id)
      BEGIN
	     UPDATE Каталог
		 SET Цена = @itm_price, ИД_предмета = @new_itm_id
		 FROM Каталог
		 WHERE Каталог.ИД_предмета = @itm_id
	  END
   ELSE
      BEGIN
	  print('Данный предмет отсутствует в каталоге')
	  ROLLBACK
	  END
END
