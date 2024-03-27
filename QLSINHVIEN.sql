CREATE DATABASE QLSINHVIEN
ON (NAME = 'QLSINHVIEN_MDF', FILENAME = 'D:\CSDL\QLSINHVIEN.MDF')
LOG ON (NAME = 'QLSINHVIEN_LDF', FILENAME = 'D:\CSDL\QLSINHVIEN.LDF')
GO
USE QLSINHVIEN
GO

CREATE TABLE LOP (
    MaLop CHAR(7) PRIMARY KEY,
    TenLop NVARCHAR(50),
    SiSo TINYINT CHECK (SiSo > 0)
)

CREATE TABLE MONHOC (
    MaMH CHAR(6) PRIMARY KEY,
    TenMH NVARCHAR(50),
    TCLT TINYINT CHECK (TCLT > 0),
    TCTH TINYINT CHECK (TCTH >= 0)
)

CREATE TABLE SINHVIEN (
    MSSV CHAR(6) PRIMARY KEY,
    HoTen NVARCHAR(50),
    NTNS DATE,
    Phai BIT DEFAULT 1,
    MaLop CHAR(7),
    FOREIGN KEY (MaLop) REFERENCES LOP(MaLop)
)

CREATE TABLE DIEMSV (
    MSSV CHAR(6),
    MaMH CHAR(6),
    Diem DECIMAL(3,1) CHECK (Diem IS NULL OR (Diem >= 0 AND Diem <= 10)),
    PRIMARY KEY (MSSV, MaMH),
    FOREIGN KEY (MSSV) REFERENCES SINHVIEN(MSSV),
    FOREIGN KEY (MaMH) REFERENCES MONHOC(MaMH)
)

--1-	Thêm một dòng mới vào bảng SINHVIEN với giá trị:
-- 190001	Đào Thị Tuyết Hoa	08/03/2001	0	19DTH02

INSERT INTO SINHVIEN VALUES 
(
	'190001',
	N'Đào Thị Tuyết Hoa',
	'2001-03-08',
	'0',
	'19DTH02'
)

--2-	Hãy đổi tên môn học ‘Lý thuyết đồ thị ’thành ‘Toán rời rạc’.
UPDATE MONHOC
SET TenMH = N'Toán rời rạc'
WHERE TenMH = N'Lý thuyết đồ thị'

--3-	Hiển thị tên các môn học không có thực hành.
SELECT TenMH, TCTH
FROM MONHOC
WHERE TCTH = 0

--4-	Hiển thị tên các môn học vừa có lý thuyết, vừa có thực hành.
SELECT TenMH, TCLT, TCTH
FROM MONHOC

--5-	In ra tên các môn học có ký tự đầu của tên là chữ ‘C’.
SELECT TenMH
FROM MONHOC
WHERE TenMH LIKE 'C%'

--6-	Liệt kê thông tin những sinh viên mà họ chứa chữ ‘Thị’.
SELECT HoTen
FROM SINHVIEN
WHERE HoTen LIKE N'%Thị%'

--7-	In ra 2 lớp có sĩ số đông nhất (bằng nhiều cách). Hiển thị: Mã lớp, Tên lớp, Sĩ số. Nhận xét?
--Cách 1: Sử dụng phương pháp TOP và ORDER BY:
SELECT TOP 2 MaLop, TenLop, SiSo
FROM LOP
ORDER BY SiSo DESC

--Cách 2: Sử dụng phương pháp ROW_NUMBER():
SELECT MaLop, TenLop, SiSo
FROM (
    SELECT MaLop, TenLop, SiSo, ROW_NUMBER() OVER (ORDER BY SiSo DESC) AS RowNum
    FROM LOP
) AS LopRanked
WHERE RowNum <= 2

--Cách 3: Sử dụng phương pháp SUBQUERY:
SELECT MaLop, TenLop, SiSo
FROM LOP
WHERE SiSo IN (SELECT TOP 2 SiSo FROM LOP ORDER BY SiSo DESC)

-- Nhận xét:
--Việc sử dụng phương pháp TOP và ORDER BY là cách đơn giản và hiệu quả để lấy ra các bản ghi có giá trị lớn nhất.
--Phương pháp ROW_NUMBER() cho phép bạn xếp hạng các bản ghi theo sĩ số và sau đó chọn ra 2 lớp đứng đầu.
--Sử dụng SUBQUERY cũng là một cách tiếp cận phổ biến để lấy ra các bản ghi với giá trị cao nhất.

--8-	In danh sách SV theo từng lớp: MSSV, Họ tên SV, Năm sinh, Phái (Nam/Nữ).
SELECT SINHVIEN.MSSV, SINHVIEN.HoTen, YEAR(SINHVIEN.NTNS) AS NamSinh, 
       CASE 
            WHEN SINHVIEN.Phai = 1 THEN N'Nam'
            ELSE N'Nữ'
       END AS Phai,
       LOP.MaLop, LOP.TenLop
FROM SINHVIEN
INNER JOIN LOP ON SINHVIEN.MaLop = LOP.MaLop
ORDER BY LOP.MaLop, SINHVIEN.MSSV

--9-	Cho biết những sinh viên có tuổi ≥ 20, thông tin gồm: Họ tên sinh viên, Ngày sinh, Tuổi.
SELECT HoTen AS [Họ tên sinh viên], NTNS AS [Ngày sinh], 
       DATEDIFF(YEAR, NTNS, GETDATE()) AS [Tuổi]
FROM SINHVIEN
WHERE DATEDIFF(YEAR, NTNS, GETDATE()) >= 20

--10-	Liệt kê tên các môn học SV đã dự thi nhưng chưa có điểm.
SELECT DISTINCT MONHOC.TenMH
FROM MONHOC
LEFT JOIN DIEMSV ON MONHOC.MaMH = DIEMSV.MaMH
WHERE DIEMSV.Diem IS NULL

--11-	Liệt kê kết quả học tập của SV có mã số 170001. Hiển thị: MSSV, HoTen, TenMH, Diem.
SELECT A.MSSV, HoTen, TenMH, Diem 
FROM SINHVIEN A JOIN DIEMSV B ON (A.MSSV = B.MSSV) JOIN MONHOC C ON (B.MaMH = C.MaMH)
WHERE A.MSSV = '170001'

--12-	Liệt kê tên sinh viên và mã môn học mà sv đó đăng ký với điểm trên 7 điểm.
SELECT HoTen, B.MaMH, Diem
FROM SINHVIEN A JOIN DIEMSV B ON (A.MSSV = B.MSSV) JOIN MONHOC C ON (B.MaMH = C.MaMH)
WHERE B.Diem > 7

--13-	Liệt tên môn học cùng số lượng SV đã học và đã có điểm.
SELECT DISTINCT TenMH, Diem
FROM MONHOC, DIEMSV


--14-	Liệt kê tên SV và điểm trung bình của SV đó.
SELECT HoTen, AVG (Diem) DiemTrungBinh
FROM SINHVIEN, DIEMSV
GROUP BY HoTen

-- 15-	Liệt kê tên sinh viên đạt điểm cao nhất của môn học ‘Kỹ thuật lập trình’.