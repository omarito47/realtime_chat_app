import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';

class UserTile extends StatefulWidget {
  final String text;
  final String? imageUrl; // New property to hold the user's image URL
  final void Function()? onTap;

  const UserTile({
    Key? key,
    required this.text,
    this.imageUrl, // Pass the image URL to the widget
    required this.onTap,
  }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("img url :${widget.imageUrl}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(ConstantHelper.sizex20),
        margin: EdgeInsets.symmetric(
          vertical: ConstantHelper.sizex08,
          horizontal: ConstantHelper.sizex20,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(ConstantHelper.sizex12),
        ),
        child: Row(
          children: [
            
            Padding(
              padding: EdgeInsets.all(ConstantHelper.sizex08),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: ConstantHelper.sizex20,
                    backgroundColor: Colors.grey[300],
                  ),
                  if (widget.imageUrl != null)
                    Positioned.fill(
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder_image.jpg',
                          image: widget.imageUrl!,
                          fit: BoxFit.cover,
                          width: ConstantHelper.sizex20*2,
                          height: ConstantHelper.sizex20*2,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.onSecondary,
                            );
                          },
                        ),
                      ),
                    ),
                  if (widget.imageUrl == null)
                   Padding(
              padding: EdgeInsets.all(ConstantHelper.sizex08),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
                ],
              ),
            ),
            SizedBox(width: ConstantHelper.sizex20),
            // Text
            Padding(
              padding: EdgeInsets.all(ConstantHelper.sizex08),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
