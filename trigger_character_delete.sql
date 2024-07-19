CREATE TRIGGER del_char
ON ���������
AFTER DELETE
AS 
   BEGIN
      DECLARE @del_usr_id CHAR(9), @del_char_id CHAR(10)
      SELECT @del_char_id = deleted.��_���������, @del_usr_id = deleted.��_������������
      FROM deleted
      
	  IF EXISTS(SELECT �.��_������������ FROM ��������� � WHERE �.��_������������ = @del_usr_id)
	     BEGIN
		    DECLARE @num_of_chars INTEGER
		    SELECT @num_of_chars = COUNT(*) 
		    FROM ��������� �
			WHERE �.��_������������ = @del_usr_id
			print(concat('���������� ���������� ���������� � ������������: ',@num_of_chars))
	     END
	  ELSE 
	     BEGIN
	        DELETE FROM ������������
		    WHERE ������������.��_������������ = @del_usr_id
		    print('��� ��������� ����� ������������ ���� �������')
	     END
   END
GO