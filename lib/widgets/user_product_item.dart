import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_products_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    bool sysTheme = ThemeData.light().useMaterial3;
    return ListTile(
      title: Text(title, style: TextStyle(color: sysTheme == true ? Colors.black : Colors.white,),),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            imageUrl), // fetches an image from its url. In this case, from the network.
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                    scaffold.showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: const Text('Product deleted successfully!')));
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text('Deleting failed!'),
                    ));
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ))
          ],
        ),
      ),
    );
  }
}
