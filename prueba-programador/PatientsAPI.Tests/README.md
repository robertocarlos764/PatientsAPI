# PatientsAPI

API RESTful para gestión de pacientes construida con .NET 10 y SQL Server.

## Requisitos
- .NET 10 SDK
- SQL Server 2025
- Visual Studio Code

## Configuración de la Base de Datos
1. Abre SQL Server Management Studio (SSMS)
2. Conéctate a `localhost`
3. Ejecuta el script ubicado en `database/script.sql`

## Configuración de la API
1. Abre `PatientsAPI.API/appsettings.json`
2. Verifica la cadena de conexión:
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=PatientsDB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

## Instalación y Ejecución
```bash
cd PatientsAPI.API
dotnet run
```
La API estará disponible en ` http://localhost:5271`

## Endpoints
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | /api/patients | Listar pacientes con paginación y filtros |
| POST | /api/patients | Crear paciente |
| GET | /api/patients/{id} | Obtener paciente por ID |
| PUT | /api/patients/{id} | Actualizar paciente |
| DELETE | /api/patients/{id} | Eliminar paciente |

## Arquitectura
- **Models:** Entidades de la base de datos
- **DTOs:** Objetos de transferencia de datos
- **Data:** Contexto de Entity Framework Core
- **Controllers:** Lógica de los endpoints

## Pruebas
```bash
cd PatientsAPI.Tests
dotnet test
```

## Decisiones Técnicas
- **Entity Framework Core:** Para el mapeo objeto-relacional y operaciones CRUD
- **DTOs:** Para separar la capa de presentación del modelo de datos
- **InMemory Database:** Para pruebas unitarias sin dependencia de SQL Server
- **Swagger:** Para documentación y pruebas de la API