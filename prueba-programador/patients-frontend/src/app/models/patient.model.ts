export interface Patient {
  patientId?: number;
  documentType: string;
  documentNumber: string;
  firstName: string;
  lastName: string;
  birthDate: string;
  phoneNumber?: string;
  email?: string;
  createdAt?: string;
}

export interface PaginatedResult {
  total: number;
  page: number;
  pageSize: number;
  data: Patient[];
}