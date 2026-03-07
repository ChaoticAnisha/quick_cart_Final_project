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

    // If API returned nothing, fall back to client-side filter by category name.
    // Backend stores product.category as a string name (e.g. "Dairy"), not ObjectId.
    if (products.isEmpty && state.allProducts.isNotEmpty) {
      final category = state.categories
          .where((c) => c.id == categoryId)
          .firstOrNull;
      if (category != null) {
        final lower = category.name.toLowerCase();
        final filtered = state.allProducts
            .where((p) =>
                (p.categoryName?.toLowerCase() == lower) ||
                (p.categoryId.toLowerCase() == lower))
            .toList();
        state = state.copyWith(products: filtered, isLoading: false);
        return;
      }
    }

    state = state.copyWith(products: products, isLoading: false);
  }

  void clearFilter() {
    state = state.copyWith(products: state.allProducts, clearCategory: true);
  }

  void sortProducts(SortOption option) {
    final sorted = [...state.products];
    switch (option) {
      case SortOption.priceAsc:
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case SortOption.ratingDesc:
        sorted.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
      case SortOption.none:
        break;
    }
    state = state.copyWith(products: sorted, sortOption: option);
  }
}
