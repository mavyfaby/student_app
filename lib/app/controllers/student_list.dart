import 'package:get/get.dart';

import '../core/student.dart';

class StudentListController extends GetxController {
  final RxList<Student> _students = <Student>[].obs;

  int get count => _students.length;

  List<Student> getStudents() {
    return _students;
  }

  Student at(int index) {
    return _students[index];
  }

  void setStudents(List<Student> students) {
    _students.assignAll(students);
    update();
  }

  void addStudent(Student student) {
    _students.add(student);
    update();

  }

  void deleteStudent(Student student) {
    _students.remove(student);
    update();
  }
}