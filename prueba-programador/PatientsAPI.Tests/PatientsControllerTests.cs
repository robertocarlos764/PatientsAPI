using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PatientsAPI.API.Controllers;
using PatientsAPI.API.Data;
using PatientsAPI.API.DTOs;
using PatientsAPI.API.Models;

namespace PatientsAPI.Tests
{
    public class PatientsControllerTests
    {
        private AppDbContext GetInMemoryContext()
        {
            var options = new DbContextOptionsBuilder<AppDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new AppDbContext(options);
        }

        [Fact]
        public async Task CreatePatient_ReturnsCreated_WhenValid()
        {
            // Arrange
            var context = GetInMemoryContext();
            var controller = new PatientsController(context);
            var dto = new PatientDto
            {
                DocumentType = "CC",
                DocumentNumber = "111111",
                FirstName = "Ana",
                LastName = "García",
                BirthDate = new DateTime(1990, 1, 1)
            };

            // Act
            var result = await controller.Create(dto);

            // Assert
            Assert.IsType<CreatedAtActionResult>(result);
        }

        [Fact]
        public async Task CreatePatient_ReturnsBadRequest_WhenDuplicate()
        {
            // Arrange
            var context = GetInMemoryContext();
            var controller = new PatientsController(context);
            var dto = new PatientDto
            {
                DocumentType = "CC",
                DocumentNumber = "222222",
                FirstName = "Carlos",
                LastName = "López",
                BirthDate = new DateTime(1985, 3, 10)
            };

            // Act
            await controller.Create(dto);
            var result = await controller.Create(dto); // duplicado

            // Assert
            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetById_ReturnsNotFound_WhenPatientDoesNotExist()
        {
            // Arrange
            var context = GetInMemoryContext();
            var controller = new PatientsController(context);

            // Act
            var result = await controller.GetById(999);

            // Assert
            Assert.IsType<NotFoundResult>(result);
        }
    }
}