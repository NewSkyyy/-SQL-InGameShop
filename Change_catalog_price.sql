CREATE PROC cng_price
@itm_id CHAR(5), @new_itm_id CHAR(5), @itm_price INTEGER
AS BEGIN
   BEGIN TRANSACTION;
   IF EXISTS(SELECT * FROM ������� WHERE ��_�������� = @itm_id)
      BEGIN
	     UPDATE �������
		 SET ���� = @itm_price, ��_�������� = @new_itm_id
		 FROM �������
		 WHERE �������.��_�������� = @itm_id
	  END
   ELSE
      BEGIN
	  print('������ ������� ����������� � ��������')
	  ROLLBACK
	  END
END
