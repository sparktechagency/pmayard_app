import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pmayard_app/models/resources/grade_model.dart';
import 'package:pmayard_app/models/resources/metarials_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class ResourceController extends GetxController {
  /// ================== Grade Related Work ==================
  List<GradesModel> gradeData = [];

  // Loading Status
  bool isLoadingResource = false;
  bool isLoadingResourceMore = false;

  // Pagination Controllers
  int currentPage = 1;
  int totalPage = 1;
  bool hasMoreData = true;

  Future<void> fetchResource({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isLoadingResource = true;
      // Clear data only on first load, not on load more
      if (!isLoadingResourceMore) {
        gradeData.clear();
        currentPage = 1; // Reset to page 1 on fresh load
      }
    } else {
      isLoadingResourceMore = true;
    }

    update();

    try {
      final response = await ApiClient.getData(
          ApiUrls.gradeSearch(currentPage)
      );

      if (response.statusCode == 200) {
        final data = response.body['data'] ?? [];
        final meta = response.body['meta'] ?? {};

        if (data is List && data.isNotEmpty) {
          List<GradesModel> items = data
              .map((e) => GradesModel.fromJson(e))
              .toList();
          gradeData.addAll(items);
        }

        // Get pagination info from meta
        currentPage = meta['page'] ?? currentPage;
        totalPage = meta['totalPage'] ?? 1;
        hasMoreData = currentPage < totalPage;

        // Debug prints
        print('✅ Page loaded: $currentPage');
        print('✅ Total pages: $totalPage');
        print('✅ Has more data: $hasMoreData');
        print('✅ Total items: ${gradeData.length}');

      } else {
        showToast('Something went wrong');
      }
    } catch(e) {
      debugPrint('Fetch resource error: ${e.toString()}');
      showToast('Network error');
    } finally {
      isLoadingResource = false;
      isLoadingResourceMore = false;
      update();
    }
  }

  Future<void> loadMoreData() async {
    // Don't load if already loading or no more data
    if (isLoadingResourceMore || !hasMoreData) {
      print('❌ Cannot load more: isLoading=$isLoadingResourceMore, hasMore=$hasMoreData');
      return;
    }

    print('⬇️ Loading more data...');

    // Increment page BEFORE API call
    currentPage++;
    print('📄 New page: $currentPage');

    await fetchResource(isLoadMore: true);
  }

  Future<void> refreshData() async {
    print('🔄 Refreshing data...');
    // Reset to page 1
    currentPage = 1;
    hasMoreData = true;
    await fetchResource();
  }

  /// ================== Subject Related Work ==================

  bool isLoadingSubject = false;
  List<GradesModel> subjectDatas = [];

  Future<void> fetchSubjectData(String subjectId) async {
    isLoadingSubject = true;
    subjectDatas.clear();
    update();

    final response = await ApiClient.getData(
        ApiUrls.subjectsSearch(subjectId)
    );

    if (response.statusCode == 200) {
      final items = response.body['data'] ?? [];

      if (items is List && items.isNotEmpty) {
        List<GradesModel> data = items
            .map((e) => GradesModel.fromJson(e))
            .toList();
        subjectDatas.addAll(data);
      }
    } else {
      showToast('Something Went Wrong');
    }

    isLoadingSubject = false;
    update();
  }

  ///================ Material Related Work ==================

  bool isLoadingMaterial = false;
  List<MetarialsModel> metarialsModel = [];

  Future<void> fetchMetarials(String materialsID) async {
    isLoadingMaterial = true;
    metarialsModel.clear();
    update();

    final response = await ApiClient.getData(
        ApiUrls.materialsSearch(materialsID)
    );

    if (response.statusCode == 200) {
      final items = response.body['data'] ?? [];
      if (items is List && items.isNotEmpty) {
        List<MetarialsModel> data = items
            .map((e) => MetarialsModel.fromJson(e))
            .toList();
        metarialsModel.addAll(data);
      }
    } else {
      showToast('Something went wrong');
    }
    isLoadingMaterial = false;
    update();
  }
}