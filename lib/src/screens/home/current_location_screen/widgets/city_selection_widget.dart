import 'package:flutter/material.dart';

class CitySelectionWidget extends StatelessWidget {
  final String selectedCity;
  final Function onCitySelected;

  const CitySelectionWidget({
    required this.selectedCity,
    required this.onCitySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCityModal(context);
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
            Text(selectedCity.isEmpty ? "City / Region" : selectedCity),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showCityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: const Text("City 1"),
              onTap: () {
                onCitySelected("City 1");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("City 2"),
              onTap: () {
                onCitySelected("City 2");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("City 3"),
              onTap: () {
                onCitySelected("City 3");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
