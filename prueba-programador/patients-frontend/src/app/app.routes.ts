import { Routes } from '@angular/router';
import { PatientListComponent } from './components/patient-list/patient-list';
import { PatientFormComponent } from './components/patient-form/patient-form';
import { PatientDetailComponent } from './components/patient-detail/patient-detail';

export const routes: Routes = [
  { path: '', redirectTo: 'patients', pathMatch: 'full' },
  { path: 'patients', component: PatientListComponent },
  { path: 'patients/new', component: PatientFormComponent },
  { path: 'patients/edit/:id', component: PatientFormComponent },
  { path: 'patients/:id', component: PatientDetailComponent }
];