import 'package:get/get.dart';
import 'package:pmayard_app/models/legal/about_us_model.dart';
import 'package:pmayard_app/models/legal/privacy_policy_model.dart';
import 'package:pmayard_app/models/legal/terms_and_condition_model.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';

class LegalController extends GetxController {
  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchAboutUs();
  //   fetchTermsAndCondition();
  //   fetchPrivacyPolicy();
  // }

  /// ------------------------ About Related Work are here ------------------------

  // bool isAboutLoading = false;
  // AboutUsDataModel? aboutUs;
  //
  // Future<void> fetchAboutUs() async {
  //   try {
  //     isAboutLoading = true;
  //     update();
  //     final response = await ApiClient.getData(ApiUrls.about);
  //
  //     if (response.statusCode == 200) {
  //       final data = response.body['data'];
  //       if (data is List && data.isNotEmpty) {
  //         aboutUs = AboutUsDataModel.fromJson(data.first);
  //       }
  //     } else {
  //      // showToast(response.body?['message']);
  //     }
  //   } catch (err) {
  //    // showToast('Something went wrong $err');
  //   } finally {
  //     isAboutLoading = false;
  //     update();
  //   }
  // }
  //
  // /// ----------------------- Terms And Condition Related Work are here
  // bool isTermsLoading = false;
  // TermsAndConditionDataModel? termsAndCondition;
  //
  // Future<void> fetchTermsAndCondition() async {
  //   try {
  //     isTermsLoading = true;
  //     update();
  //
  //     final response = await ApiClient.getData(ApiUrls.terms);
  //     if (response.statusCode == 200) {
  //       final data = response.body['data'];
  //       if (data is List && data.isNotEmpty) {
  //         termsAndCondition = TermsAndConditionDataModel.fromJson(data.first);
  //       } else {
  //        // showToast(response.body?['message']);
  //       }
  //     }
  //   } catch (err) {
  //     //showToast('Something Went Wrong $err');
  //   } finally {
  //     isTermsLoading = false;
  //     update();
  //   }
  // }
  //
  // /// ----------------------------- Privacy Policy Related work are here ------------------------
  // bool isPrivacyPolicyLoading = false;
  // PrivacyPolicyDataModel? privacyPolicyDataModel;
  //
  // Future<void> fetchPrivacyPolicy() async {
  //   try {
  //     isPrivacyPolicyLoading = true;
  //     update();
  //
  //     final response = await ApiClient.getData(ApiUrls.privacy);
  //     if (response.statusCode == 200) {
  //       final data = response.body['data'];
  //       if (data is List && data.isNotEmpty) {
  //         privacyPolicyDataModel = PrivacyPolicyDataModel.fromJson(data.first);
  //       } else {
  //       //  showToast(response.body?['message']);
  //       }
  //     }
  //   } catch (err) {
  //    // showToast('Something Went Wrong $err');
  //   } finally {
  //     isPrivacyPolicyLoading = false;
  //     update();
  //   }
  // }
  RxString valueText = "".obs;
  RxBool legalControllerLoading = false.obs;

  getLegalController({required String url}) async {
    legalControllerLoading(true);
    update();
    var response = await ApiClient.getData(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      valueText.value = response.body["data"]["description"];
      legalControllerLoading(false);
      update();
    } else {
      legalControllerLoading(false);
      update();
    }
  }
}
