class Doctor {
  String docName;
  String clinicName;
  String address;

  Doctor({
    required this.docName,
    required this.clinicName,
    required this.address,
  });

  // Factory constructor to create a Doctor object from a map
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      docName: map['docName'],
      clinicName: map['clinicName'],
      address: map['address'],
    );
  }

  // Convert the Doctor object to a map
  Map<String, dynamic> toMap() {
    return {
      'docName': docName,
      'clinicName': clinicName,
      'address': address,
    };
  }
}

List<Doctor> therapyDoctors = [
  Doctor(
    docName: "Dr. Emily Johnson",
    clinicName: "Relaxation Therapy Center",
    address: "123 Main Street, Cityville, ST 12345",
  ),
  Doctor(
    docName: "Dr. Michael Smith",
    clinicName: "Mindful Healing Clinic",
    address: "456 Elm Avenue, Townsville, ST 67890",
  ),
  Doctor(
    docName: "Dr. Sarah Davis",
    clinicName: "Harmony Wellness Center",
    address: "789 Oak Lane, Villagetown, ST 23456",
  ),
  Doctor(
    docName: "Dr. James Brown",
    clinicName: "Peaceful Mind Therapy",
    address: "101 Pine Street, Tranquil City, ST 54321",
  ),
  Doctor(
    docName: "Dr. Laura Martinez",
    clinicName: "Serenity Care Clinic",
    address: "555 Willow Road, Calmville, ST 78901",
  ),
  Doctor(
    docName: "Dr. Daniel Wilson",
    clinicName: "Tranquility Wellness Institute",
    address: "321 Cedar Avenue, Serenetown, ST 12345",
  ),
  Doctor(
    docName: "Dr. Jessica Lee",
    clinicName: "Balance Therapy Center",
    address: "777 Birch Street, Harmonyville, ST 67890",
  ),
  Doctor(
    docName: "Dr. Robert Harris",
    clinicName: "Mind and Body Harmony Clinic",
    address: "999 Maple Lane, Peaceful City, ST 23456",
  ),
  Doctor(
    docName: "Dr. Olivia White",
    clinicName: "Relaxation Oasis",
    address: "444 Walnut Road, Tranquilville, ST 54321",
  ),
  Doctor(
    docName: "Dr. Benjamin Turner",
    clinicName: "Calm Mind Therapy",
    address: "222 Spruce Avenue, Zen Town, ST 78901",
  ),
];

