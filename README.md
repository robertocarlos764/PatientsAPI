# Prueba Técnica - Programador Back-End y Front-End

Este repositorio contiene las pruebas técnicas solicitadas.

---

## 📁 Estructura del Proyecto

PatientsAPI/
├── prueba-programador/
│   ├── PatientsAPI.API/        → Backend .NET
│   ├── PatientsAPI.Tests/      → Pruebas unitarias
│   └── patients-frontend/      → Frontend Angular
├── database/
│   └── ClinicaDB.sql           → Prueba Base de Datos
└── README.md

---

## 1️⃣ Prueba Backend — .NET Core + SQL Server

### Tecnologías
- .NET 10
- SQL Server 2025
- Entity Framework Core
- xUnit (pruebas unitarias)
- Swagger

### Instalación
cd prueba-programador/PatientsAPI.API
dotnet restore
dotnet run

### Base de datos
1. Abrir SSMS
2. Conectarse a localhost
3. Ejecutar el script database/PatientsDB.sql
4. Verificar cadena de conexión en appsettings.json:

"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=PatientsDB;Trusted_Connection=True;TrustServerCertificate=True;"
}

### Endpoints
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | /api/patients | Listar con paginación y filtros |
| POST | /api/patients | Crear paciente |
| GET | /api/patients/{id} | Obtener por ID |
| PUT | /api/patients/{id} | Actualizar paciente |
| DELETE | /api/patients/{id} | Eliminar paciente |

### Swagger
http://localhost:5271/swagger

### Pruebas unitarias
cd prueba-programador/PatientsAPI.Tests
dotnet test

---

## 2️⃣ Prueba Frontend — Angular

### Tecnologías
- Angular 21
- TypeScript
- PrimeNG

### Instalación
cd prueba-programador/patients-frontend
npm install
ng serve --proxy-config proxy.conf.json --port 4200

### Uso
http://localhost:4200/patients

### Funcionalidades
- ✅ Listado paginado y filtrable
- ✅ Crear paciente
- ✅ Editar paciente
- ✅ Ver detalle
- ✅ Eliminar paciente

---

## 3️⃣ Prueba Base de Datos — SQL Server

### Ubicación
database/ClinicaDB.sql

### Instalación
1. Abrir SSMS
2. Conectarse a localhost
3. Ejecutar el script ClinicaDB.sql

### Contenido
- ✅ 3 tablas: Pacientes, Medicos, Consultas
- ✅ Datos de prueba
- ✅ 5 consultas SQL
- ✅ 2 procedimientos almacenados
- ✅ 1 función escalar
- ✅ 5 índices de optimización

---

## 👨‍💻 Autor
Roberto Carlos
Repositorio: https://github.com/robertocarlos764/PatientsAPI