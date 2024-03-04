# landing/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('team', views.team, name="team"),
    path('services', views.services, name="services"),
    path('contact', views.contact, name="contact"),
    path('signup', views.signup, name="signup"),
    path('signin', views.signin, name="signin"),
    path('signout', views.signout, name='signout'),
    path('user_dashboard', views.user_dashboard, name="user_dashboard"),
    path('forgetPassword', views.forgetPassword, name="forgetPassword"),
    path('incorrectDetails', views.incorrectDetails, name='incorrectDetails'),
    path('regComplete', views.regComplete, name="regComplete"),
    path('doctor_register', views.doctorRegisteration, name="doctor_register"),
    path('doctor_login', views.doctor_login, name="doctor_login"),
    path('doctor_logout', views.doctor_logout, name="doctor_logout"),
    path('incorrectDetails', views.incorrectDetails, name='incorrectDetails'),
    path('DoctorincorrectDetails', views.DoctorincorrectDetails, name='DoctorincorrectDetails'),
    path('Doctor_dashboard', views.Doctor_dashboard, name="Doctor_dashboard"),
    path('registrationFailed', views.registrationFailed, name='registrationFailed'),
    path('registrationComplete', views.registrationComplete, name='registrationComplete'),
    path('patient_list', views.patient_list, name='patient_list'),
    path('record_list', views.record_list, name='record_list'),
    path('report_list', views.report_list, name='report_list'),
    path('test_list', views.test_list, name='test_list'),
    path('prescription_list', views.prescription_list, name='prescription_list'),
    path('appointment_list', views.appointment_list, name='appointment_list'),
    path('inventory_list', views.inventory_list, name='inventory_list'),
    path('billing_list', views.billing_list, name='billing_list'),
    path('Patient_record_list', views.Patient_record_list, name='Patient_record_list'),
    path('Patient_Doctor_list', views.Patient_Doctor_list, name='Patient_Doctor_list'),
    path('Patient_report_list', views.Patient_report_list, name='Patient_report_list'),
    path('Patient_prescription_list', views.Patient_prescription_list, name='Patient_prescription_list'),
    path('Patient_appointment_list', views.Patient_appointment_list, name='Patient_appointment_list'),
    path('Patient_billing_list', views.Patient_billing_list, name='Patient_billing_list')
    
    # Other app-specific URLs can be added here if needed
]
