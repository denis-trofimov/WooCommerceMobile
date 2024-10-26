import 'package:wooapp/database/entity/filter.dart';


abstract class CategoryFilterState {}

class LoadingCategoryFilterState extends CategoryFilterState {}

class EmptyCategoryFilterState extends CategoryFilterState {}

class ContentCategoryFilterState extends CategoryFilterState {
  List<Filter> filters;

  ContentCategoryFilterState(this.filters);
}

class ErrorCategoryFilterState extends CategoryFilterState {}