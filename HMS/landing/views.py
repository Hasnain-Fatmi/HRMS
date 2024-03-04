from django.shortcuts import render,redirect
from django.contrib.auth.models import User
from django.db import connection
from django.contrib.auth import login,logout,authenticate
import mysql.connector as sql
from django.http import HttpRequest
from .models import *
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, get_object_or_404
from landing.models import Doctor, MedicalRecord
from django.contrib import messages

# Create your views here.
def home(request):
    return render(request,"HomePage/landingPage.html")

def signup(request):
    if request.method == "POST":
        # Extracting user input from the form
        first_name = request.POST.get("firstName", "")
        last_name = request.POST.get("lastName", "")
        gender = request.POST.get("gender", "")
        email = request.POST.get("email", "")
        phone = request.POST.get("phone", "")
        address = request.POST.get("address", "")
        role = request.POST.get("role", "")
        date_of_birth = request.POST.get("date_of_birth", "")
        password = request.POST.get("password", "")

        # Call the stored procedure for signup
        with connection.cursor() as cursor:
            cursor.callproc("SignUpUser", [first_name, last_name, gender, email, phone, address, role, date_of_birth, password])

            # Fetch the result from the stored procedure
            result = cursor.fetchone()
            message = result[0] if result else None

            if message and 'Email already exists' in message:
                # Handle case when email already exists
                return render(request, 'registrationFailed.html')
            elif message and 'User created successfully' in message:
                # Create User and Patient instances upon successful signup
                myUser = User.objects.create_user(email, email, password)  # Create the user
                myUser.first_name = first_name
                myUser.last_name = last_name
                myUser.is_active = True
                myUser.save()

                # Create Patient and link it to the User
                myPatient = Patient(
                    first_name=first_name,
                    last_name=last_name,
                    gender=gender,
                    email=email,
                    phone=phone,
                    address=address,
                    role=role,
                    date_of_birth=date_of_birth,
                    password=password,
                    user=myUser
                )
                myPatient.save()  # Save the new patient instance to the database
                return redirect('regComplete')  # Redirect upon successful signup
            else:
                # Handle any other error or unexpected result
                return render(request, 'patient_registration/register.html', {'error_message': 'Error occurred during signup'})

    return render(request, 'patient_registration/register.html')


def signin(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')

        # Call the stored procedure for signin
        with connection.cursor() as cursor:
            cursor.callproc("SignInUser", [email, password])

            # Fetch the result from the stored procedure
            result = cursor.fetchone()
            message = result[0] if result else None

            if message and 'Login successful' in message:
                    user = authenticate(username=email, password=password)

                    if user is not None:
                        # Login the user if authentication is successful
                        login(request, user)
                        # Redirect to a success page or dashboard
                        return redirect('user_dashboard')
                    else:
                    # If authentication fails, show an error message
                        return render(request, 'patient_login/incorrectDetails.html')
            else:
                # Handle invalid credentials or other errors during signin
                return render(request, 'patient_login/incorrectDetails.html')
    else:
        return render(request, 'patient_login/login.html')

def signout(request):
    logout(request)
    return redirect('signin')
def team(request):
    return render(request,"Others/team.html")
def services(request):
    return render(request,"Others/services.html")
def contact(request):
    return render(request,"Others/contact.html")
def regComplete(request):
    return render(request,"patient_registration/regComplete.html")
def user_dashboard(request):
    return render(request,"patient/user_dashboard.html")
def incorrectDetails(request):
    return render(request,"patient_login/incorrectDetails.html")
def forgetPassword(request):
    return render(request,"forgetPassword.html")

def doctorRegisteration(request):
    if request.method == "POST":
        DoctorId = request.POST.get('doctor_id') 
        DoctorPicture = request.FILES.get('doctor_picture')
        FirstName = request.POST.get('firstName')
        LastName = request.POST.get('lastName')
        Email = request.POST.get('email')
        Gender = request.POST.get('gender')
        Speciality = request.POST.get('speciality')
        Position = request.POST.get('position')
        Pass1 = request.POST.get('Password')
        Pass2 = request.POST.get('confirmPassword')

        if User.objects.filter(username=DoctorId).exists():
            return render(request, "registrationFailed.html")

        myUser = User.objects.create_user(DoctorId,Email,Pass1)


        myDoctor = Doctor(
            Doctor_Id=DoctorId,
            Candidate_Picture=DoctorPicture,
            First_Name=FirstName,
            Last_Name=LastName,
            Email=Email,
            Gender=Gender,
            Speciality=Speciality,
            Position=Position,
            Password=Pass1,
            user=myUser
        ) 
        myUser.first_name = FirstName
        myUser.last_name = LastName
        myUser.username = DoctorId
        myUser.is_active = True
        myUser.save() 
        myDoctor.save()

        return redirect('registrationComplete')
    return render(request, "doctor_registeration/doctor_register.html")



def doctor_login(request):
    if request.method == 'POST':
        doctor_id = request.POST.get('doctor_id')
        password = request.POST.get('password')

        # Authenticate the user
        user = authenticate(username=doctor_id, password=password)

        if user is not None:
            # Login the user if authentication is successful
            login(request, user)
            # Redirect to a success page or dashboard
            return redirect('Doctor_dashboard')  # Replace 'dashboard' with your intended URL
        else:
            # If authentication fails, show an error message
            return redirect('DoctorincorrectDetails')

    return render(request, 'doctor_login/doctor_login.html')  # Replace 'doctor_login.html' with your login template name
    
def DoctorincorrectDetails(request):
    return render(request,"doctor_login/incorrectDetails.html")

@login_required
def Doctor_dashboard(request):
    return render(request,"doctor/Doctor_dashboard.html")
def registrationFailed(request):
    return render(request,"doctor/registrationFailed.html")

def registrationComplete(request):
    return render(request,"doctor_registeration/registrationComplete.html")

@login_required
def doctor_logout(request):
    logout(request)
    return redirect('doctor_login')


@login_required
def patient_list(request):
    user = request.user
    medical_records = MedicalRecord.objects.filter(Duser=user).select_related('patient', 'doctor')
    return render(request, 'doctor/patient.html',  {'medical_records': medical_records})

@login_required
def record_list(request):
    user = request.user
    medical_records = MedicalRecord.objects.filter(Duser=user).select_related('patient', 'doctor')
    return render(request, 'doctor/record.html',  {'medical_records': medical_records})

@login_required
def appointment_list(request):
    user = request.user
    appointments = Appointment.objects.filter(Duser=user).select_related('patient', 'doctor')
    return render(request, 'doctor/appointment.html', {'appointments': appointments})

@login_required
def inventory_list(request):
    inventory_items = Inventorie.objects.all()
    return render(request, 'Admin/inventory.html', {'inventory_items': inventory_items})

@login_required
def billing_list(request):
    billing_records = Billing.objects.all()
    return render(request, 'Admin/billing.html', {'billing_records': billing_records})

@login_required
def prescription_list(request):
    user = request.user
    prescriptions = Prescription.objects.filter(Duser=user).select_related('patient', 'doctor')
    return render(request, 'doctor/prescription.html', {'prescriptions': prescriptions})


@login_required
def test_list(request):
    tests = Test.objects.all()
    return render(request, 'Admin/test.html', {'tests': tests})

@login_required
def report_list(request):
    user = request.user
    reports = Report.objects.filter(Duser=user).select_related('patient', 'doctor')
    return render(request, 'doctor/report.html', {'reports': reports})

@login_required
def Patient_record_list(request):
    user = request.user
    medical_records = MedicalRecord.objects.filter(Puser=user)
    return render(request, 'patient/patient_record.html', {'medical_records': medical_records})

@login_required
def Patient_Doctor_list(request):
    user = request.user
    medical_records = MedicalRecord.objects.filter(Puser=user).select_related('patient', 'doctor')
    return render(request, 'patient/patient_doctor.html', {'medical_records': medical_records})

@login_required
def Patient_report_list(request):
    user = request.user
    reports = Report.objects.filter(Puser=user).select_related('patient', 'doctor')
    return render(request, 'patient/patient_report.html', {'reports': reports})

@login_required
def Patient_prescription_list(request):
    user = request.user
    prescriptions = Prescription.objects.filter(Puser=user).select_related('patient', 'doctor')
    return render(request, 'patient/patient_prescription.html', {'prescriptions': prescriptions})

@login_required
def Patient_appointment_list(request):
    user = request.user
    appointments = Appointment.objects.filter(Puser=user).select_related('patient', 'doctor')
    return render(request, 'patient/patient_appointment.html', {'appointments': appointments})

@login_required
def Patient_billing_list(request):
    user = request.user
    billing = Billing.objects.filter(Puser=user).select_related('patient', 'doctor')
    return render(request, 'patient/patient_billing.html', {'billing': billing})