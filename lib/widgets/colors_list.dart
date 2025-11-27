import 'package:flutter/material.dart';

class ColorsList extends StatefulWidget {
  const ColorsList({
    super.key,
    required this.onColorSelected,
    this.selectedColor,
  });
  final Function(Color) onColorSelected;
  final Color? selectedColor;

  @override
  State<ColorsList> createState() => _ColorsListState();
}

class _ColorsListState extends State<ColorsList> {
  final List<Color> colorsList = [
    Color(0xFF2A9D8F),
    Color(0xFFFFCCBC),
    Color(0xFFC8E6C9),
    Color(0xFFB3E5FC),
    Color(0xFFD1C4E9),
    Color(0xFFE9C46A),
    Color(0xFFFFCC80),
    Color(0xFFFFC107),
    Color(0xFFF4A261),
    Color(0xFFE76F51),
    Color(0xFFB56576),
    Color(0xFFE56B6F),
    Color(0xFFBFD7EA),
  ];

  late int selectedIndex;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    // لو فيه لون موجود مسبقًا، نحدّد الـ index بتاعه
    if (widget.selectedColor != null &&
        colorsList.contains(widget.selectedColor)) {
      selectedIndex = colorsList.indexOf(widget.selectedColor!);
    } else {
      selectedIndex = 0;
    }
    scrollController = ScrollController(
      initialScrollOffset:
          selectedIndex * 50.0, // تقريبياً حجم كل عنصر + padding
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: colorsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onColorSelected(colorsList[index]);
            },
            child: ColorItem(
              backgroundColor: colorsList[index],
              isSelected: selectedIndex == index,
            ),
          );
        },
      ),
    );
  }
}

class ColorItem extends StatelessWidget {
  const ColorItem({
    super.key,
    required this.backgroundColor,
    required this.isSelected,
  });

  final Color backgroundColor;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 35,
              child: CircleAvatar(backgroundColor: backgroundColor, radius: 32),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: CircleAvatar(backgroundColor: backgroundColor, radius: 32),
          );
  }
}
