CREATE PROC sell_itm
@char_id CHAR(10), @itm_id CHAR(5)
AS BEGIN
   IF (SELECT �.���_�������� FROM ������� � WHERE �.��_�������� = @itm_id) = 'permanent'
      BEGIN
	   BEGIN TRANSACTION;
         IF EXISTS((SELECT ��.��_��������� FROM �������������_�������� �� WHERE (��.��_�������� = @itm_id and ��.��_��������� = @char_id)))
            BEGIN
               UPDATE ���������
		          SET ���������.����������_������ = �.����������_������ + (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id)
			      FROM ��������� � WHERE �.��_��������� = @char_id
		       DELETE FROM �������������_��������
		       WHERE (�������������_��������.��_�������� = @itm_id and �������������_��������.��_��������� = @char_id)
		       INSERT INTO �������_�������� 
		       (��_������������, ��_���������, ��_��������, ����, �����_��������, ����, ���_��������)
		       VALUES ((SELECT �.��_������������ FROM ��������� � WHERE �.��_��������� = @char_id), 
		                @char_id, 
			   	        @itm_id, 
			   	        (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id), 
				        (SELECT MAX(��.�����_��������) FROM �������_�������� as ��)+1,
				        GETDATE(),
				        'SELL'
				      )
		       COMMIT
            END
	     ELSE
	        BEGIN
	        PRINT('� ����� ��������� ����������� ������ �������')
            ROLLBACK
	        END
      END
   ELSE 
      BEGIN
	     BEGIN TRANSACTION;
         IF EXISTS((SELECT ��.��_��������� FROM �������������_�������� �� WHERE (��.��_�������� = @itm_id and ��.��_��������� = @char_id)))
            BEGIN
               UPDATE ���������
		          SET ���������.����������_������ = �.����������_������ + (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id)
			      FROM ��������� � WHERE �.��_��������� = @char_id
			   IF (SELECT ��.���������� FROM �������������_�������� �� WHERE (��.��_�������� = @itm_id and ��.��_��������� = @char_id)) > 1
			      BEGIN
				     UPDATE �������������_��������
		             SET �������������_��������.���������� = ��.���������� - 1
			         FROM �������������_�������� �� WHERE (��.��_�������� = @itm_id and ��.��_��������� = @char_id)
			      END
			   ELSE
			      BEGIN
		              DELETE FROM �������������_��������
		              WHERE (�������������_��������.��_�������� = @itm_id and �������������_��������.��_��������� = @char_id)
			      END
		       INSERT INTO �������_�������� 
		       (��_������������, ��_���������, ��_��������, ����, �����_��������, ����, ���_��������)
		       VALUES ((SELECT �.��_������������ FROM ��������� � WHERE �.��_��������� = @char_id), 
		                @char_id, 
			   	        @itm_id, 
			   	        (SELECT �.���� FROM ������� � WHERE �.��_�������� = @itm_id), 
				        (SELECT MAX(��.�����_��������) FROM �������_�������� as ��)+1,
				        GETDATE(),
				        'SELL'
				      )
		       COMMIT
            END
	     ELSE
	        BEGIN
	        PRINT('� ����� ��������� ����������� ������ �������')
            ROLLBACK
	        END
      END
   END