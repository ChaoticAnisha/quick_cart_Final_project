import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch categories: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final products =
          await remoteDataSource.getAllProducts(page: page, limit: limit);
      return Right(products);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      final products =
          await remoteDataSource.getProductsByCategory(categoryId);
      return Right(products);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch products: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      if (product == null) {
        return Left(ApiFailure(message: 'Product not found'));
      }
      return Right(product);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch product: $e'));
    }
  }
}
