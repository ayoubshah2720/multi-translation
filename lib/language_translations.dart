import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator/translator.dart';

class LanguageTranslations extends StatefulWidget {
  const LanguageTranslations({super.key});

  @override
  State<LanguageTranslations> createState() => _LanguageTranslationsState();
}

class _LanguageTranslationsState extends State<LanguageTranslations> {
  RewardedAd? rewardedAd;
  int rewardedScore = 0;
  int rewardedClickCounter = 0;

  // List<String> languages = ['Urdu', 'Hindi', 'Arabic', 'English', 'French', 'Russian', 'Spanish', 'German', 'Portuguese', 'Chinese'];
  // List<String> languages = ['Urdu', 'Hindi', 'Arabic', 'English'];
  List<DropdownMenuItem<String>> dropdownItems =
      ['Urdu', 'Hindi', 'Arabic', 'English', 'French', 'Russian', 'Spanish', 'German', 'Portuguese', 'Chinese'].map((String language) {
    return DropdownMenuItem<String>(
      value: language,
      child: Text(language),
    );
  }).toList();
  var originLanguage = 'English';
  var destinationLanguage = 'Urdu';
  var output = '';
  TextEditingController languageController = TextEditingController();

  void _translate(String src, String dest, String input) async {
    GoogleTranslator translator = new GoogleTranslator();
    var translation = await translator.translate(input, from: src, to: dest);
    setState(() {
      output = translation.text.toString();
    });
    if (src == '--' || dest == '--') {
      setState(() {
        output = 'Failed to translate';
      });
    }
  }

  String getLanguageCode(String language) {
    if (language == 'English') {
      return 'en';
    } else if (language == 'Hindi') {
      return 'hi';
    } else if (language == 'Arabic') {
      return 'ar';
    } else if (language == 'Urdu') {
      return 'ur';
    } else if (language == 'French') {
      return 'fr';
    } else if (language == 'Russian') {
      return 'ru';
    } else if (language == 'Spanish') {
      return 'es';
    } else if (language == 'German') {
      return 'de';
    } else if (language == 'Portuguese') {
      return 'pt';
    } else if (language == 'Chinese') {
      return 'zh-cn';
    } else {
      return '--';
    }
  }

  bool isBannerLoaded = false;
  late BannerAd bannerAd;

  void initializedBannerAds() async {
    bannerAd = BannerAd(
        size: AdSize.banner,
        // adUnitId: 'ca-app-pub-9975053747984595/5832199928',
        // Test ID banner ads.
        adUnitId: 'ca-app-pub-3940256099942544/9214589741',
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isBannerLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            isBannerLoaded = false;
          });
          print(error);
        }),
        request: AdRequest());

    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    loadRewardedAds();
    initializedBannerAds();
  }

  loadRewardedAds() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-9975053747984595/4009435064',
        // this is test rewarded ad id
        // adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          setState(() {
            rewardedAd = ad;
          });
        }, onAdFailedToLoad: (error) {
          setState(() {
            rewardedAd = null;
          });
        }));
  }

  void showAds() {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        setState(() {
          rewardedAd!.dispose();
          loadRewardedAds();
        });
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        setState(() {
          rewardedAd!.dispose();
          loadRewardedAds();
        });
      });

      rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          rewardedScore++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isBannerLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd))
          : const SizedBox(),
      backgroundColor: Color(0xff7c5a26),
      appBar: AppBar(
        title: const Text(
          'Language Translator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff7c5a26),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set color to white for all AppBar icons
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  focusColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  hint: (Text(
                    originLanguage,
                    style: const TextStyle(color: Colors.white),
                  )),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: dropdownItems,
                  onChanged: (value) {
                    setState(() {
                      originLanguage = value!.toString();
                    });
                  },
                ),
                const SizedBox(
                  width: 40,
                ),
                const Icon(
                  Icons.arrow_right_alt_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(
                  width: 40,
                ),
                DropdownButton(
                  focusColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  hint: (Text(
                    destinationLanguage,
                    style: const TextStyle(color: Colors.white),
                  )),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: dropdownItems,
                  onChanged: (value) {
                    setState(() {
                      destinationLanguage = value!.toString();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 300,
                child: TextFormField(
                  cursorColor: Colors.white,
                  autofocus: false,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Please Enter your text ...',
                    labelStyle: TextStyle(fontSize: 15, color: Colors.white),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    )),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                  controller: languageController,
                  validator: (value) {
                    if (value == null && value!.isEmpty) {
                      return 'Please Enter Text to Translate.';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffd8993a)),
                  onPressed: () {
                    _translate(
                        getLanguageCode(originLanguage),
                        getLanguageCode(destinationLanguage),
                        languageController.text.toString());
                    rewardedClickCounter++;
                    if (rewardedClickCounter % 3 == 0) {
                      showAds();
                    }
                  },
                  child: const Text(
                    "Translate",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "\n$output",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
