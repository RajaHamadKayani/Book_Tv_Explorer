class UserModel {
  final String id;
  final String email;
  final String phone;
  final String? imageUrl; // New field for image URL
  final String name;
  final String address;


  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    this.imageUrl,
    required this.address,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      "name":name,
      "address":address
    };
  }

  // Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      address: map['address'],
      name: map['name'] ?? "",
      id: documentId,
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }
}
