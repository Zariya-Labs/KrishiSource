import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../crop_diagnosis_controller.dart';

// Model to hold localized disease details and remedies
class _DiseaseDetail {
  final String nepaliName;
  final String englishName;
  final List<String> remedies;
  final bool isCritical;

  const _DiseaseDetail({
    required this.nepaliName,
    required this.englishName,
    required this.remedies,
    this.isCritical = true,
  });
}

class CropDiagnosisScreen extends ConsumerWidget {
  const CropDiagnosisScreen({super.key});

  // Comprehensive localized mapping for our 13 target model labels
  static const Map<String, _DiseaseDetail> _diseaseMap = {
    'Tomato - Bacterial spot': _DiseaseDetail(
      nepaliName: 'गोलभेडाको ब्याक्टेरियल स्पट रोग',
      englishName: 'Tomato Bacterial Spot',
      remedies: [
        'प्रमाणित स्वस्थ बीउ र बेर्ना मात्र प्रयोग गर्नुहोस्।',
        'खेतबारी गोडमेल गर्दा प्रयोग गरिने औजारहरू सफा र जीवाणुमुक्त राख्नुहोस्।',
        'आवश्यक परेमा तामायुक्त विषादी (Copper Fungicide) र कासुगामाइसिन (Kasugamycin) सिफारिस गरिए अनुसार छर्कनुहोस्।',
        'रोग लागेको बोटहरू तुरुन्तै उखेलेर नष्ट गर्नुहोस् ताकि अन्य बिरुवामा नसरोस्।',
      ],
    ),
    'Tomato - Early blight': _DiseaseDetail(
      nepaliName: 'गोलभेडाको अगेती डढुवा रोग',
      englishName: 'Tomato Early Blight',
      remedies: [
        'बाली चक्र (Crop Rotation) प्रणाली अपनाउनुहोस् र गोलभेडा पछि आलु वा भन्टा नलगाउनुहोस्।',
        'फेदका पुराना र रोगी पातहरू काटेर नष्ट गर्नुहोस् ताकि माटोबाट रोग फैलिन नपाओस्।',
        'म्यान्कोजेब (Mancozeb) वा प्रोपिनेब (Propineb) विषादी पानीमा मिसाएर बोटमा छर्कनुहोस्।',
        'खेतबारीमा बढी पानी जम्न नदिनुहोस् र निकासको उचित व्यवस्था गर्नुहोस्।',
      ],
    ),
    'Tomato - Late blight': _DiseaseDetail(
      nepaliName: 'गोलभेडाको पछौटे डढुवा रोग',
      englishName: 'Tomato Late Blight',
      remedies: [
        'रोगग्रस्त पात वा पूरै बिरुवाहरू तुरुन्तै संकलन गरी आगो लगाई जलाउनुहोस् वा जमिनमुनि गाड्नुहोस्।',
        'ओसिलोपन कम गर्न सिँचाइको उचित व्यवस्थापन गर्नुहोस् (सकेसम्म थोपा सिँचाइ प्रयोग गर्नुहोस्)।',
        'रोगको प्रारम्भिक अवस्थामा कपर अक्सिक्लोराइड (Copper Oxychloride) वा क्रिलोक्सिल (Metalaxyl + Mancozeb) औषधि छर्कनुहोस्।',
        'टनेल भित्र हावा आवतजावत राम्रोसँग हुने व्यवस्था मिलाउनुहोस्।',
      ],
    ),
    'Tomato - Leaf Mold': _DiseaseDetail(
      nepaliName: 'गोलभेडाको पातमा लाग्ने ढुसी रोग',
      englishName: 'Tomato Leaf Mold',
      remedies: [
        'बिरुवाहरू बिचको दूरी बढाएर हावा चल्ने ठाउँ बनाउनुहोस्।',
        'टनेलको तापक्रम र सापेक्षिक आद्रता सन्तुलनमा राख्न ढोका तथा भेन्टिलेसन खुला राख्नुहोस्।',
        'बोटको माथिल्लो भागबाट पानी छर्कनुको सट्टा फेदमा मात्र सिँचाइ गर्नुहोस्।',
        'रोग नियन्त्रणका लागि क्लोरोथालोनिल (Chlorothalonil) फंगिसाइड प्रयोग गर्न सकिन्छ।',
      ],
    ),
    'Tomato - Septoria leaf spot': _DiseaseDetail(
      nepaliName: 'गोलभेडाको पातको थोप्ले रोग',
      englishName: 'Tomato Septoria Leaf Spot',
      remedies: [
        'अघिल्लो वर्ष गोलभेडा नलगाएको नयाँ माटोमा बाली लगाउनुहोस्।',
        'फेदका संक्रमित पातहरू सुरुमै टिपेर नष्ट गर्नुहोस्।',
        'पातहरू भिजेको बेलामा गोडमेल वा बाली टिपाइ नगर्नुहोस्।',
        'रोकथामका लागि म्यान्कोजेब (Mancozeb) फंगिसाइड छर्कन सकिन्छ।',
      ],
    ),
    'Tomato - Spider mites Two-spotted spider mite': _DiseaseDetail(
      nepaliName: 'गोलभेडाको रातो माकुरो कीट',
      englishName: 'Tomato Two-Spotted Spider Mite',
      remedies: [
        'जैविक उपचारको लागि नीमको तेल (Neem Oil, ५ एमएल प्रति लिटर पानी) को घोल बनाइ छर्कनुहोस्।',
        'माकुरोको संख्या कम गर्न पातहरूमा सफा पानीको तीव्र फोहोरा दिनुहोस्।',
        'गम्भीर अवस्थामा एबामेक्टिन (Abamectin) वा अन्य उपयुक्त विषादी प्रयोग गर्नुहोस्।',
        'खेतबारी सफा राख्नुहोस् र जंगली झारहरू नियन्त्रण गर्नुहोस्।',
      ],
    ),
    'Tomato - Target Spot': _DiseaseDetail(
      nepaliName: 'गोलभेडाको टार्गेट स्पट रोग',
      englishName: 'Tomato Target Spot',
      remedies: [
        'बोटको फेदमा सोत्तर (Mulch) ओछ्याउनुहोस् जसले माटोबाट ढुसी पातमा पुग्न दिँदैन।',
        'थोपा सिँचाइ (Drip Irrigation) को प्रयोग गर्नुहोस्।',
        'एजोक्सिस्ट्रोबिन (Azoxystrobin) वा क्लोरोथालोनिल विषादी प्रयोग गर्नुहोस्।',
      ],
    ),
    'Tomato - Tomato Yellow Leaf Curl Virus': _DiseaseDetail(
      nepaliName: 'गोलभेडाको पहेंलो पाते भाइरस रोग',
      englishName: 'Tomato Yellow Leaf Curl Virus',
      remedies: [
        'यो भाइरस सेतो झिंगा (Whitefly) ले सार्ने भएकाले पहेंलो टाँसिने ट्र्याप (Yellow Sticky Trap) प्रयोग गरी कीरा नियन्त्रण गर्नुहोस्।',
        'संक्रमित बिरुवाहरू देखिने बित्तिकै उखेलेर खाडलमा पुरिदिनुहोस्।',
        'बेर्ना उत्पादन गर्दा कीरा नछिर्ने मसिनो जाली (Insect-proof net) को प्रयोग गर्नुहोस्।',
        'कीरा नियन्त्रणका लागि इमिडाक्लोप्रिड (Imidacloprid) औषधि छर्कन सकिन्छ।',
      ],
    ),
    'Tomato - Tomato mosaic virus': _DiseaseDetail(
      nepaliName: 'गोलभेडाको मोजेक भाइरस रोग',
      englishName: 'Tomato Mosaic Virus',
      remedies: [
        'बिरुवा छोएपछि वा गोडमेल गर्नुअघि हात साबुन पानीले राम्ररी धुनुहोस्।',
        'संक्रमित बोटहरू तुरुन्तै उखेलेर नष्ट गर्नुहोस् किनकि यो सजिलै सम्पर्कबाट सर्छ।',
        'सुर्ती वा सुर्तीजन्य पदार्थ सेवन गरेर गोलभेडाको बोट नछुनुहोस्।',
        'बाली काटिसकेपछि पुराना अवशेषहरू पूर्ण रूपमा जलाउनुहोस्।',
      ],
    ),
    'Tomato - healthy': _DiseaseDetail(
      nepaliName: 'गोलभेडा (स्वस्थ छ)',
      englishName: 'Tomato Healthy',
      isCritical: false,
      remedies: [
        'तपाईंको गोलभेडाको बिरुवा पूर्ण रूपमा स्वस्थ र निरोगी छ!',
        'सिफारिस अनुसार सन्तुलित मलखाद, पानी र गोडमेल नियमित राख्नुहोस्।',
        'रोग लाग्न नदिन बाली चक्र अपनाउनुहोस् र खेतबारी सफा राख्नुहोस्।',
      ],
    ),
    'Potato - Early blight': _DiseaseDetail(
      nepaliName: 'आलुको अगेती डढुवा रोग',
      englishName: 'Potato Early Blight',
      remedies: [
        'प्रमाणित र रोगमुक्त बीउ आलु मात्र रोप्नुहोस्।',
        'नाइट्रोजन र पोटास मलको सन्तुलित प्रयोग गर्नुहोस् जसले बिरुवालाई बलियो बनाउँछ।',
        'रोगी पातहरू फेला पर्ने बित्तिकै नष्ट गर्नुहोस्।',
        'डाइथेन एम-४५ (Mancozeb) फंगिसाइड पानीमा मिसाएर छर्कनुहोस्।',
      ],
    ),
    'Potato - Late blight': _DiseaseDetail(
      nepaliName: 'आलुको पछौटे डढुवा रोग',
      englishName: 'Potato Late Blight',
      remedies: [
        'रोगग्रस्त पात वा पूरै बिरुवाहरू तुरुन्तै संकलन गरी आगो लगाई जलाउनुहोस् वा जमिनमुनि गाड्नुहोस्।',
        'ओसिलोपना कम गर्न सिँचाइको उचित व्यवस्थापन गर्नुहोस् (सकेसम्म थोपा सिँचाइ प्रयोग गर्नुहोस्)।',
        'रोगको प्रारम्भिक अवस्थामा कपर अक्सिक्लोराइड (Copper Oxychloride) वा क्रिलोक्सिल (Metalaxyl + Mancozeb) औषधि छर्कनुहोस्।',
        'टनेल भित्र हावा आवतजावत राम्रोसँग हुने व्यवस्था मिलाउनुहोस्।',
      ],
    ),
    'Potato - healthy': _DiseaseDetail(
      nepaliName: 'आलु (स्वस्थ छ)',
      englishName: 'Potato Healthy',
      isCritical: false,
      remedies: [
        'तपाईंको आलुको बिरुवा पूर्ण रूपमा स्वस्थ र निरोगी छ!',
        'सिफारिस अनुसार सन्तुलित मलखाद, पानी र गोडमेल नियमित राख्नुहोस्।',
        'रोग लाग्न नदिन बाली चक्र अपनाउनुहोस् र खेतबारी सफा राख्नुहोस्।',
      ],
    ),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cropDiagnosisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'बिरुवा जाँच',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main Scrollable Area
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top visual banner explaining instructions
                _buildIntroBanner(context),
                const SizedBox(height: 16),

                // Main Image Container (Placeholder, Preview or Error/Success Details)
                _buildImageArea(context, state),
                const SizedBox(height: 16),

                // Diagnosis results details
                if (state.status == CropDiagnosisStatus.success && state.diseaseName != null)
                  _buildResultCard(context, state),
              ],
            ),
          ),

          // Loading Overlay
          if (state.status == CropDiagnosisStatus.processing)
            Container(
              color: Colors.black.withAlpha(150),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(strokeWidth: 4),
                        const SizedBox(height: 24),
                        Text(
                          'एआईले जाँच गर्दैछ, कृपया पर्खनुहोस्...',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Interactive action buttons fixed at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActionBar(context, ref, state),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withAlpha(80), width: 1.5),
      ),
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.tealAccent, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'तपाईंको आलु वा गोलभेडाको बोटको बिरामी भागको स्पष्ट फोटो खिचेर कुन रोग हो र त्यसको रोकथामका उपायहरू तुरुन्तै हेर्नुहोस्।',
              style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea(BuildContext context, CropDiagnosisState state) {
    final double areaHeight = MediaQuery.of(context).size.height * 0.35;

    // Loading model initially state
    if (state.status == CropDiagnosisStatus.uninitialized) {
      return Container(
        height: areaHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'एआई मोडेल लोड हुँदैछ...',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

    // If there is an image selected
    if (state.imagePath != null) {
      return Container(
        height: areaHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(state.imagePath!),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      );
    }

    // Default Placeholder Box
    return Container(
      height: areaHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(100),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.secondary.withAlpha(150),
          ),
          const SizedBox(height: 16),
          const Text(
            'बिरुवाको बिरामी भाग वा पातको स्पष्ट फोटो खिच्नुहोस्',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '(क्यामेरा सिधै पात माथि राख्दा राम्रो नतिजा आउँछ)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, CropDiagnosisState state) {
    // Lookup the localized details or display formatted name as fallback
    final rawName = state.diseaseName!;
    final detail = _diseaseMap[rawName] ??
        _DiseaseDetail(
          nepaliName: rawName,
          englishName: rawName,
          remedies: const ['यस रोगको बारेमा विस्तृत जानकारी उपलब्ध छैन। कृपया कृषि विज्ञसँग परामर्श गर्नुहोस्।'],
        );

    final int pct = (state.confidence! * 100).round();
    final bool isHealthy = !detail.isCritical;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Disease Recognition Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isHealthy ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isHealthy ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                      color: isHealthy ? Colors.green : Colors.orangeAccent,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isHealthy ? 'बिरुवा स्वस्थ छ' : 'पहिचान गरिएको रोग',
                      style: TextStyle(
                        fontSize: 14,
                        color: isHealthy ? Colors.greenAccent : Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  detail.nepaliName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                if (detail.englishName != detail.nepaliName) ...[
                  const SizedBox(height: 4),
                  Text(
                    '(${detail.englishName})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'पहिचान निश्चितता (Confidence): $pct%',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Local Remedies Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.healing_rounded, color: Colors.tealAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      isHealthy ? 'स्वस्थ राख्ने तरिकाहरू' : 'रोकथामका उपायहरू (Remedies)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 1),
                ...detail.remedies.map((remedy) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.tealAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              remedy,
                              style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context, WidgetRef ref, CropDiagnosisState state) {
    final bool hasResult = state.status == CropDiagnosisStatus.success;
    final bool hasError = state.status == CropDiagnosisStatus.failure;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error Display Card
            if (hasError) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withAlpha(100)),
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  state.errorMessage ?? "अज्ञात त्रुटि भयो। पुनः प्रयास गर्नुहोस्।",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Action Buttons
            if (hasResult) ...[
              // Government Help Directory Button (If disease is critical)
              ElevatedButton.icon(
                onPressed: () => _showKnowledgeCenterDirectory(context),
                icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 20),
                label: const Text(
                  'नजिकैको कृषि ज्ञान केन्द्र खोज्नुहोस्',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(cropDiagnosisProvider.notifier).reset();
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('अर्को जाँच गर्नुहोस्', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ] else if (hasError) ...[
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(cropDiagnosisProvider.notifier).reset();
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                label: const Text(
                  'पुनः प्रयास गर्नुहोस्',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ] else ...[
              // Initial Action Select Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(cropDiagnosisProvider.notifier).pickAndDiagnose(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 22),
                      label: const Text(
                        'क्यामेरा खोल्नुहोस्',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(cropDiagnosisProvider.notifier).pickAndDiagnose(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_library_rounded, size: 20),
                      label: const Text(
                        'ग्यालरीबाट छान्नुहोस्',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.teal, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Display Bottom Sheet with Agriculture Knowledge Center Directory
  void _showKnowledgeCenterDirectory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.phone_in_talk_rounded, color: Colors.tealAccent, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'कृषि ज्ञान केन्द्रहरू (नेपाल सरकार)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),
              const Text(
                'बाली वा बिरुवामा समस्या बढी भएमा वा रोग नियन्त्रण नभएमा तलका कुनै पनि केन्द्रमा सिधै फोन गरेर कृषि विज्ञसँग निःशुल्क सल्लाह लिन सक्नुहुन्छ:',
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildDirectoryItem('काठमाडौं कृषि ज्ञान केन्द्र', 'हरिहरभवन, ललितपुर', '०१-५५२११३५'),
                      _buildDirectoryItem('काभ्रे कृषि ज्ञान केन्द्र', 'धुलिखेल, काभ्रे', '०११-४९०२३२'),
                      _buildDirectoryItem('चितवन कृषि ज्ञान केन्द्र', 'भरतपुर, चितवन', '०५६-५२१२४९'),
                      _buildDirectoryItem('कास्की कृषि ज्ञान केन्द्र', 'पोखरा, कास्की', '०६१-५२०१३८'),
                      _buildDirectoryItem('झापा कृषि ज्ञान केन्द्र', 'भद्रपुर, झापा', '०२३-४५२०४२'),
                      _buildDirectoryItem('सुर्खेत कृषि ज्ञान केन्द्र', 'वीरेन्द्रनगर, सुर्खेत', '०८३-५२११५४'),
                      _buildDirectoryItem('कैलाली कृषि ज्ञान केन्द्र', 'धनगढी, कैलाली', '०९१-५२०४३६'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDirectoryItem(String title, String address, String phoneNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(address, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.phone_rounded, size: 16, color: Colors.tealAccent),
                const SizedBox(width: 4),
                Text(phoneNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
              ],
            ),
          ],
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.teal.withAlpha(40),
          child: const Icon(Icons.call_rounded, color: Colors.tealAccent),
        ),
        onTap: () {
          // Typically we would launch the dialer (e.g. url_launcher), but keeping it local as contact lookup
        },
      ),
    );
  }
}
