<!-- patients/script.js -->
{% load static %}

// Sample data
let patientsData = [
    { id: 1, name: 'John Doe', age: 30, doctor: 'Dr. Smith', appointment_date: '2023-11-25', phone_no: '1234567890', email: 'john@example.com' },
    // Add more patients as needed
];

function loadPatientsData() {
    const tableBody = document.getElementById('patientTableBody');
    tableBody.innerHTML = '';

    patientsData.forEach(patient => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${patient.id}</td>
            <td>${patient.name}</td>
            <td>${patient.age}</td>
            <td>${patient.doctor}</td>
            <td>${patient.appointment_date}</td>
            <td>${patient.phone_no}</td>
            <td>${patient.email}</td>
        `;
        tableBody.appendChild(row);
    });
}

// Call the function to load initial data
window.onload = loadPatientsData;
