CREATE TRIGGER price_update 
ON Каталог
AFTER UPDATE
AS 
   BEGIN
      DECLARE @upd_itm_id CHAR(5), @upd_itm_price INTEGER
      SELECT @upd_itm_id = к.ИД_предмета, @upd_itm_price = к.Цена
      FROM Каталог к
      inner join inserted ON к.ИД_предмета = inserted.ИД_предмета
      print(@upd_itm_id)
   END
GO