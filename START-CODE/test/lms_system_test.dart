
import 'package:test/test.dart';
import '../lib/service/lms_system.dart';

void main() {
  test('Remove one student and preserve the other student data', () {
    final lms = LmsSystem();

    // 1. Create two students
    lms.addStudent(
      studentId: 'S01',
      studentName: 'Ronan',
    );

    lms.addStudent(
      studentId: 'S02',
      studentName: 'Alice',
    );

    // 2. Create a course
    lms.addCourse(
      courseId: 'C01',
      courseName: 'Mobile Development',
    );

    // 3. Enroll both students
    lms.enrollStudent(
      studentId: 'S01',
      courseId: 'C01',
    );

    lms.enrollStudent(
      studentId: 'S02',
      courseId: 'C01',
    );

    // 4. Add results for both students
    final result1 = lms.addResult(
      studentId: 'S01',
      courseId: 'C01',
      score: 85,
    );

    final result2 = lms.addResult(
      studentId: 'S02',
      courseId: 'C01',
      score: 90,
    );

    // 5. Verify initial data
    expect(lms.students.length, 2);
    expect(lms.courses.length, 1);
    expect(lms.courses.first.studentIds.length, 2);
    expect(lms.results.length, 2);

    // 6. Remove student S01
    lms.removeStudent(studentId: 'S01');

    // 7. Verify S01 has been removed
    expect(
      lms.students.any((s) => s.id == 'S01'),
      isFalse,
    );

    expect(
      lms.courses.first.studentIds.contains('S01'),
      isFalse,
    );

    expect(
      lms.results.any((r) => r.studentId == 'S01'),
      isFalse,
    );

    // Verify S01's result has been removed
    expect(
      lms.results.any((r) => r.id == result1.id),
      isFalse,
    );

    // 8. Verify S02 still exists
    expect(
      lms.students.any((s) => s.id == 'S02'),
      isTrue,
    );

    expect(
      lms.students.firstWhere((s) => s.id == 'S02').name,
      'Alice',
    );

    // Verify S02 is still enrolled
    expect(
      lms.courses.first.studentIds.contains('S02'),
      isTrue,
    );

    // Verify S02's result remains unchanged
    expect(
      lms.results.any((r) => r.id == result2.id),
      isTrue,
    );

    expect(
      lms.results.firstWhere((r) => r.id == result2.id).score,
      90,
    );

    // 9. Verify the course still exists
    expect(
      lms.courses.any((c) => c.id == 'C01'),
      isTrue,
    );

    // 10. Verify only one student and one result remain
    expect(lms.students.length, 1);
    expect(lms.courses.first.studentIds.length, 1);
    expect(lms.results.length, 1);
  });
}
