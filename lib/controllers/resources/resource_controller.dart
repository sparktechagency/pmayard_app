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
  int currentResourcePage = 1;
  int totalResourcePage = 1;
  bool hasMoreResourceData = true;

  Future<void> fetchResource({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isLoadingResource = true;
      if (!isLoadingResourceMore) {
        gradeData.clear();
        currentResourcePage = 1;
      }
    } else {
      isLoadingResourceMore = true;
    }

    update();

    try {
      final response = await ApiClient.getData(
          ApiUrls.gradeSearch(currentResourcePage)
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
        currentResourcePage = meta['page'] ?? currentResourcePage;
        totalResourcePage = meta['totalPage'] ?? 1;
        hasMoreResourceData = currentResourcePage < totalResourcePage;

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

  Future<void> loadMoreResourceData() async {
    if (isLoadingResourceMore || !hasMoreResourceData) {
      return;
    }
    currentResourcePage++;
    await fetchResource(isLoadMore: true);
  }

  Future<void> refreshResourceData() async {
    currentResourcePage = 1;
    hasMoreResourceData = true;
    await fetchResource();
  }

  /// ================== Subject Related Work ==================

  // Subject Pagination Variables
  String? currentSubjectId;
  bool isLoadingSubject = false;
  bool isLoadingSubjectMore = false;
  List<GradesModel> subjectDatas = [];

  // Subject Pagination Controllers
  int currentSubjectPage = 1;
  int totalSubjectPage = 1;
  bool hasMoreSubjectData = true;

  Future<void> fetchSubjectData(String subjectId, {bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isLoadingSubject = true;
      currentSubjectId = subjectId;
      if (!isLoadingSubjectMore) {
        subjectDatas.clear();
        currentSubjectPage = 1;
      }
    } else {
      isLoadingSubjectMore = true;
    }

    update();

    try {
      final response = await ApiClient.getData(
          ApiUrls.subjectsSearch(subjectId,  currentSubjectPage)
      );

      if (response.statusCode == 200) {
        final items = response.body['data'] ?? [];
        final meta = response.body['meta'] ?? {};

        if (items is List && items.isNotEmpty) {
          List<GradesModel> data = items
              .map((e) => GradesModel.fromJson(e))
              .toList();

          if (isLoadMore) {
            subjectDatas.addAll(data);
          } else {
            subjectDatas = data;
          }
        }

        // Update pagination info
        currentSubjectPage = meta['page'] ?? currentSubjectPage;
        totalSubjectPage = meta['totalPage'] ?? 1;
        hasMoreSubjectData = currentSubjectPage < totalSubjectPage;

      } else {
        showToast('Something Went Wrong');
      }
    } catch (e) {
      debugPrint('Fetch subject error: ${e.toString()}');
      showToast('Network error');
    } finally {
      isLoadingSubject = false;
      isLoadingSubjectMore = false;
      update();
    }
  }

  Future<void> loadMoreSubjectData() async {
    if (isLoadingSubjectMore || !hasMoreSubjectData || currentSubjectId == null) {
      return;
    }
    currentSubjectPage++;
    await fetchSubjectData(currentSubjectId!, isLoadMore: true);
  }

  Future<void> refreshSubjectData() async {
    if (currentSubjectId == null) return;
    currentSubjectPage = 1;
    hasMoreSubjectData = true;
    await fetchSubjectData(currentSubjectId!);
  }

  void clearSubjectData() {
    subjectDatas.clear();
    currentSubjectId = null;
    currentSubjectPage = 1;
    hasMoreSubjectData = true;
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