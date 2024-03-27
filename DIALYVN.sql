CREATE DATABASE DIALYVN
ON (NAME='DIALYVN_MDF', FILENAME='D:\CSDL\DIALYVN.MDF')
LOG ON (NAME='DIALYVN_LDF', FILENAME='D:\CSDL\DIALYVN.LDF')
GO
USE DIALYVN
GO

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

-- 1. Xuất ra tên tỉnh, TP cùng với dân số của tỉnh, TP:
-- a) Có diện tích >= 5000 Km2
SELECT[TEN_T_TP], [DT], [DS]
FROM [dbo].[TINH_TP]
WHERE DT > 5000

-- 2. Xuất ra tên tỉnh, TP cùng với diện tích của tỉnh, TP:
-- a) Thuộc miền Bắc
SELECT [TEN_T_TP], [DT], [DS]
FROM [dbo].[TINH_TP]
WHERE MIEN = N'Bắc'

-- 4. Cho biết diện tích trung bình của các tỉnh, TP (Tổng DT/Tổng số tỉnh_TP).
SELECT AVG (DT) DIENTICHTB
FROM [dbo].[TINH_TP]

SELECT SUM (DT) / COUNT (MA_T_TP) DIENTICHTB
FROM TINH_TP

-- 5. Cho biết dân số cùng với tên tỉnh của các tỉnh, TP có diện tích > 7000 Km2.
SELECT [TEN_T_TP], [DT], [DS]
FROM [dbo].[TINH_TP]
WHERE DT > 7000

-- 6. Cho biết dân số cùng với tên tỉnh của các tỉnh miền ‘Bắc’.
SELECT [TEN_T_TP], [DS]
FROM [dbo].[TINH_TP]
WHERE MIEN = N'Bắc'

-- 7. Cho biết mã các nước là biên giới của các tỉnh miền ‘Nam’.
SELECT DISTINCT NUOC
FROM TINH_TP a JOIN BIENGIOI b ON (a.MA_T_TP = b.MA_T_TP)
WHERE MIEN = N'Nam'

-- 8. Cho biết diện tích trung bình của các tỉnh, TP. (Sử dụng hàm)
SELECT AVG (DT) DIENTICHTB
FROM [dbo].[TINH_TP]

-- 9. Cho biết mật độ dân số (DS/DT) cùng với tên tỉnh, TP của tất cả các tỉnh, TP.

-- 10. Cho biết tên các tỉnh, TP láng giềng của tỉnh ‘Long An’.
SELECT DISTINCT c.TEN_T_TP
FROM TINH_TP a JOIN LANGGIENG b ON (a.MA_T_TP = b.MA_T_TP) JOIN TINH_TP c ON (b.LG = c.MA_T_TP)
WHERE a.TEN_T_TP  = N'Long An'

-- 11. Cho biết số lượng các tỉnh, TP giáp với ‘CPC’.
SELECT COUNT (TEN_T_TP)
FROM TINH_TP a JOIN BIENGIOI b ON (a.MA_T_TP = b.MA_T_TP)
WHERE NUOC = N'CPC'

-- 12. Cho biết tên những tỉnh, TP có diện tích lớn nhất.
SELECT TEN_T_TP, DT 
FROM TINH_TP
WHERE DT = (SELECT MAX (DT) FROM TINH_TP)

-- 13. Cho biết tỉnh, TP có mật độ DS đông nhất.
SELECT TEN_T_TP, DS
FROM TINH_TP
WHERE DS = (SELECT MAX (DS) FROM TINH_TP)

-- 14. Cho biết tên những tỉnh, TP giáp với hai nước biên giới khác nhau.
SELECT TEN_T_TP, COUNT (NUOC) SONUOCGIAP
FROM TINH_TP a JOIN BIENGIOI b ON (a.MA_T_TP = b.MA_T_TP)
GROUP BY TEN_T_TP
HAVING COUNT (NUOC) = 2

-- 15. Cho biết danh sách các miền cùng với các tỉnh, TP trong các miền đó.
SELECT MIEN, COUNT (MA_T_TP) SOTINH
FROM TINH_TP a
GROUP BY MIEN
HAVING COUNT (MA_T_TP) >= ALL (SELECT COUNT (MA_T_TP) FROM TINH_TP GROUP BY MIEN)

-- 16.Cho biết tên những tỉnh, TP có nhiều láng giềng nhất.
SELECT TOP 1 WITH TIES  TEN_T_TP, COUNT (LG) SOLANGGIENG -- WITH TIES hiển thị những tỉnh có số láng giềng nhiều nhất giống nhau
FROM TINH_TP a JOIN LANGGIENG b ON (a.MA_T_TP = b.MA_T_TP)
GROUP BY TEN_T_TP
ORDER BY SOLANGGIENG DESC

-- 17. Cho biết những tỉnh, TP có diện tích nhỏ hơn diện tích trung bình của tất cả tỉnh, TP.
SELECT TEN_T_TP, DT
FROM TINH_TP
WHERE DT < (SELECT AVG (DT) FROM TINH_TP)

-- 18. Cho biết tên những tỉnh, TP giáp với các tỉnh, TP ở miền ‘Nam’ và không phải là miền ‘Nam’.
SELECT DISTINCT c.TEN_T_TP, c.MIEN
FROM TINH_TP a JOIN LANGGIENG b ON (a.MA_T_TP = b.MA_T_TP) JOIN TINH_TP c ON (c.MA_T_TP = a.MA_T_TP)
WHERE a.MIEN = N'Nam'

-- 19. Cho biết tên những tỉnh, TP có diện tích lớn hơn tất cả các tỉnh, TP láng giềng của nó.
SELECT TEN_T_TP, DT
FROM TINH_TP a 
WHERE a.DT > (SELECT MAX (c.DT) FROM LANGGIENG b, TINH_TP c WHERE a.MA_T_TP = b.MA_T_TP AND b.LG = c.MA_T_TP)
