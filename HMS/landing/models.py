from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone



class Inventorie(models.Model):
    Medicine_Name=models.CharField(max_length=20)
    Manufacturer_Name=models.CharField(max_length=20)
    Quantity=models.IntegerField()
    Unit_Price=models.FloatField()

class Patient(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField()
    role = models.CharField(max_length=20)
    address = models.TextField()
    phone = models.CharField(max_length=15)
    gender = models.CharField(max_length=10)
    date_of_birth = models.DateField()
    password = models.CharField(max_length=100)  # Store hashed passwords, not plain text
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='patient', null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

class Doctor(models.Model):
    Doctor_Id = models.CharField(max_length=50)
    Candidate_Picture = models.ImageField(verbose_name="Doctor Picture", upload_to='doctor_images/', blank=True, null=True)
    First_Name=models.TextField(max_length=20)
    Last_Name=models.TextField(max_length=20)
    Email = models.TextField(max_length=30)
    Gender=models.TextField(max_length=6)
    Speciality=models.TextField(max_length=20)
    Position=models.TextField(max_length=20)
    Password=models.TextField()
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='doctor', null=True)
    def __str__(self):
        return f"{self.First_Name} {self.Last_Name}"


class MedicalRecord(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    appointment_date = models.DateField()
    discharge_date = models.DateField(blank=True, null=True)
    diagnosis = models.TextField()
    treatment = models.TextField()
    symptoms = models.TextField()
    Duser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='medical_records_as_doctor')
    Puser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='medical_records_as_patient')
    def __str__(self):
        return "{} - {}".format(self.patient,self.doctor)

class Billing(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    Date_of_Service=models.DateField()
    Total_Amount=models.FloatField()
    class Status(models.TextChoices):
        COMPLETED = 'paid', 'Paid'
        SCHEDULED = 'unpaid', 'Unpaid'
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
    )
    Puser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='billing_as_patient')

class Appointment(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    Date_of_Service=models.DateField()
    Time_of_Service=models.TimeField()
    class Status(models.TextChoices):
        COMPLETED = 'completed', 'Completed'
        SCHEDULED = 'scheduled', 'Scheduled'
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
    )
    Duser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='appointments_as_doctor')
    Puser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='appointments_as_patient')
    def __str__(self):
        return "{} - {}".format(self.patient,self.doctor)
    
class Prescription(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    Medication_Name=models.CharField(max_length=20)
    Dosage=models.CharField(max_length=20)
    Duration=models.CharField(max_length=20)
    Duser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='prescriptions_as_doctor')
    Puser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='prescriptions_as_patient')
    def __str__(self):
        return "{} - {}".format(self.patient,self.doctor)
    
class Test(models.Model):
    Test_name=models.CharField(max_length=20)
    Turn_around_time=models.TextField(max_length=20)
    Test_charges=models.FloatField()

class Report(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    Test_name=models.CharField(max_length=20)
    Test_Results=models.CharField(max_length=200)
    Duser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports_as_doctor')
    Puser = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports_as_patient')
    def __str__(self):
        return "{} - {}".format(self.patient,self.doctor)
    

