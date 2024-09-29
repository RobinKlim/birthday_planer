import 'package:birthday_planer/pages/Gifts/gift_detail.page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/gift_idea.dart';

class GiftListItem extends StatelessWidget {
  final GiftIdea gift;

  GiftListItem({required this.gift});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(gift.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (gift.description != null) Text(gift.description!),
            if (gift.url != null) Text(gift.url!),
            if (gift.priceInEuro != null) Text('${gift.priceInEuro!.toString()}€'),
          ],
        ),
        trailing: Icon(Icons.navigate_next),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GiftDetailPage(
                      giftIdea: gift,
                    )),
          );
        },
      ),
    );
  }
}
