CREATE DATABASE QLBONGDA
ON (NAME = 'QLBONGDA_MDF', FILENAME = 'D:\CSDL\QLBONGDA.MDF')
LOG ON (NAME = 'QLBONGDA_LDF', FILENAME = 'D:\CSDL\QLBONGDA.LDF')
GO
USE QLBONGDA
GO

CREATE TABLE San
(
	MaSan CHAR(3) PRIMARY KEY,
	TenSan NVARCHAR(50),
	DiaChi NVARCHAR(100)
)

CREATE TABLE Doi
(
	MaDoi CHAR(3) PRIMARY KEY,
	TenDoi NVARCHAR(20),
	MaSan CHAR(3),
	FOREIGN KEY (MaSan) REFERENCES San(MaSan)
)
CREATE TABLE TranDau
(
	MaTD INT PRIMARY KEY,
	MaSan CHAR(3),
	Ngay DATE,
	Gio TIME,
	FOREIGN KEY (MaSan) REFERENCES San(MaSan)
)

CREATE TABLE CT_TranDau
(
	MaTD INT,
	MaDoi CHAR(3),
	SoBanThang INT CHECK (SoBanThang >= 0),
	PRIMARY KEY (MaTD, MaDoi),
	FOREIGN KEY (MaTD) REFERENCES TranDau(MaTD),
	FOREIGN KEY (MaDoi) REFERENCES Doi(MaDoi)
)

--1-	In số trận đấu mà mỗi đội đã thi đấu. Hiển thị:  MaDoi, TenDoi.
SELECT  A.MaDoi, TenDoi, COUNT (MaTD) AS 'Số trận'
FROM Doi A JOIN CT_TranDau B ON (A.MaDoi = B.MaDoi)
GROUP BY A.MaDoi, TenDoi

--2-	In kết quả trận đấu theo tỷ số:
--MaTran  | Đội trận đấu | Tỷ số
--  01    | VN-TL        | 3-1
SELECT A.MaTD  MaTran, A.MaDoi + '- ' + B.MaDoi [Đội trận đấu], STR(A.SoBanThang, 2) + '-' + STR(B.SoBanThang) [Tỷ số]
FROM CT_TranDau A JOIN CT_TranDau B ON (A.MaTD = B.MaTD)
WHERE A.MaDoi > B.MaDoi

--3-	In kết quả mỗi trận theo điểm:
--MaTran  | Doi  | Diem
--01	  | VN   |  3
--01      | TL   |  0
SELECT A.MaTD, A.MaDoi, Diem = CASE
				WHEN A.SoBanThang > B.SoBanThang THEN 3
				WHEN A.SoBanThang = B.SoBanThang THEN 1
				ELSE 0
					END
FROM CT_TranDau A, CT_TranDau B
WHERE A.MaTD = B.MaTD AND A.MaDoi <> B.MaDoi

-- 4-	In mã đội, tên đội, tổng số điểm:
--      VN     |  Việt Nam  | 6   
SELECT A.MaDoi, TenDoi, SUM (Diem) [Tổng số điểm]
FROM Doi A, (SELECT A.MaTD, A.MaDoi, Diem = CASE
				WHEN A.SoBanThang > B.SoBanThang THEN 3
				WHEN A.SoBanThang = B.SoBanThang THEN 1
				ELSE 0
					END
				FROM CT_TranDau A, CT_TranDau B
				WHERE A.MaTD = B.MaTD AND A.MaDoi <> B.MaDoi) B
WHERE A.MaDoi = B.MaDoi
GROUP BY A.MaDoi, TenDoi

--5-	Sắp xếp danh sách các đội để biết thứ hạng:
--    | MaDoi  | Ten Doi     | Tổng số điểm | Hiệu số bàn thắng
--        VN   |  Viet Nam   |      6       |        7

-- Tìm tổng số bàn thắng của từng đội
SELECT MaDoi, SoBanThang = SUM(SoBanThang)
FROM CT_TranDau
GROUP BY MaDoi

-- Tim tống số bàn thua của từng đội 
SELECT A.MaDoi, SoBanThua = SUM(B.SoBanThang)
FROM CT_TranDau A, CT_TranDau B
WHERE A.MaTD = B.MaTD AND A.MaDoi <> B.MaDoi
GROUP BY A.MaDoi

SELECT a.MaDoi, TenDoi, [Tổng số điểm], [Hiệu số bàn thắng] = SoBanThang - SoBanThua
FROM (SELECT A.MaDoi, TenDoi, SUM(Diem) [Tổng số điểm]
	FROM Doi A, (SELECT A.MaTD, A.MaDoi, Diem = CASE
				WHEN A.SoBanThang > B.SoBanThang THEN 3
				WHEN A.SoBanThang = B.SoBanThang THEN 1
				ELSE 0
					END
				FROM CT_TranDau A, CT_TranDau B
				WHERE A.MaTD = B.MaTD AND A.MaDoi <> B.MaDoi) B
	WHERE A.MaDoi = B.MaDoi
	GROUP BY A.MaDoi, TenDoi) A,
			(SELECT MaDoi, SoBanThang = SUM(SoBanThang)
			FROM CT_TranDau
			GROUP BY MaDoi) B,
			(SELECT A.MaDoi, SoBanThua = SUM(B.SoBanThang)
			FROM CT_TranDau A, CT_TranDau B
			WHERE A.MaTD = B.MaTD AND A.MaDoi <> B.MaDoi
			GROUP BY A.MaDoi) C
WHERE A.MaDoi = B.MaDoi AND A.MaDoi = C.MaDoi
ORDER BY [Tổng số điểm] DESC, [Hiệu số bàn thắng] DESC

-- 6-	Hiển thị các trận chưa đá:
--    Các trận chưa đá:
--       LA - CPC 
--       VN - CPC
-- Các trận phải đá
SELECT A.MaDoi, B.MaDoi
FROM Doi A, Doi B
WHERE A.MaDoi > b.MaDoi
EXCEPT
-- Các trận đã đá
SELECT A.MaDoi [Doi A] , B.MaDoi [Doi B]
FROM CT_TranDau A, CT_TranDau B 
WHERE A.MaDoi > B.MaDoi AND A.MaTD = B.MaTD
