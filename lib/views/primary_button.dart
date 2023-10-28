import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onTap,
    this.width = 150,
    this.height = 50,
    this.color = const Color(0xff116D6E),
    this.enable = true,
    this.label = "Votar",
  });

  final double width;

  final double height;

  final Color color;

  final bool enable;

  final String label;

  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: enable ? onTap : null,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.white),
            color: enable ? color : const Color(0xff917B7B),
            boxShadow: enable
                ? [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(.3),
                    ),
                  ]
                : [],
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
