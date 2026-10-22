import '../model/student.dart';
import '../model/course.dart';
import '../model/course_result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];

  int nextResultId = 1;

  // Find student
  Student? findStudent(String studentId) {
    for (Student student in students) {
      if (student.id == studentId) {
        return student;
      }
    }
    return null;
  }

  // Find course
  Course? findCourse(String courseId) {
    for (Course course in courses) {
      if (course.id == courseId) {
        return course;
      }
    }
    return null;
  }

  // Add student
  void addStudent({
    required String studentId,
    required String studentName,
  }) {
    if (findStudent(studentId) != null) {
      throw Exception('Student already exists');
    }

    students.add(
      Student(id: studentId, name: studentName),
    );
  }

  // Remove student and all related data
  void removeStudent({required String studentId}) {
    if (findStudent(studentId) == null) {
      throw Exception('Student not found');
    }

    results.removeWhere(
      (result) => result.studentId == studentId,
    );

    for (Course course in courses) {
      course.studentIds.remove(studentId);
    }

    students.removeWhere(
      (student) => student.id == studentId,
    );
  }

  // Add course
  void addCourse({
    required String courseId,
    required String courseName,
  }) {
    if (findCourse(courseId) != null) {
      throw Exception('Course already exists');
    }

    courses.add(
      Course(id: courseId, name: courseName),
    );
  }

  // Remove course
  void removeCourse({required String courseId}) {
    Course? course = findCourse(courseId);

    if (course == null) {
      throw Exception('Course not found');
    }

    if (course.studentIds.isNotEmpty) {
      throw Exception('Course still has enrolled students');
    }

    if (results.any((r) => r.courseId == courseId)) {
      throw Exception('Course still has results');
    }

    courses.remove(course);
  }

  // Enroll student in course
  void enrollStudent({
    required String studentId,
    required String courseId,
  }) {
    if (findStudent(studentId) == null) {
      throw Exception('Student not found');
    }

    Course? course = findCourse(courseId);

    if (course == null) {
      throw Exception('Course not found');
    }

    if (course.studentIds.contains(studentId)) {
      throw Exception('Student already enrolled');
    }

    course.studentIds.add(studentId);
  }

  // Remove student from course
  void discardStudentFromCourse({
    required String studentId,
    required String courseId,
  }) {
    if (findStudent(studentId) == null) {
      throw Exception('Student not found');
    }

    Course? course = findCourse(courseId);

    if (course == null) {
      throw Exception('Course not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student is not enrolled');
    }

    if (results.any(
      (r) => r.studentId == studentId && r.courseId == courseId,
    )) {
      throw Exception('Remove results before unenrolling');
    }

    course.studentIds.remove(studentId);
  }

  // Add result
  CourseResult addResult({
    required String studentId,
    required String courseId,
    required double score,
  }) {
    if (findStudent(studentId) == null) {
      throw Exception('Student not found');
    }

    Course? course = findCourse(courseId);

    if (course == null) {
      throw Exception('Course not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student is not enrolled');
    }

    if (!score.isFinite || score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    }

    CourseResult result = CourseResult(
      id: 'R${nextResultId++}',
      studentId: studentId,
      courseId: courseId,
      score: score,
    );

    results.add(result);

    return result;
  }

  // Remove result
  void removeResult({required String resultId}) {
    if (!results.any((r) => r.id == resultId)) {
      throw Exception('Result not found');
    }

    results.removeWhere((r) => r.id == resultId);
  }
}
