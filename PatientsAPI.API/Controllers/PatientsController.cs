using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PatientsAPI.API.Data;
using PatientsAPI.API.DTOs;
using PatientsAPI.API.Models;

namespace PatientsAPI.API.Controllers
{
    [ApiController]
    [Route("api/patients")]
    public class PatientsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PatientsController(AppDbContext context)
        {
            _context = context;
        }

        // GET /api/patients
        [HttpGet]
        public async Task<IActionResult> GetAll(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 10,
            [FromQuery] string? name = null,
            [FromQuery] string? documentNumber = null)
        {
            var query = _context.Patients.AsQueryable();

            if (!string.IsNullOrEmpty(name))
                query = query.Where(p => p.FirstName.Contains(name) || p.LastName.Contains(name));

            if (!string.IsNullOrEmpty(documentNumber))
                query = query.Where(p => p.DocumentNumber == documentNumber);

            var total = await query.CountAsync();
            var patients = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return Ok(new { total, page, pageSize, data = patients });
        }

        // GET /api/patients/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var patient = await _context.Patients.FindAsync(id);
            if (patient == null) return NotFound();
            return Ok(patient);
        }

        // POST /api/patients
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] PatientDto dto)
        {
            // Validar duplicado
            var exists = await _context.Patients.AnyAsync(p =>
                p.DocumentType == dto.DocumentType &&
                p.DocumentNumber == dto.DocumentNumber);

            if (exists) return BadRequest(new { message = "Ya existe un paciente con ese tipo y número de documento." });

            var patient = new Patient
            {
                DocumentType = dto.DocumentType,
                DocumentNumber = dto.DocumentNumber,
                FirstName = dto.FirstName,
                LastName = dto.LastName,
                BirthDate = dto.BirthDate,
                PhoneNumber = dto.PhoneNumber,
                Email = dto.Email
            };

            _context.Patients.Add(patient);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = patient.PatientId }, patient);
        }

        // PUT /api/patients/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] PatientDto dto)
        {
            var patient = await _context.Patients.FindAsync(id);
            if (patient == null) return NotFound();

            // Validar duplicado excluyendo el actual
            var exists = await _context.Patients.AnyAsync(p =>
                p.DocumentType == dto.DocumentType &&
                p.DocumentNumber == dto.DocumentNumber &&
                p.PatientId != id);

            if (exists) return BadRequest(new { message = "Ya existe otro paciente con ese tipo y número de documento." });

            patient.DocumentType = dto.DocumentType;
            patient.DocumentNumber = dto.DocumentNumber;
            patient.FirstName = dto.FirstName;
            patient.LastName = dto.LastName;
            patient.BirthDate = dto.BirthDate;
            patient.PhoneNumber = dto.PhoneNumber;
            patient.Email = dto.Email;

            await _context.SaveChangesAsync();
            return Ok(patient);
        }

        // DELETE /api/patients/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var patient = await _context.Patients.FindAsync(id);
            if (patient == null) return NotFound();

            _context.Patients.Remove(patient);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}