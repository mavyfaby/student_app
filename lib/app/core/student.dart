class Student {
  late int? id;
  late String image;
  late String name;
  late String course;

  Student(this.name, this.course, this.image, { this.id });

  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    image = map["image"];
    course = map['course'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'course': course,
    };
  }
}