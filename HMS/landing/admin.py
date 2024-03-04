from django.contrib import admin
from landing.models import *
from django.utils import timezone
# Register your models here.

class appointment_detail(admin.ModelAdmin):
    list_display=('patient','doctor', 'Date_of_Service', 'Time_of_Service', 'status')
    list_filter =('patient','doctor', 'Date_of_Service', 'Time_of_Service', 'status')
    search_fields =('patient','doctor',)

class billing_detail(admin.ModelAdmin):
    list_display=('patient','doctor', 'Date_of_Service', 'Total_Amount', 'status')
    list_filter=('patient','doctor', 'Date_of_Service', 'Total_Amount', 'status')
    search_fields =('Patient_first_name','Patient_last_name','Doctor_Name')     

class prescription_detail(admin.ModelAdmin):
    list_display=('patient', 'doctor', 'Medication_Name', 'Dosage', 'Duration')
    list_filter=('patient','doctor', 'Medication_Name', 'Dosage', 'Duration')
    search_fields =('patient','doctor', 'Medication_Name') 

class inventory_detail(admin.ModelAdmin):
    list_display=('Medicine_Name', 'Manufacturer_Name', 'Quantity', 'Unit_Price')
    list_filter=('Medicine_Name', 'Manufacturer_Name', 'Quantity', 'Unit_Price')
    search_fields=('Medicine_Name', 'Manufacturer_Name')

class DoctorAdmin(admin.ModelAdmin):
    list_display = ('Doctor_Id', 'First_Name', 'Last_Name', 'Email', 'Gender','Speciality','Position')
    list_filter = ('Gender','Speciality','Position')
    search_fields = ('First_Name', 'Last_Name', 'Email')

class PatientAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'email', 'role', 'gender')
    list_filter = ('role', 'gender')
    search_fields = ('first_name', 'last_name', 'email')

class MedicalRecordAdmin(admin.ModelAdmin):
    list_display = ('patient', 'doctor', 'appointment_date', 'discharge_date', 'diagnosis', 'treatment','symptoms')
    list_filter = ('doctor', 'appointment_date')
    search_fields = ('patient__first_name', 'patient__last_name', 'doctor__First_Name')

class Test_detail(admin.ModelAdmin):
    list_display=('Test_name', 'Turn_around_time', 'Test_charges')
    list_filter=('Test_name', 'Turn_around_time', 'Test_charges')
    search_fields=('Test_name', 'Turn_around_time', 'Test_charges')

class Report_detail(admin.ModelAdmin):
    list_display=('patient', 'doctor', 'Test_name', 'Test_Results')
    list_filter=('patient', 'doctor', 'Test_name', 'Test_Results')
    search_fields=('patient', 'doctor', 'Test_name', 'Test_Results')

admin.site.register(Doctor, DoctorAdmin)
admin.site.register(Patient, PatientAdmin)
admin.site.register(MedicalRecord, MedicalRecordAdmin)
admin.site.register(Appointment, appointment_detail)
admin.site.register(Billing, billing_detail)
admin.site.register(Prescription, prescription_detail)
admin.site.register(Inventorie, inventory_detail)
admin.site.register(Test, Test_detail)
admin.site.register(Report, Report_detail)