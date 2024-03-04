// Sample data
let appointmentsData = [
    { id: 1, patient: 'John Doe', doctor: 'Dr. Smith', date: '2023-11-25', time: '10:00 AM', status: 'Scheduled' },
    // Add more appointments as needed
];

function loadAppointmentsData() {
    const tableBody = document.getElementById('appointmentTableBody');
    tableBody.innerHTML = '';

    appointmentsData.forEach(appointment => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${appointment.id}</td>
            <td>${appointment.patient}</td>
            <td>${appointment.doctor}</td>
            <td>${appointment.date}</td>
            <td>${appointment.time}</td>
            <td>${appointment.status}</td>
            <td>
                <button onclick="updateAppointment(${appointment.id})">Update</button>
            </td>
        `;
        tableBody.appendChild(row);
    });
}

function addNewAppointment() {
    // Implement logic to add a new appointment (e.g., show a form)
    alert('Implement logic to add a new appointment');
}

function updateAppointment(appointmentId) {
    // Implement logic to update the selected appointment (e.g., show a form with pre-filled data)
    alert(`Implement logic to update appointment with ID ${appointmentId}`);
}

// Call the function to load initial data
window.onload = loadAppointmentsData;
