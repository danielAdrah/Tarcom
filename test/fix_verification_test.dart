import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tarcom/core/api/network/api_client.dart';
import 'package:tarcom/features/home/data/datasources/featured_materials_remote_data_source.dart';
import 'package:tarcom/features/products/data/datasources/companies_remote_data_source.dart';

void main() {
  test(
    'featured materials parse the new company FK + company_detail',
    () async {
      final dataSource = FeaturedMaterialsRemoteDataSourceImpl(
        apiClient: ApiClient(http.Client()),
      );

      final response = await dataSource.getFeaturedMaterials(
        page: 1,
        pageSize: 2,
      );

      expect(response.results, isNotEmpty);
      for (final material in response.results) {
        expect(material.companyId, isA<int>());
        expect(material.companyName, isNotEmpty);
      }
      // ignore: avoid_print
      print('featured: ${response.results.length} parsed');
      // ignore: avoid_print
      print('names: ${response.results.map((m) => m.companyName).toList()}');
    },
  );

  test('companies list still parses through getList', () async {
    final dataSource = CompaniesRemoteDataSourceImpl(
      apiClient: ApiClient(http.Client()),
    );

    final companies = await dataSource.getMaterialCompanies(categoryId: 1);

    expect(companies, isNotEmpty);
    // ignore: avoid_print
    print('companies: ${companies.map((c) => c.name).toList()}');
  });
}
