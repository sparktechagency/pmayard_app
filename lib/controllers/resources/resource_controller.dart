import 'package:get/get.dart';
import 'package:pmayard_app/models/resources/grade_model.dart';
import 'package:pmayard_app/models/resources/metarials_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';

class ResourceController extends GetxController {
  /// ================== Grade Related Work are here =-============

  bool isLoadingResource = false;
  List<GradesModel> gradeDatas = [];

  Future<void> fetchResource(String searchTerm) async {
    isLoadingResource = true;
    update();

    final response = await ApiClient.getData(ApiUrls.gradeSearch(searchTerm));

    if (response.statusCode == 200) {

      final data = response.body['data'] ?? [];

      if (data is List && data.isNotEmpty) {

        List<GradesModel> item = data
            .map((e) => GradesModel.fromJson(e))
            .toList();

        gradeDatas.addAll(item);

      }
    } else {
      showToast('Some thing error');
    }

    isLoadingResource = false;
    update();
  }

  /// ================== Subject Related Work are here =-============

  bool isLoadingSubject = false;
  List<GradesModel> subjectDatas = [];

  Future<void> fetchSubjectData(String subjectId) async {

    isLoadingSubject = true;
    update();

    final response = await ApiClient.getData(ApiUrls.subjectsSearch(subjectId));

    if (response.statusCode == 200) {

      final items = response.body['data'] ?? [];

      if (items is List && items.isNotEmpty) {

        List<GradesModel> data = items
            .map((e) => GradesModel.fromJson(e))
            .toList();
        subjectDatas.addAll(data);
      }
    }else{
      showToast('Some thing Went Wrong');
    }

    isLoadingSubject = false;
    update();
  }

  ///================ Material Via Dio ==========================

  bool isLoadingMaterial = false;
  List<MetarialsModel> metarialsModel = [];

  Future<void>fetchMetarials( String materialsID) async {
    isLoadingMaterial = true;
    update();

    final response = await ApiClient.getData(ApiUrls.materialsSearch(materialsID));

    if( response.statusCode == 200 ){
      final items = response.body['data'] ?? [];
      if( items is List && items.isNotEmpty ){
        List<MetarialsModel> data = items.map((e) => MetarialsModel.fromJson(e)).toList();
        metarialsModel.addAll(data);
      }
    }else{
      showToast('Someting went wrong');
    }
  }
}
