import 'package:flutter/material.dart';

class AreaSelectionWidget extends StatelessWidget {
  final String selectedArea;
  final Function onAreaSelected;

  const AreaSelectionWidget({
    required this.selectedArea,
    required this.onAreaSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAreaModal(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedArea.isEmpty ? "Area" : selectedArea),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showAreaModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: ListView(
            children: [
              ListTile(
                title: const Text("Area 1"),
                onTap: () {
                  onAreaSelected("Area 1");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Area 2"),
                onTap: () {
                  onAreaSelected("Area 2");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
