CREATE TRIGGER price_update 
ON �������
AFTER UPDATE
AS 
   BEGIN
      DECLARE @upd_itm_id CHAR(5), @upd_itm_price INTEGER
      SELECT @upd_itm_id = �.��_��������, @upd_itm_price = �.����
      FROM ������� �
      inner join inserted ON �.��_�������� = inserted.��_��������
      print(@upd_itm_id)
   END
GO