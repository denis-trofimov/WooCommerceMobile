import 'package:get_it/get_it.dart';
import 'package:untitled/api/cocart_api_client.dart';
import 'package:untitled/api/woo_api_client.dart';
import 'package:untitled/api/wp_api_client.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/datasource/cart_data_source.dart';
import 'package:untitled/datasource/category_attribute_data_source.dart';
import 'package:untitled/datasource/customer_auth_data_source.dart';
import 'package:untitled/datasource/customer_profile_data_source.dart';
import 'package:untitled/datasource/orders_create_data_source.dart';
import 'package:untitled/datasource/orders_data_source.dart';
import 'package:untitled/datasource/payment_methods_data_source.dart';
import 'package:untitled/datasource/product_data_source.dart';
import 'package:untitled/datasource/product_review_data_source.dart';
import 'package:untitled/datasource/products_home_data_source.dart';
import 'package:untitled/datasource/catalog_data_source.dart';
import 'package:untitled/datasource/shipping_method_data_source.dart';
import 'package:untitled/datasource/shopmap_data_source.dart';

final GetIt locator = GetIt.instance;

Future setupDependencies() async {
  registerManagers();
  registerDataSources();
}

void registerDataSources() async {
  locator
    ..registerLazySingleton<CustomerAuthDataSource>(() => CustomerAuthDataSourceImpl())
    ..registerLazySingleton<CustomerProfileDataSource>(() => CustomerProfileDataSourceImpl())
    ..registerLazySingleton<OrdersDataSource>(() => OrdersDataSourceImpl())
    ..registerLazySingleton<ShippingMethodDataSource>(() => ShippingMethodDataSourceImpl())
    ..registerLazySingleton<PaymentMethodDataSource>(() => PaymentMethodDataSourceImpl())
    ..registerLazySingleton<CreateOrderDataSource>(() => CreateOrderDataSourceImpl())
    ..registerLazySingleton<ShopMapDataSource>(() => ShopMapDataSourceImpl())
    ..registerLazySingleton<CartDataSource>(() => CartDataSourceImpl())
    ..registerLazySingleton<CatalogDataSource>(() => CatalogDataSourceImpl())
    ..registerLazySingleton<CategoryAttributeDateSource>(() =>CategoryAttributeDateSourceImpl())
    ..registerLazySingleton<ProductDataSource>(() => ProductDataSourceImpl())
    ..registerLazySingleton<ProductReviewDataSource>(() => ProductReviewDataSourceImpl())
    ..registerLazySingleton<ProductsHomeDataSource>(() => ProductsHomeDataSourceImpl());
}

void registerManagers() async {
  locator
    ..registerSingleton<AppDb>(AppDb())
    ..registerSingleton<WooApiClient>(WooApiClient())
    ..registerSingleton<WpApiClient>(WpApiClient())
    ..registerSingleton<CoCartApiClient>(CoCartApiClient());
}
