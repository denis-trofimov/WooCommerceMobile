import 'package:flutter/widgets.dart';
import 'package:wooapp/config/colors.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/model/product.dart';

class ProductPriceWidget extends StatelessWidget {

  final String price;
  final String salePrice;

  ProductPriceWidget(this.price, this.salePrice);

  ProductPriceWidget.withProduct(Product product)
      : price = product.regularPrice == '' ? product.price : product.regularPrice,
        salePrice = product.salePrice;

  @override
  Widget build(BuildContext context) {
    if (salePrice == '') {
      return Text(
        '$price${WooAppConfig.currency}',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      );
    } else {
      return Row(
        children: [
          Text(
            '$price${WooAppConfig.currency}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 16,
                color: WooTheme.priceSale,
                fontWeight: FontWeight.w800
            ),
          ),
          Text(
            ' $salePrice${WooAppConfig.currency}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ],
      );
    }
  }
}
