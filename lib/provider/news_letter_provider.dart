// ignore_for_file: use_build_context_synchronously

import '../all_export.dart';

class NewsLetterProvider extends ChangeNotifier {
  final NewsLetterRepo? newsLetterRepo;
  NewsLetterProvider({required this.newsLetterRepo});

  Future<void> addToNewsLetter(BuildContext context, String email) async {
    print('bangladesh===>$email');
    ApiResponse apiResponse = await newsLetterRepo!.addToNewsLetter(email);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('successfully_subscribe', context)!, context,
          isError: false);
      notifyListeners();
    } else {
      showCustomSnackBar(
          getTranslated('mail_already_exist', context)!, context);
    }
  }
}
