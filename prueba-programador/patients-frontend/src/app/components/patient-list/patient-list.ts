import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PatientService } from '../../services/patient.service';
import { Patient } from '../../models/patient.model';

@Component({
  selector: 'app-patient-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './patient-list.html',
  styleUrls: ['./patient-list.css']
})
export class PatientListComponent implements OnInit {
  patients: Patient[] = [];
  total = 0;
  page = 1;
  pageSize = 10;
  nameFilter = '';
  docFilter = '';
  loading = false;
  Math = Math;

  constructor(
    private patientService: PatientService, 
    private router: Router,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit() { 
    this.load(); 
  }

  load() {
    this.patientService.getAll(this.page, this.pageSize, this.nameFilter || '', this.docFilter || '')
      .subscribe({
        next: res => { 
          this.patients = [...res.data]; 
          this.total = res.total; 
          this.cdr.detectChanges();
        },
        error: (err) => { 
          console.error('Error:', err);
        }
      });
  }

  search() { this.page = 1; this.load(); }

  goToCreate() { this.router.navigate(['/patients/new']); }
  goToEdit(id: number) { this.router.navigate(['/patients/edit', id]); }
  goToDetail(id: number) { this.router.navigate(['/patients', id]); }

  delete(id: number) {
    if (confirm('¿Estás seguro de eliminar este paciente?')) {
      this.patientService.delete(id!).subscribe(() => this.load());
    }
  }

  prevPage() { if (this.page > 1) { this.page--; this.load(); } }
  nextPage() { if (this.page * this.pageSize < this.total) { this.page++; this.load(); } }
}