class Student {
  late int? id;
  late String name;
  late String course;

  Student(this.name, this.course, { this.id });

  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    course = map['course'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
    };
  }
}