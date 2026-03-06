import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository repository;
  GetCategoriesUseCase(this.repository);
  Future<Either<Failure, List<Category>>> call() => repository.getCategories();
}

class GetProductsUseCase {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);
  Future<Either<Failure, List<Product>>> call({
    int page = 1,
    int limit = 100,
  }) => repository.getProducts(page: page, limit: limit);
}

class GetProductsByCategoryUseCase {
  final ProductRepository repository;
  GetProductsByCategoryUseCase(this.repository);
  Future<Either<Failure, List<Product>>> call(String categoryId) =>
      repository.getProductsByCategory(categoryId);
}

class GetProductByIdUseCase {
  final ProductRepository repository;
  GetProductByIdUseCase(this.repository);
  Future<Either<Failure, Product>> call(String id) =>
      repository.getProductById(id);
}
