import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class Employee {
  String? id;
  String dni;
  String name;
  String lastName;
  String phoneNumber;
  String sede;
  Timestamp? registeredAt;
  String? fingerprintTemplate;
  String? faceRecognitionTemplate;
  bool isActive;
  bool biometricVerified;

  Employee({
    this.id,
    required this.dni,
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.sede,
    this.registeredAt,
    this.fingerprintTemplate,
    this.faceRecognitionTemplate,
    this.isActive = true,
    this.biometricVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'dni': dni,
      'name': name,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'sede': sede,  // Asegúrate de guardar el ID de la sede aquí
      'registeredAt': registeredAt ?? FieldValue.serverTimestamp(),
      'fingerprintTemplate': fingerprintTemplate,
      'faceRecognitionTemplate': faceRecognitionTemplate,
      'isActive': isActive,
      'biometricVerified': biometricVerified,
    };
  }

  factory Employee.fromMap(String id, Map<String, dynamic> data) {
    return Employee(
      id: id,
      dni: data['dni'] ?? '',
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      sede: data['sede'] ?? '',
      registeredAt: data['registeredAt'],
      fingerprintTemplate: data['fingerprintTemplate'],
      faceRecognitionTemplate: data['faceRecognitionTemplate'],
      isActive: data['isActive'] ?? true,
      biometricVerified: data['biometricVerified'] ?? false,
    );
  }

  String get fullName => '$name $lastName';
}

class BiometricTemplate {
  final Uint8List featureVector;
  final DateTime createdAt;

  BiometricTemplate({
    required this.featureVector,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Serialización a JSON
  Map<String, dynamic> toJson() => {
    'featureVector': featureVector.toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  // Deserialización desde JSON
  factory BiometricTemplate.fromJson(Map<String, dynamic> json) {
    return BiometricTemplate(
      featureVector: Uint8List.fromList(json['featureVector']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// Sede Model
class Sede {
  String? id;
  String name;
  String address;
  double latitude;
  double longitude;
  DateTime createdAt;
  bool isActive;
  int empleadosCount; // Nuevo campo para el conteo de empleados

  // Constructor mejorado con todos los parámetros necesarios
  Sede({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    DateTime? createdAt,
    this.isActive = true,
    this.empleadosCount = 0, // Valor por defecto en 0
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Método toJson para convertir a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'empleadosCount': empleadosCount, // Incluir empleadosCount
    };
  }

  // Factory para crear la sede desde un Map
  factory Sede.fromMap(String id, Map<String, dynamic> data) {
    return Sede(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      isActive: data['isActive'] ?? true,
      empleadosCount: data['empleadosCount'] ?? 0, // Agregar empleadosCount al Map
    );
  }

  // Método para mostrar la sede como un String legible
  @override
  String toString() {
    return 'Sede(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, isActive: $isActive, empleadosCount: $empleadosCount)';
  }
  
  // Método para activar o desactivar una sede
  void toggleActiveStatus() {
    isActive = !isActive;
  }
}