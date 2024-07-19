CREATE DATABASE InGameShop
go
USE InGameShop
CREATE TABLE [Пользователи]
( 
	[номер_пользователя] integer IDENTITY(1,1) NOT NULL,
	[Электронная_почта]  varchar(35)  NOT NULL ,
	[ИД_пользователя] as 'USR' + RIGHT('000000' + CAST([номер_пользователя] as VARCHAR(6)),6) PERSISTED ,
	[Имя_пользователя]   varchar(20)  NOT NULL ,
	CONSTRAINT [AK_Имя_пользователя] UNIQUE([Имя_пользователя]) ,
	CONSTRAINT [AK_Электронная_почта] UNIQUE([Электронная_почта]) ,
	CONSTRAINT [XPKПользователи] PRIMARY KEY ([ИД_пользователя],[номер_пользователя])
)
go

CREATE TABLE [Персонажи]
( 
	[номер_персонажа] integer IDENTITY(1,1) NOT NULL,
	[номер_пользователя] integer NOT NULL,
	[ИД_пользователя]    varchar(9)  NOT NULL ,
	[ИД_персонажа]  as 'CHAR' + RIGHT('0000000' + CAST([номер_персонажа] as VARCHAR(7)),7)  PERSISTED ,
	[Количество_валюты]  integer  NOT NULL , CHECK([Количество_валюты]>=0),
	[Имя_персонажа]      varchar(20)  NOT NULL ,
	CONSTRAINT [AK_Имя_персонажа] UNIQUE([Имя_персонажа]) ,
	CONSTRAINT [XPKПерсонажи] PRIMARY KEY ([ИД_пользователя],[ИД_персонажа],[номер_персонажа]) ,
	CONSTRAINT [Пользователи_Персонажи] FOREIGN KEY ([ИД_пользователя],[номер_пользователя]) REFERENCES [Пользователи]([ИД_пользователя],[номер_пользователя])
)
go

CREATE TABLE [Каталог]
( 
	[номер_предмета] integer IDENTITY(1,1) NOT NULL,
	[ИД_предмета]  as 'IT' + RIGHT('000' + CAST([номер_предмета] as VARCHAR(3)),3)  PERSISTED ,
	[Название]           varchar(20)  NOT NULL ,
	[Цена]               integer  NOT NULL , CHECK([Цена]>=0),
	[Описание]           varchar(80)  NULL ,
	[Тип_предмета]                varchar(10)  NOT NULL , CHECK([Тип_предмета]='permanent' or [Тип_предмета]='temporary'),
	CONSTRAINT [XPKКаталог] PRIMARY KEY ([ИД_предмета],[Цена],[номер_предмета])
)
go

CREATE TABLE [История_операций]
( 
	[ИД_пользователя]    varchar(9)  NOT NULL ,
	[ИД_персонажа]       varchar(11)  NOT NULL ,
	[ИД_предмета]        varchar(5)  NOT NULL ,
	[Цена]               integer  NOT NULL , CHECK([Цена]>=0) ,
	[Номер_операции]     integer  IDENTITY(1,1) NOT NULL ,
	[номер_пользователя] integer NOT NULL,
	[номер_персонажа] integer NOT NULL,
	[номер_предмета] integer NOT NULL,
	[Дата]               datetime  NOT NULL , 
	[Тип_операции]       varchar(6)  NOT NULL , CHECK([Тип_операции]='BUY' or [Тип_операции]='SELL'),
	CONSTRAINT [XPKИстория_операций] PRIMARY KEY ([Номер_операции]) ,
	CONSTRAINT [Персонажи__История_операций] FOREIGN KEY ([ИД_пользователя],[ИД_персонажа],[номер_персонажа]) REFERENCES [Персонажи]([ИД_пользователя],[ИД_персонажа],[номер_персонажа]) ,
	CONSTRAINT [Каталог__История_операций] FOREIGN KEY ([ИД_предмета],[Цена],[номер_предмета]) REFERENCES [Каталог]([ИД_предмета],[Цена],[номер_предмета])
)
go

CREATE TABLE [Приобретенные_предметы]
( 
	[номер_ячейки] integer IDENTITY(1,1) NOT NULL ,
	[номер_предмета] integer NOT NULL,
	[номер_персонажа] integer NOT NULL,
	[ИД_ячейки] as 'C' + RIGHT('0000' + CAST([номер_ячейки] as VARCHAR(4)),4)  PERSISTED ,
	[ИД_пользователя]    varchar(9)  NOT NULL ,
	[ИД_персонажа]       varchar(11)  NOT NULL ,
	[ИД_предмета]        varchar(5)  NOT NULL ,
	[Цена]               integer  NOT NULL , CHECK([Цена]>=0),
	[Количество]         integer  NOT NULL , CHECK([Количество]>=0),
	CONSTRAINT [XPKПриобретенные_предметы] PRIMARY KEY ([ИД_ячейки],[ИД_пользователя],[ИД_персонажа],[номер_ячейки]) ,
	CONSTRAINT [Каталог__Приобретенные_предметы] FOREIGN KEY ([ИД_предмета],[Цена],[номер_предмета]) REFERENCES [Каталог]([ИД_предмета],[Цена],[номер_предмета]) ,
	CONSTRAINT [Персонажи__Приобретенные_предметы] FOREIGN KEY ([ИД_пользователя],[ИД_персонажа],[номер_персонажа]) REFERENCES [Персонажи]([ИД_пользователя],[ИД_персонажа],[номер_персонажа])
)
go