// Create a new stateful widget for the profile image
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatefulWidget {
  final String? profileImage;
  final Function() onTap;
  final String name;

  const ProfileImageWidget({
    Key? key,
    required this.profileImage,
    required this.onTap,
    required this.name,
  }) : super(key: key);

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  String? _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.profileImage;
  }

  @override
  void didUpdateWidget(ProfileImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileImage != widget.profileImage) {
      setState(() {
        _currentImage = widget.profileImage;
      });
    }
  }

  Color _getColorForLetter(String letter) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.cyan,
      Colors.indigo,
      Colors.pink,
      Colors.brown
    ];
    int index = letter.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '';

    return Stack(
      children: [
        CircleAvatar(
          radius: 57,
          backgroundColor: Colors.grey[300],
          child: _currentImage != null && _currentImage!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    _currentImage!,
                    width: 114,
                    height: 114,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Show first letter on error
                      return CircleAvatar(
                        radius: 57,
                        backgroundColor: _getColorForLetter(firstLetter),
                        child: Text(
                          firstLetter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                )
              : CircleAvatar(
                  radius: 57,
                  backgroundColor: _getColorForLetter(firstLetter),
                  child: Text(
                    firstLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}