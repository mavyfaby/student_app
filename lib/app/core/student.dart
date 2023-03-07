class Student {
  late String name;
  late String course;

  Student({ required this.name, required this.course });

  Student.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    course = map['course'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'course': course,
    };
  }
}