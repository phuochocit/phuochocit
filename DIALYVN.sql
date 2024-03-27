CREATE TABLE TINH_TP
(
	MA_T_TP varchar(3) primary key,
	TEN_T_TP nvarchar(20),
	DT float,
	DS bigint,
	MIEN nvarchar(10)
)

CREATE TABLE BIENGIOI
(
	NUOC nvarchar(15),
	MA_T_TP varchar(3),
	constraint R1 primary key (NUOC, MA_T_TP),
	constraint R2 foreign key (MA_T_TP) references TINH_TP(MA_T_TP)
)

CREATE TABLE LANGGIENG
(
	MA_T_TP varchar(3),
	LG varchar(3),
	constraint R3 primary key (LG, MA_T_TP),
	constraint R4 foreign key (MA_T_TP) references TINH_TP(MA_T_TP)
)
