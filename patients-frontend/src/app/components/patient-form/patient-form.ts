import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PatientService } from '../../services/patient.service';
import { Patient } from '../../models/patient.model';

@Component({
  selector: 'app-patient-form',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './patient-form.html',
  styleUrls: ['./patient-form.css']
})
export class PatientFormComponent implements OnInit {
  patient: Patient = { documentType: '', documentNumber: '', firstName: '', lastName: '', birthDate: '' };
  isEdit = false;
  patientId?: number;
  loading = false;
  errorMessage = '';

  constructor(private route: ActivatedRoute, private router: Router, private patientService: PatientService) {}

  ngOnInit() {
    this.patientId = this.route.snapshot.params['id'];
    if (this.patientId) {
      this.isEdit = true;
      this.patientService.getById(this.patientId).subscribe(p => this.patient = p);
    }
  }

  save() {
    if (!this.patient.documentType || !this.patient.documentNumber || !this.patient.firstName || !this.patient.lastName || !this.patient.birthDate) {
      this.errorMessage = 'Todos los campos obligatorios deben estar completos.';
      return;
    }
    this.loading = true;
    this.errorMessage = '';
    const action = this.isEdit
      ? this.patientService.update(this.patientId!, this.patient)
      : this.patientService.create(this.patient);

    action.subscribe({
      next: () => { this.loading = false; this.router.navigate(['/patients']); },
      error: (err) => { this.loading = false; this.errorMessage = err.error?.message || 'Error al guardar.'; }
    });
  }

  cancel() { this.router.navigate(['/patients']); }
}