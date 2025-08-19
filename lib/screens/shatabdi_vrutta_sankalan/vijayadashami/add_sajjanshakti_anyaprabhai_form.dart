import 'package:flutter/material.dart';

import '../../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../models/response_model/vasti_up_data_model.dart';

class SajjanShaktiFormPage extends StatefulWidget {
  static const String routeName = '/sajjan-shakti';
  const SajjanShaktiFormPage({Key? key}) : super(key: key);

  @override
  State<SajjanShaktiFormPage> createState() => _SajjanShaktiFormPageState();
}

class _SajjanShaktiFormPageState extends State<SajjanShaktiFormPage> {
  Upnagarmandallist? vastimandallist;
  List<Upnagarmandallist> vastiList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 👇 arguments yahan pick kar lo
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Upnagarmandallist) {
      vastimandallist = args;
    }
  }

  List<Vastisarsajjanshakti> sajjanShaktiDataList = [];

  // All your variables here
  int? sajjanShaktiShreniId;
  String? sajjanShaktiShreniName;
  int? sajjanShaktiShreniEditId;
  Masterdata? sajjanShaktiShreniEditDataId;

  int? sajjanShaktiSamparkStithiId;
  String? sajjanShaktiSamparkStithiName;
  int? sajjanShaktiSamparkStithiEditId;
  Masterdata? sajjanShaktiSamparkStithiEditDataId;

  int? sajjanShaktiPrabhavKeshtraId;
  String? sajjanShaktiPrabhavKeshtraName;
  int? sajjanShaktiPrabhavKeshtraEditId;
  Masterdata? sajjanShaktiPrabhavKeshtraEditDataId;

  int? sajjanShaktiVisheshId;
  String? sajjanShaktiVisheshName;
  int? sajjanShaktiVisheshEditId;
  Masterdata? sajjanShaktiVisheshEditDataId;

  TextEditingController sajjanShaktiNameController = TextEditingController();
  TextEditingController sajjanShaktiAddressController = TextEditingController();
  TextEditingController sajjanShaktiPhoneController = TextEditingController();
  TextEditingController sajjanShaktiContactPersonNameController =
      TextEditingController();
  TextEditingController sajjanShaktiContactPersonDoorbhashController =
      TextEditingController();
  TextEditingController sajjanShaktiSansthecheNaavController =
      TextEditingController();
  TextEditingController sajjanShaktiSansthKuthalyaPadavarController =
      TextEditingController();
  TextEditingController sajjanShaktiAnyaShreniNameController =
      TextEditingController();
  TextEditingController sajjanShaktiAnyaVisheshNameController =
      TextEditingController();

  VastisarvekshanDropDownDataModel? vastisarvekshanDropDownDataModel;

  Future<void> fetchVastiSurveyDropdownData() async {
    try {
      vastisarvekshanDropDownDataModel =
          await Statics.getVastiSurveyDropDownList(
              Statics.userDetails["userID"]);
      setState(() {});
    } catch (e) {
      print('Error fetching dropdown data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVastiSurveyDropdownData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("सज्जन शक्ति जानकारी",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Upnagarmandallist>(
                    hint: const Text("Select Vasti"),
                    value: vastimandallist,
                    isExpanded: true,
                    items: vastiList.map((Upnagarmandallist item) {
                      return DropdownMenuItem<Upnagarmandallist>(
                        value: item,
                        child: Text(item.geoUnitName ?? ""),
                      );
                    }).toList(),
                    onChanged: (Upnagarmandallist? newValue) {
                      setState(() {
                        vastimandallist = newValue;
                      });
                    },
                  ),
                ),
              ),
              textControllerField2(
                name: Statics.getLabel('Name'),
                controller: sajjanShaktiNameController,
                fieldHeight: 45,
              ),
              textControllerField2(
                name: Statics.getLabel('Address'),
                controller: sajjanShaktiAddressController,
                maxLines: 4,
              ),
              textControllerField2(
                name: Statics.getLabel('doorBhash'),
                controller: sajjanShaktiPhoneController,
                keyboardType: TextInputType.number,
                maxInput: 10,
              ),
              if (vastisarvekshanDropDownDataModel != null)
                vastisarvekshanDropdown2(
                  question: Statics.getLabel('Category'),
                  dataModel: vastisarvekshanDropDownDataModel!,
                  filterTypeName: "सज्जन शक्ति श्रेणी",
                  hintText: Statics.getLabel('Category'),
                  onItemSelected: (id, value, isOther) {
                    sajjanShaktiShreniName = value;
                    sajjanShaktiShreniId = id;
                  },
                  selectedValue: sajjanShaktiShreniEditDataId,
                  onSelectionChanged: (newValue) {
                    setState(() {
                      sajjanShaktiShreniEditDataId = newValue;
                    });
                  },
                  editId: sajjanShaktiShreniEditId,
                ),
              if (sajjanShaktiShreniEditDataId?.isOther == 1)
                textControllerField2(
                  name: Statics.getLabel('OtherCategory'),
                  controller: sajjanShaktiAnyaShreniNameController,
                ),
              textControllerField2(
                name: Statics.getLabel('OrganizationName'),
                controller: sajjanShaktiSansthecheNaavController,
              ),
              textControllerField2(
                name: Statics.getLabel('sansthetKuthalaPadavar'),
                controller: sajjanShaktiSansthKuthalyaPadavarController,
              ),
              if (vastisarvekshanDropDownDataModel != null)
                vastisarvekshanDropdown2(
                  question: Statics.getLabel('samparkStithi'),
                  dataModel: vastisarvekshanDropDownDataModel!,
                  filterTypeName: "सज्जन शक्ति संपर्क स्थिति",
                  hintText: Statics.getLabel('samparkStithi'),
                  onItemSelected: (id, value, isOther) {
                    sajjanShaktiSamparkStithiName = value;
                    sajjanShaktiSamparkStithiId = id;
                  },
                  selectedValue: sajjanShaktiSamparkStithiEditDataId,
                  onSelectionChanged: (newValue) {
                    setState(() {
                      sajjanShaktiSamparkStithiEditDataId = newValue;
                    });
                  },
                  editId: sajjanShaktiSamparkStithiEditId,
                ),
              if (vastisarvekshanDropDownDataModel != null)
                vastisarvekshanDropdown2(
                  question: Statics.getLabel('special'),
                  dataModel: vastisarvekshanDropDownDataModel!,
                  filterTypeName: "सज्जन शक्ति विशेष",
                  hintText: Statics.getLabel('special'),
                  onItemSelected: (id, value, isOther) {
                    sajjanShaktiVisheshName = value;
                    sajjanShaktiVisheshId = id;
                  },
                  selectedValue: sajjanShaktiVisheshEditDataId,
                  onSelectionChanged: (newValue) {
                    setState(() {
                      sajjanShaktiVisheshEditDataId = newValue;
                    });
                  },
                  editId: sajjanShaktiVisheshEditId,
                ),
              if (sajjanShaktiVisheshEditDataId?.isOther == 1)
                textControllerField2(
                  name: Statics.getLabel('otherSpecial'),
                  controller: sajjanShaktiAnyaVisheshNameController,
                ),
              vastisarvekshanDropdown2(
                question: Statics.getLabel('prabhavKshetra'),
                dataModel: vastisarvekshanDropDownDataModel!,
                filterTypeName: "सज्जन शक्ति प्रभाव क्षेत्र",
                hintText: Statics.getLabel('prabhavKshetra'),
                onItemSelected: (id, value, isOther) {
                  sajjanShaktiPrabhavKeshtraName = value;
                  sajjanShaktiPrabhavKeshtraId = id;
                },
                selectedValue: sajjanShaktiPrabhavKeshtraEditDataId,
                onSelectionChanged: (newValue) {
                  setState(() {
                    sajjanShaktiPrabhavKeshtraEditDataId = newValue;
                  });
                },
                editId: sajjanShaktiPrabhavKeshtraEditId,
              ),
              textControllerField2(
                name: Statics.getLabel('samparkSootraNaav'),
                controller: sajjanShaktiContactPersonNameController,
              ),
              textControllerField2(
                name: Statics.getLabel('samparakSootraDoorbhash'),
                controller: sajjanShaktiContactPersonDoorbhashController,
                keyboardType: TextInputType.number,
                maxInput: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------- COMMON FIELD WIDGETS ----------------
  Widget textControllerField2({
    required String name,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxInput,
    double fieldHeight = 48, // 👈 sirf textfield ke liye height
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120, // Label width fixed
            child: Text(
              "$name",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            ":",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxInput,
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: (fieldHeight - 20) / 2,
                  // 👆 fieldHeight ke hisaab se adjust hoga
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Colors.purpleAccent, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vastisarvekshanDropdown2({
    required VastisarvekshanDropDownDataModel dataModel,
    required String filterTypeName,
    required String hintText,
    required Function(int?, String?, int?) onItemSelected,
    String? question,
    int? editId,
    Masterdata? selectedValue,
    Function(Masterdata?)? onSelectionChanged,
  }) {
    List<Masterdata> filteredList = dataModel.masterdata!
        .where((item) => item.typename == filterTypeName)
        .toList();

    Masterdata? selectedItem = selectedValue;
    if (selectedItem == null && editId != null) {
      try {
        selectedItem = filteredList.firstWhere((item) => item.id == editId);
        onItemSelected(
            selectedItem.id, selectedItem.value, selectedItem.isOther);
        onSelectionChanged?.call(selectedItem);
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (question != null)
            SizedBox(
              width: 120, // 👈 label ka fixed width (adjustable)
              child: Text(
                "$question",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          if (question != null)
            Text(
              ":",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          if (question != null) const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Masterdata>(
                  hint: Text(
                    hintText,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  value: selectedItem,
                  isExpanded: true,
                  items: filteredList.map((Masterdata item) {
                    return DropdownMenuItem<Masterdata>(
                      value: item,
                      child: Text(
                        item.value ?? "",
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (Masterdata? newValue) {
                    if (newValue != null) {
                      onItemSelected(
                          newValue.id, newValue.value, newValue.isOther);
                      onSelectionChanged?.call(newValue);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
