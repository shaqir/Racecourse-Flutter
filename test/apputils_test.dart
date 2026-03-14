import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:racecourse_tracks/utils/apputils.dart';

void main() {
  final apputils = Apputils();

  group('Apputils', () {
    group('toTitleCase', () {
      test('capitalizes first letter of each word', () {
        expect(apputils.toTitleCase('hello world'), 'Hello World');
      });

      test('returns empty string for empty input', () {
        expect(apputils.toTitleCase(''), '');
      });

      test('handles single word', () {
        expect(apputils.toTitleCase('flutter'), 'Flutter');
      });
    });

    group('removeTrailingSpace', () {
      test('removes trailing space', () {
        expect(apputils.removeTrailingSpace('hello '), 'hello');
      });

      test('returns string unchanged if no trailing space', () {
        expect(apputils.removeTrailingSpace('hello'), 'hello');
      });

      test('handles empty string', () {
        expect(apputils.removeTrailingSpace(''), '');
      });
    });

    group('hexToColor', () {
      test('parses valid 6-char hex with #', () {
        final color = apputils.hexToColor('#FF0000');
        expect(color, const Color(0xFFFF0000));
      });

      test('returns black for null input', () {
        expect(apputils.hexToColor(null), const Color(0xFF000000));
      });

      test('returns black for empty input', () {
        expect(apputils.hexToColor(''), const Color(0xFF000000));
      });

      test('returns black for invalid hex', () {
        expect(apputils.hexToColor('not-a-color'), const Color(0xFF000000));
      });
    });

    group('formatDate', () {
      test('formats date as d/m/y', () {
        final date = DateTime(2026, 3, 14);
        expect(apputils.formatDate(date), '14/3/2026');
      });
    });

    group('sum', () {
      test('sums a list of integers', () {
        expect(apputils.sum([1, 2, 3, 4]), 10);
      });
    });
  });
}
