import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/product_state.dart';
import '../../data/datasources/remote/product_remote_datasource.dart';

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, ProductState>((ref) {
  return ProductViewModel();
});

class ProductViewModel extends StateNotifier<ProductState> {
  final ProductRemoteDataSource _dataSource = ProductRemoteDataSource();

  ProductViewModel() : super(const ProductState());

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final products = await _dataSource.getAllProducts();
    state = state.copyWith(
      products: products,
      allProducts: products,
      isLoading: false,
    );
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isCategoriesLoading: true);
    final categories = await _dataSource.getCategories();
    state = state.copyWith(categories: categories, isCategoriesLoading: false);
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(products: state.allProducts, clearCategory: true);
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    final products = await _dataSource.searchProducts(query);
    state = state.copyWith(products: products, isLoading: false);
  }

  Future<void> filterByCategory(String categoryId) async {
    state = state.copyWith(
      isLoading: true,
      selectedCategoryId: categoryId,
      clearError: true,
    );
    final products = await _dataSource.getProductsByCategory(categoryId);
    state = state.copyWith(products: products, isLoading: false);
  }

  void clearFilter() {
    state = state.copyWith(products: state.allProducts, clearCategory: true);
  }
}
