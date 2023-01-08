import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_products_screen.dart';
import '../utils/theme.dart';

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

    void _showDialog() {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              backgroundColor: sysTheme ? Colors.white : Colors.grey[800],
              title: Text(
                'Delete this item',
                style: TextStyle(color: sysTheme ? Colors.black : Colors.white),
              ),
              content: Text(
                'You are about to delete this item. Are you sure?',
                style: TextStyle(color: sysTheme ? Colors.black : Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(id);
                      scaffold.showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          content:
                              const Text('Product deleted successfully!')));
                      Navigator.of(context).pop();
                    } catch (error) {
                      scaffold.showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content: const Text('Deleting failed!'),
                      ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red[900]),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: sysTheme == true ? Colors.black : Colors.white,
                    ),
                  ),
                )
              ],
            )),
      );
    }

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: MyTheme.baseColor,
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
                icon: const Icon(
                  Icons.edit,
                  color: MyTheme.sec2Color,
                )),
            IconButton(
                onPressed: _showDialog,
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey[600],
                ))
          ],
        ),
      ),
    );
  }
}
