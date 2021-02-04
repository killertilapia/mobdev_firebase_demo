
class EmployeeModel {
  String id;
  String name;
  String description;
  String title;
  String email;
  double baseSalaryPerHour;

  EmployeeModel({
    this.id,
    this.name,
    this.description,
    this.title,
    this.email,
    this.baseSalaryPerHour
  });

  Map<String, dynamic> toFirebase() => {
    "id": id,
    "name": name,
    "description": description,
    "title": title,
    "email": email,
    "baseSalaryPerHour": baseSalaryPerHour
  };

  // fromFirebase
  factory EmployeeModel.fromFirebase(Map<String, dynamic> jsonFromFirebase){
    return EmployeeModel(
      id: jsonFromFirebase['id'],
      name: jsonFromFirebase['name'],
      description: jsonFromFirebase['description'],
      title: jsonFromFirebase['title'],
      email: jsonFromFirebase['email'],
      baseSalaryPerHour: jsonFromFirebase['baseSalaryPerHour']
    );
  }
}