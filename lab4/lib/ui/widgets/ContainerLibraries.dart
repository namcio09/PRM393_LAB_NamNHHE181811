import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ===== CARD (Container) =====
class ExerciseCard extends StatelessWidget {
  final String line1;
  final String line2;

  const ExerciseCard({
    super.key,
    required this.line1,
    required this.line2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: CardRow(line1: line1, line2: line2),
    );
  }
}

/// ===== ROW LỚN (chia 2 cột) =====
class CardRow extends StatelessWidget {
  final String line1;
  final String line2;

  const CardRow({
    super.key,
    required this.line1,
    required this.line2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: ContentColumn(line1: line1, line2: line2)),
        const SizedBox(width: 10),
        const ArrowColumn(),
      ],
    );
  }
}

/// ===== COLUMN 1: nội dung (gồm 2 row nhỏ) =====
class ContentColumn extends StatelessWidget {
  final String line1;
  final String line2;

  const ContentColumn({
    super.key,
    required this.line1,
    required this.line2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleRow(text: line1),
        const SizedBox(height: 4),
        SubtitleRow(text: line2),
      ],
    );
  }
}

/// ===== ROW nhỏ 1: tiêu đề =====
class TitleRow extends StatelessWidget {
  final String text;

  const TitleRow({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// ===== ROW nhỏ 2: dòng phụ =====
class SubtitleRow extends StatelessWidget {
  final String text;

  const SubtitleRow({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

/// ===== COLUMN 2: mũi tên =====
class ArrowColumn extends StatelessWidget {
  const ArrowColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.chevron_right, color: Colors.black54, size: 26),
      ],
    );
  }
}
