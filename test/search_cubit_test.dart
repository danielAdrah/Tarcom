// import 'dart:async';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:tarcom/features/products/domain/entities/material_entity.dart';
// import 'package:tarcom/features/products/domain/entities/materials_response_entity.dart';
// import 'package:tarcom/features/products/domain/repositories/materials_repository.dart';
// import 'package:tarcom/features/products/domain/usecases/get_materials_use_case.dart';
// import 'package:tarcom/features/search/presentation/cubit/search_cubit.dart';

// /// repository وهمي للتحكم في نتائج البحث وعدّ الاستدعاءات وتوقيت الاستجابة.
// class _FakeMaterialsRepository implements MaterialsRepository {
//   _FakeMaterialsRepository({this.responder});

//   /// دالة تختار الاستجابة حسب نص البحث؛ إن غابت ترجع استجابة فارغة.
//   final MaterialsResponseEntity Function(String? search)? responder;

//   /// دالة للتحكم المتأخر (لتجارب تجاهل الردود المتقادمة).
//   final Future<MaterialsResponseEntity> Function(String? search)? asyncResponder;

//   int callCount = 0;
//   String? lastSearch;

//   @override
//   Future<MaterialsResponseEntity> getMaterials({
//     required int? category,
//     required int? company,
//     String? companyName,
//     bool? isActive,
//     String? search,
//     String? ordering,
//     String? specKey1,
//     String? specKey2,
//     String? specKey3,
//     String? specKey4,
//     String? specKey5,
//     String? specVal1,
//     String? specVal2,
//     String? specVal3,
//     String? specVal4,
//     String? specVal5,
//     int? page,
//     int? pageSize,
//   }) async {
//     callCount++;
//     lastSearch = search;
//     if (asyncResponder != null) return asyncResponder!(search);
//     return responder?.call(search) ??
//         const MaterialsResponseEntity(
//           count: 0,
//           next: null,
//           previous: null,
//           results: [],
//         );
//   }
// }

// MaterialEntity _material(int id, {String ar = ''}) => MaterialEntity(
//   id: id,
//   name: 'item$id',
//   nameEn: 'item$id',
//   nameAr: ar.isNotEmpty ? ar : 'منتج $id',
//   description: 'desc',
//   descriptionEn: 'desc',
//   descriptionAr: 'desc',
//   category: 1,
//   categoryName: 'cat',
//   uom: 1,
//   uomName: 'pcs',
//   companyId: 1,
//   companyName: 'Company',
//   supplierPrice: 1,
//   consumerPrice: 10,
//   isActive: true,
//   expireDate: null,
//   specKey1: null,
//   specKey2: null,
//   specKey3: null,
//   specKey4: null,
//   specKey5: null,
//   specVal1: null,
//   specVal2: null,
//   specVal3: null,
//   specVal4: null,
//   specVal5: null,
//   image1: null,
//   image2: null,
//   image3: null,
//   image4: null,
//   image5: null,
//   createdAt: DateTime(2026),
//   updatedAt: DateTime(2026),
// );

// MaterialsResponseEntity _response(List<MaterialEntity> items, {int? count}) =>
//     MaterialsResponseEntity(
//       count: count ?? items.length,
//       next: null,
//       previous: null,
//       results: items,
//     );

// void main() {
//   test('queries shorter than 2 chars never hit the repository', () async {
//     final repo = _FakeMaterialsRepository();
//     final cubit = SearchCubit(getMaterialsUseCase: GetMaterialsUseCase(repo));

//     cubit.onQueryChanged('l');
//     cubit.onQueryChanged('');
//     await Future.delayed(const Duration(milliseconds: 600));

//     expect(repo.callCount, 0);
//     expect(cubit.state, isA<SearchInitial>());
//     await cubit.close();
//   });

//   test('debounce coalesces rapid keystrokes into a single request', () async {
//     final repo = _FakeMaterialsRepository(
//       responder: (s) => _response([_material(1)]),
//     );
//     final cubit = SearchCubit(getMaterialsUseCase: GetMaterialsUseCase(repo));

//     cubit.onQueryChanged('la');
//     cubit.onQueryChanged('lap');
//     cubit.onQueryChanged('lapt');
//     cubit.onQueryChanged('laptop');

//     // انتظار أطول من مدة الـ debounce (400ms) لضمان تنفيذ طلب واحد.
//     await Future.delayed(const Duration(milliseconds: 700));

//     expect(repo.callCount, 1);
//     expect(repo.lastSearch, 'laptop');
//     expect(cubit.state, isA<SearchResults>());
//     await cubit.close();
//   });

//   test('empty results emit SearchEmpty', () async {
//     final repo = _FakeMaterialsRepository(
//       responder: (s) => _response(const []),
//     );
//     final cubit = SearchCubit(getMaterialsUseCase: GetMaterialsUseCase(repo));

//     cubit.onQueryChanged('zzz');
//     await Future.delayed(const Duration(milliseconds: 700));

//     expect(cubit.state, isA<SearchEmpty>());
//     await cubit.close();
//   });

//   test('truncated results set the show-see-all flag', () async {
//     final repo = _FakeMaterialsRepository(
//       responder: (s) =>
//           _response(List.generate(6, (i) => _material(i)), count: 42),
//     );
//     final cubit = SearchCubit(getMaterialsUseCase: GetMaterialsUseCase(repo));

//     cubit.onQueryChanged('lap');
//     await Future.delayed(const Duration(milliseconds: 700));

//     final state = cubit.state;
//     expect(state, isA<SearchResults>());
//     expect((state as SearchResults).truncated, isTrue);
//     await cubit.close();
//   });

//   test('micro-cache serves repeated queries without a second request', () async {
//     final repo = _FakeMaterialsRepository(
//       responder: (s) => _response([_material(1)]),
//     );
//     final cubit = SearchCubit(getMaterialsUseCase: GetMaterialsUseCase(repo));

//     cubit.retry('laptop');
//     await Future.delayed(const Duration(milliseconds: 50));
//     // نفس النص (بتطبيع حالة الأحرف/المسافات) يجب أن يُخدَم من الكاش.
//     cubit.retry('  Laptop  ');
//     await Future.delayed(const Duration(milliseconds: 50));

//     expect(repo.callCount, 1);
//     expect(cubit.state, isA<SearchResults>());
//     await cubit.close();
//   });

//   test('stale responses are dropped in favour of the latest request', () async {
//     final slowCompleter = Completer<MaterialsResponseEntity>();

//     final repo = _FakeMaterialsRepository(
//       asyncResponder: (search) {
//         if (search == 'aaaa') return slowCompleter.future;
//         return Future.value(_response([_material(99)]));
//       },
//     );
//     final cubit = SearchCubit(getMaterialsUseCase: GetMaterialsUseCase(repo));

//     // الطلب الأبطأ يبدأ أولاً لكنه يتأخر في التسليم.
//     cubit.retry('aaaa');
//     await Future.delayed(const Duration(milliseconds: 10));
//     // الطلب الأحدث يحسم الحالة أولاً.
//     cubit.retry('bbbb');
//     await Future.delayed(const Duration(milliseconds: 30));

//     expect((cubit.state as SearchResults).items.first.id, 99);

//     // الآن يصل الرد المتقادم — يجب أن يُتجاهل ولا يغيّر الحالة.
//     slowCompleter.complete(_response([_material(1)]));
//     await Future.delayed(const Duration(milliseconds: 30));

//     expect((cubit.state as SearchResults).items.first.id, 99);
//     await cubit.close();
//   });

//   test('dismiss resets to initial and cancels pending work', () async {
//     final repo = _FakeMaterialsRepository(
//       responder: (s) => _response([_material(1)]),
//     );
//     final cubit = SearchCubit(getMaterialsUseCase: GetMaterialsUseCase(repo));

//     cubit.onQueryChanged('lap');
//     cubit.dismiss();
//     await Future.delayed(const Duration(milliseconds: 700));

//     expect(cubit.state, isA<SearchInitial>());
//     expect(repo.callCount, 0);
//     await cubit.close();
//   });
// }
