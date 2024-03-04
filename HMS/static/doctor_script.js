// Sample data for doctors
let doctorsData = [
    { id: 1, name: 'Dr. Smith', experience: '10 years', specialization: 'Cardiology', age: 45, contact: '123-456-7890' },
    // Add more doctors as needed
];

// Function to load doctors data into the table
function loadDoctorsData() {
    const tableBody = document.getElementById('doctorTableBody');
    tableBody.innerHTML = '';

    doctorsData.forEach(doctor => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${doctor.id}</td>
            <td>${doctor.name}</td>
            <td>${doctor.experience}</td>
            <td>${doctor.specialization}</td>
            <td>${doctor.age}</td>
            <td>${doctor.contact}</td>
            <td>
                <button onclick="updateDoctor(${doctor.id})">Update</button>
            </td>
        `;
        tableBody.appendChild(row);
    });
}

// Function to add a new doctor
function addNewDoctor() {
    // Implement logic to add a new doctor (e.g., show a form)
    alert('Implement logic to add a new doctor');
}

// Function to update a doctor
function updateDoctor(doctorId) {
    // Implement logic to update the selected doctor (e.g., show a form with pre-filled data)
    alert(`Implement logic to update doctor with ID ${doctorId}`);
}

// Call the function to load initial data
window.onload = loadDoctorsData;
