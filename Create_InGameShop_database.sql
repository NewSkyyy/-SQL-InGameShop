CREATE DATABASE InGameShop
go
USE InGameShop
CREATE TABLE [������������]
( 
	[�����_������������] integer IDENTITY(1,1) NOT NULL,
	[�����������_�����]  varchar(35)  NOT NULL ,
	[��_������������] as 'USR' + RIGHT('000000' + CAST([�����_������������] as VARCHAR(6)),6) PERSISTED ,
	[���_������������]   varchar(20)  NOT NULL ,
	CONSTRAINT [AK_���_������������] UNIQUE([���_������������]) ,
	CONSTRAINT [AK_�����������_�����] UNIQUE([�����������_�����]) ,
	CONSTRAINT [XPK������������] PRIMARY KEY ([��_������������],[�����_������������])
)
go

CREATE TABLE [���������]
( 
	[�����_���������] integer IDENTITY(1,1) NOT NULL,
	[�����_������������] integer NOT NULL,
	[��_������������]    varchar(9)  NOT NULL ,
	[��_���������]  as 'CHAR' + RIGHT('0000000' + CAST([�����_���������] as VARCHAR(7)),7)  PERSISTED ,
	[����������_������]  integer  NOT NULL , CHECK([����������_������]>=0),
	[���_���������]      varchar(20)  NOT NULL ,
	CONSTRAINT [AK_���_���������] UNIQUE([���_���������]) ,
	CONSTRAINT [XPK���������] PRIMARY KEY ([��_������������],[��_���������],[�����_���������]) ,
	CONSTRAINT [������������_���������] FOREIGN KEY ([��_������������],[�����_������������]) REFERENCES [������������]([��_������������],[�����_������������])
)
go

CREATE TABLE [�������]
( 
	[�����_��������] integer IDENTITY(1,1) NOT NULL,
	[��_��������]  as 'IT' + RIGHT('000' + CAST([�����_��������] as VARCHAR(3)),3)  PERSISTED ,
	[��������]           varchar(20)  NOT NULL ,
	[����]               integer  NOT NULL , CHECK([����]>=0),
	[��������]           varchar(80)  NULL ,
	[���_��������]                varchar(10)  NOT NULL , CHECK([���_��������]='permanent' or [���_��������]='temporary'),
	CONSTRAINT [XPK�������] PRIMARY KEY ([��_��������],[����],[�����_��������])
)
go

CREATE TABLE [�������_��������]
( 
	[��_������������]    varchar(9)  NOT NULL ,
	[��_���������]       varchar(11)  NOT NULL ,
	[��_��������]        varchar(5)  NOT NULL ,
	[����]               integer  NOT NULL , CHECK([����]>=0) ,
	[�����_��������]     integer  IDENTITY(1,1) NOT NULL ,
	[�����_������������] integer NOT NULL,
	[�����_���������] integer NOT NULL,
	[�����_��������] integer NOT NULL,
	[����]               datetime  NOT NULL , 
	[���_��������]       varchar(6)  NOT NULL , CHECK([���_��������]='BUY' or [���_��������]='SELL'),
	CONSTRAINT [XPK�������_��������] PRIMARY KEY ([�����_��������]) ,
	CONSTRAINT [���������__�������_��������] FOREIGN KEY ([��_������������],[��_���������],[�����_���������]) REFERENCES [���������]([��_������������],[��_���������],[�����_���������]) ,
	CONSTRAINT [�������__�������_��������] FOREIGN KEY ([��_��������],[����],[�����_��������]) REFERENCES [�������]([��_��������],[����],[�����_��������])
)
go

CREATE TABLE [�������������_��������]
( 
	[�����_������] integer IDENTITY(1,1) NOT NULL ,
	[�����_��������] integer NOT NULL,
	[�����_���������] integer NOT NULL,
	[��_������] as 'C' + RIGHT('0000' + CAST([�����_������] as VARCHAR(4)),4)  PERSISTED ,
	[��_������������]    varchar(9)  NOT NULL ,
	[��_���������]       varchar(11)  NOT NULL ,
	[��_��������]        varchar(5)  NOT NULL ,
	[����]               integer  NOT NULL , CHECK([����]>=0),
	[����������]         integer  NOT NULL , CHECK([����������]>=0),
	CONSTRAINT [XPK�������������_��������] PRIMARY KEY ([��_������],[��_������������],[��_���������],[�����_������]) ,
	CONSTRAINT [�������__�������������_��������] FOREIGN KEY ([��_��������],[����],[�����_��������]) REFERENCES [�������]([��_��������],[����],[�����_��������]) ,
	CONSTRAINT [���������__�������������_��������] FOREIGN KEY ([��_������������],[��_���������],[�����_���������]) REFERENCES [���������]([��_������������],[��_���������],[�����_���������])
)
go