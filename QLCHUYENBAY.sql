CREATE DATABASE QLCHUYENBAY
ON (NAME = 'QLCHUYENBAY_MDF', FILENAME = 'D:\CSDL\QLCHUYENBAY.MDF')
LOG ON (NAME = 'QLCHUYENBAY_LDF', FILENAME = 'D:\CSDL\QLCHUYENBAY.LDF')
GO
USE QLCHUYENBAY
GO

CREATE TABLE MAYBAY
(
	MaMB INT PRIMARY KEY,
	Loai VARCHAR(50),
	TamBay INT,
)

CREATE TABLE CHUYENBAY
(
	MaCB CHAR(5) PRIMARY KEY,
	GaDi VARCHAR(50),
	GaDen VARCHAR(50),
	DoDai INT,
	GioDi TIME,
	GioDen TIME,
	ChiPhi INT,
	MaMB INT,
	FOREIGN KEY (MaMB) REFERENCES MAYBAY(MaMB)
)

CREATE TABLE NHANVIEN
(
	MaNV CHAR(9) PRIMARY KEY,
	Ten NVARCHAR(50),
	Luong INT
)

CREATE TABLE CHUNGNHAN
(
	MaNV CHAR(9),
	MaMB INT,
	PRIMARY KEY(MaNV, MaMB),
	FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
	FOREIGN KEY (MaMB) REFERENCES MAYBAY(MaMB)
)

--1)	Cho biết các chuyến bay đi Đà Lạt (DAD).
SELECT * 
FROM CHUYENBAY
WHERE GaDen = 'DAD'

--2)	Cho biết các loại máy bay có tầm bay lớn hơn 10,000km.
SELECT Loai, TamBay
FROM MAYBAY
WHERE TamBay > 10000

--3)	Tìm các nhân viên có lương nhỏ hơn 10,000.
SELECT *
FROM NHANVIEN
WHERE Luong < 100000

--5)	Cho biết các chuyến bay xuất phát từ Sài Gòn (SGN) đi Ban Mê Thuộc (BMV).
SELECT *
FROM CHUYENBAY
WHERE GaDi = 'SGN' AND GaDen = 'BMV'

--6)	Có bao nhiêu chuyến bay xuất phát từ Sài Gòn (SGN).
SELECT COUNT(GaDi) AS [Các chuyến bay xuất phát từ Sài Gòn]
FROM CHUYENBAY
WHERE GaDi = 'SGN'

SELECT *
FROM CHUYENBAY
WHERE GaDi = 'SGN'

--7)	Có bao nhiêu loại máy báy Boeing.
SELECT COUNT(Loai) AS [Máy bay Boeing] 
FROM MAYBAY
WHERE Loai LIKE 'Boeing%'

SELECT *
FROM MAYBAY
WHERE Loai LIKE 'Boeing%'

--8)	Cho biết tổng số lương phải trả cho các nhân viên.
SELECT SUM(Luong) AS [Tổng số lương phải trả]
FROM NHANVIEN

--9)	Cho biết mã số của các phi công lái máy báy Boeing.

--10)	Cho biết các nhân viên có thể lái máy bay có mã số 747.
