CREATE PROC buy_itm @cell_id VARCHAR(8), 
                    @char_id CHAR(10),
					@itm_id CHAR(5)
AS 
  BEGIN
      IF (SELECT �.���_�������� 
	      FROM ������� � 
		  WHERE �.��_�������� = @itm_id) = 'permanent'
	  BEGIN
	      BEGIN TRANSACTION;

		  IF NOT EXISTS((SELECT ��.��_���������
		                 FROM �������������_�������� �� 
						 WHERE (��.��_�������� = @itm_id 
						        AND ��.��_��������� = @char_id)))
			AND (SELECT �.����������_������ 
			     FROM ��������� � 
				 WHERE �.��_��������� = @char_id) >= 
				     (SELECT �.����
					  FROM ������� � 
					  WHERE �.��_�������� = @itm_id) 
			BEGIN
			   UPDATE ���������
				  SET ���������.����������_������ = �.����������_������ - (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id)
				  FROM ��������� � WHERE �.��_��������� = @char_id
			   INSERT INTO �������������_�������� 
			   (��_������, ��_������������, ��_���������, ��_��������, ����, ����������)
			   VALUES (@cell_id, 
					   (SELECT �.��_������������ FROM ��������� � WHERE �.��_��������� = @char_id), 
					   @char_id, 
					   @itm_id, 
					   (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id), 
					   1
					  )
			   INSERT INTO �������_�������� 
			   (��_������������, ��_���������, ��_��������, ����, �����_��������, ����, ���_��������)
			   VALUES ((SELECT �.��_������������ FROM ��������� � WHERE �.��_��������� = @char_id), 
						@char_id, 
						@itm_id, 
						(SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id), 
						(SELECT MAX(��.�����_��������) FROM �������_�������� as ��)+1,
						GETDATE(),
						'BUY'
					  )
			   print('������� ��� ������� ����������')
			   COMMIT
			END
		 ELSE
			BEGIN
			PRINT('������������ ������ ��� ������������ �������� ��� ���� ������� ���� "����������" ��� ������������ � ���������')
			ROLLBACK
			END
	  END
   ELSE 
	  BEGIN
		 BEGIN TRANSACTION;
		 IF (SELECT �.����������_������ FROM ��������� � WHERE �.��_��������� = @char_id) >= (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id) 
			BEGIN
			   UPDATE ���������
				  SET ���������.����������_������ = �.����������_������ - (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id)
				  FROM ��������� � WHERE �.��_��������� = @char_id
			   IF EXISTS(SELECT ��.��_�������� FROM �������������_�������� �� WHERE (��.��_�������� = @itm_id and ��.��_��������� = @char_id))
				  BEGIN
					 UPDATE �������������_��������
					 SET �������������_��������.���������� = ��.���������� + 1
					 FROM �������������_�������� �� WHERE (��.��_�������� = @itm_id and ��.��_��������� = @char_id)
				  END
			   ELSE
				  BEGIN
					 INSERT INTO �������������_�������� 
					 (��_������, ��_������������, ��_���������, ��_��������, ����, ����������)
					 VALUES (@cell_id, 
							 (SELECT �.��_������������ FROM ��������� � WHERE �.��_��������� = @char_id), 
							 @char_id, 
							 @itm_id, 
							 (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id), 
							 1
							)
				  END
			   INSERT INTO �������_�������� 
			   (��_������������, ��_���������, ��_��������, ����, �����_��������, ����, ���_��������)
			   VALUES ((SELECT �.��_������������ FROM ��������� � WHERE �.��_��������� = @char_id), 
						@char_id, 
						@itm_id, 
						(SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id), 
						(SELECT MAX(��.�����_��������) FROM �������_�������� as ��)+1,
						GETDATE(),
						'BUY'
					  )
			   print('������� ��� ������� ����������')
			   COMMIT
			END
		 ELSE
			BEGIN
			PRINT('������������ ������ ��� ������������ ��������')
			ROLLBACK
			END
	  END
   END