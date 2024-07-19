CREATE procedure purch_itms
@c varchar(20)
AS 
WITH P_I 
AS 
(SELECT �.���_��������� as "��� ���������",�.����������_������ as "���������� ������",�.�������� as "�������� ��������",�.���� as "��������� ��������", 
CASE WHEN �.���_��������='temporary' then (�.����������_������/�.����)
	 WHEN (�.���_��������='permanent') and (�.��_�������� != ��.��_�������� or ��.��_�������� is NULL) then 1
END as "��������� ����������"
FROM (select �.* from ������� �) as �
inner join (select �.* from ��������� �) as � on �.����<�.����������_������
full outer join �������������_�������� as �� on �.��_��������� = ��.��_���������
where @c=�.���_���������) 
SELECT * 
FROM P_I
where "��������� ����������" is not NULL
order by "��������� ��������"
