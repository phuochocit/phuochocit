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
