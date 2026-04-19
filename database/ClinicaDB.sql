-- =============================================
-- BASE DE DATOS: ClinicaDB
-- Prueba Técnica - Base de Datos
-- =============================================

USE master;
GO

-- 1. CREAR BASE DE DATOS
CREATE DATABASE ClinicaDB;
GO

USE ClinicaDB;
GO

-- 2. CREAR TABLAS
CREATE TABLE Pacientes (
    PacienteId      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre          NVARCHAR(100),
    Documento       NVARCHAR(20),
    FechaNacimiento DATE
);

CREATE TABLE Medicos (
    MedicoId      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre        NVARCHAR(100),
    Especialidad  NVARCHAR(100)
);

CREATE TABLE Consultas (
    ConsultaId     INT IDENTITY(1,1) PRIMARY KEY,
    PacienteId     INT,
    MedicoId       INT,
    FechaConsulta  DATETIME,
    Diagnostico    NVARCHAR(200),
    ValorConsulta  DECIMAL(18,2),
    FOREIGN KEY (PacienteId) REFERENCES Pacientes(PacienteId),
    FOREIGN KEY (MedicoId)   REFERENCES Medicos(MedicoId)
);
GO

-- 3. INSERTAR DATOS
INSERT INTO Medicos (Nombre, Especialidad) VALUES
('Dr. Carlos López', 'Cardiología'),
('Dra. María García', 'Pediatría'),
('Dr. Juan Martínez', 'Neurología'),
('Dra. Ana Rodríguez', 'Dermatología'),
('Dr. Pedro Sánchez', 'Ortopedia'),
('Dra. Laura Torres', 'Ginecología');

INSERT INTO Pacientes (Nombre, Documento, FechaNacimiento) VALUES
('Roberto Pérez', '123456789', '1990-05-15'),
('María González', '987654321', '1985-08-22'),
('Carlos Ruiz', '456789123', '1978-03-10'),
('Ana Martínez', '321654987', '1995-11-30'),
('Luis Hernández', '654321789', '2000-07-04'),
('Sofia Castro', '789123456', '1988-12-25'),
('Diego Vargas', '147258369', '1975-02-14'),
('Valentina Mora', '369258147', '1992-09-18');

INSERT INTO Consultas (PacienteId, MedicoId, FechaConsulta, Diagnostico, ValorConsulta) VALUES
(1, 1, GETDATE()-5,  'Hipertensión',         150000),
(1, 2, GETDATE()-10, 'Control rutina',        80000),
(1, 3, GETDATE()-15, 'Migraña',              200000),
(2, 1, GETDATE()-3,  'Arritmia',             150000),
(2, 4, GETDATE()-20, 'Dermatitis',           120000),
(3, 2, GETDATE()-8,  'Fiebre',               80000),
(3, 5, GETDATE()-25, 'Fractura',             300000),
(4, 1, GETDATE()-2,  'Chequeo cardiaco',     150000),
(4, 3, GETDATE()-12, 'Epilepsia',            200000),
(4, 6, GETDATE()-18, 'Control ginecológico', 130000),
(5, 2, GETDATE()-1,  'Vacunación',            80000),
(5, 4, GETDATE()-7,  'Acné',                 120000),
(6, 5, GETDATE()-30, 'Artritis',             300000),
(7, 1, GETDATE()-45, 'Angina',               150000),
(8, 3, GETDATE()-60, 'Cefalea',              200000);
GO

-- 4. CONSULTAS SQL
-- 4.1 Top 5 pacientes con mayor número de consultas
SELECT TOP 5 
    p.Nombre AS Paciente,
    COUNT(c.ConsultaId) AS TotalConsultas
FROM Pacientes p
INNER JOIN Consultas c ON p.PacienteId = c.PacienteId
GROUP BY p.Nombre
ORDER BY TotalConsultas DESC;

-- 4.2 Médicos que NO han atendido pacientes
SELECT m.Nombre, m.Especialidad
FROM Medicos m
LEFT JOIN Consultas c ON m.MedicoId = c.MedicoId
WHERE c.ConsultaId IS NULL;

-- 4.3 Valor total facturado por cada médico
SELECT 
    m.Nombre AS Medico,
    m.Especialidad,
    SUM(c.ValorConsulta) AS TotalFacturado
FROM Medicos m
INNER JOIN Consultas c ON m.MedicoId = c.MedicoId
GROUP BY m.Nombre, m.Especialidad
ORDER BY TotalFacturado DESC;

-- 4.4 Pacientes atendidos en más de una especialidad
SELECT 
    p.Nombre AS Paciente,
    COUNT(DISTINCT m.Especialidad) AS TotalEspecialidades
FROM Pacientes p
INNER JOIN Consultas c ON p.PacienteId = c.PacienteId
INNER JOIN Medicos m ON c.MedicoId = m.MedicoId
GROUP BY p.Nombre
HAVING COUNT(DISTINCT m.Especialidad) > 1
ORDER BY TotalEspecialidades DESC;

-- 4.5 Pacientes atendidos en el último mes
SELECT DISTINCT
    p.Nombre AS Paciente,
    p.Documento,
    MAX(c.FechaConsulta) AS UltimaConsulta
FROM Pacientes p
INNER JOIN Consultas c ON p.PacienteId = c.PacienteId
WHERE c.FechaConsulta >= DATEADD(MONTH, -1, GETDATE())
GROUP BY p.Nombre, p.Documento
ORDER BY UltimaConsulta DESC;
GO

-- 5. PROCEDIMIENTOS ALMACENADOS
CREATE PROCEDURE sp_ConsultasPorPaciente
    @Documento NVARCHAR(20)
AS
BEGIN
    SELECT 
        p.Nombre AS Paciente,
        m.Nombre AS Medico,
        m.Especialidad,
        c.FechaConsulta,
        c.Diagnostico,
        c.ValorConsulta
    FROM Consultas c
    INNER JOIN Pacientes p ON c.PacienteId = p.PacienteId
    INNER JOIN Medicos m ON c.MedicoId = m.MedicoId
    WHERE p.Documento = @Documento
    ORDER BY c.FechaConsulta DESC;
END;
GO

CREATE PROCEDURE sp_ResumenPorEspecialidad
    @Especialidad NVARCHAR(100)
AS
BEGIN
    SELECT 
        m.Nombre AS Medico,
        COUNT(c.ConsultaId) AS TotalConsultas,
        SUM(c.ValorConsulta) AS TotalFacturado,
        AVG(c.ValorConsulta) AS PromedioConsulta
    FROM Medicos m
    LEFT JOIN Consultas c ON m.MedicoId = c.MedicoId
    WHERE m.Especialidad = @Especialidad
    GROUP BY m.Nombre;
END;
GO

-- 6. FUNCIÓN
CREATE FUNCTION fn_CalcularEdad
(
    @FechaNacimiento DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Edad INT
    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, GETDATE())
    IF (MONTH(@FechaNacimiento) > MONTH(GETDATE()) OR 
        (MONTH(@FechaNacimiento) = MONTH(GETDATE()) AND 
         DAY(@FechaNacimiento) > DAY(GETDATE())))
    BEGIN
        SET @Edad = @Edad - 1
    END
    RETURN @Edad
END;
GO

-- 7. ÍNDICES
CREATE INDEX IX_Consultas_PacienteId ON Consultas(PacienteId);
CREATE INDEX IX_Consultas_MedicoId ON Consultas(MedicoId);
CREATE INDEX IX_Consultas_FechaConsulta ON Consultas(FechaConsulta);
CREATE INDEX IX_Pacientes_Documento ON Pacientes(Documento);
CREATE INDEX IX_Medicos_Especialidad ON Medicos(Especialidad);
GO