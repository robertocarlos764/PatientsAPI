import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { PatientService } from '../../services/patient.service';
import { Patient } from '../../models/patient.model';

@Component({
  selector: 'app-patient-detail',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './patient-detail.html',
  styleUrls: ['./patient-detail.css']
})
export class PatientDetailComponent implements OnInit {
  patient?: Patient;

  constructor(
    private route: ActivatedRoute, 
    private router: Router, 
    private patientService: PatientService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit() {
    const id = this.route.snapshot.params['id'];
    this.patientService.getById(id).subscribe({
      next: p => { 
        this.patient = p; 
        this.cdr.detectChanges();
      },
      error: err => console.error('Error:', err)
    });
  }

  goBack() { this.router.navigate(['/patients']); }
}