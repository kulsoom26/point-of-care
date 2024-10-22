import 'package:flutter/material.dart';
import 'package:test/screens/Diagnosis/screens/uploadScreen.dart';
import 'package:test/widgets/myButton.dart';

class SymptomsForm extends StatefulWidget {
  final user;
  final dis;
  SymptomsForm(this.user, this.dis);

  @override
  _SymptomsFormState createState() => _SymptomsFormState();
}

class _SymptomsFormState extends State<SymptomsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, int?> selectedOptions = {};
  Map<String, String> answers = {};

  List<Map<String, dynamic>> symptomData = [];

  List<Map<String, dynamic>> chestData = [
    {
      'question':
          '1) Which of the following best describes your chest discomfort or pain?',
      'options': [
        'Sharp and stabbing',
        'Dull and aching',
        'Pressure or tightness',
        'None of the above'
      ]
    },
    {
      'question': '2) How long have you been experiencing chest symptoms?',
      'options': ['Less than a day', 'A few days', 'A few weeks', 'None']
    },
    {
      'question':
          '3) Are your chest symptoms associated with shortness of breath?',
      'options': [
        'Yes, I have shortness of breath',
        'Sometimes I have shortness of breath',
        'No, I do not have shortness of breath',
        'Not sure'
      ]
    },
    {
      'question':
          '4) Are there specific activities or times of the day that seem to trigger your chest symptoms?',
      'options': [
        'Yes, certain activities or times',
        'No, they occur randomly',
        'Not applicable',
        'Not sure'
      ]
    },
    {
      'question':
          '5) Do you experience chest pain or discomfort during physical exertion or exercise?',
      'options': [
        'Yes, during physical exertion or exercise',
        'No, not related to physical activity',
        'I do not engage in physical activity',
        'Not sure'
      ]
    },
  ];

  List<Map<String, dynamic>> breastTumorSymptoms = [
    {
      'question':
          '1) Have you noticed any changes in the size or shape of your breast?',
      'options': [
        'Yes, an increase in size',
        'Yes, a decrease in size',
        'No changes',
        'Not sure'
      ]
    },
    {
      'question': '2) Do you experience pain or tenderness in your breast?',
      'options': [
        'Yes, frequent pain',
        'Yes, occasional pain',
        'No pain or tenderness',
        'Not sure'
      ]
    },
    {
      'question':
          '3) Have you observed any changes in the color or texture of your breast skin?',
      'options': [
        'Yes, changes in color',
        'Yes, changes in texture',
        'No changes',
        'Not sure'
      ]
    },
    {
      'question':
          '4) Do you notice any lumps or masses in your breast or underarm area?',
      'options': [
        'Yes, one or more lumps',
        'No lumps or masses',
        'Not sure',
        'I do not check'
      ]
    },
    {
      'question':
          '5) Have you experienced any nipple discharge or changes in nipple appearance?',
      'options': [
        'Yes, nipple discharge',
        'Yes, changes in nipple appearance',
        'No changes',
        'Not sure'
      ]
    },
  ];

  List<Map<String, dynamic>> kidneyIssuesSymptoms = [
    {
      'question':
          '1) Have you experienced persistent pain or discomfort in your lower back or sides?',
      'options': [
        'Yes, frequently',
        'Yes, occasionally',
        'No pain or discomfort',
        'Not sure'
      ]
    },
    {
      'question':
          '2) Do you notice any changes in the color or odor of your urine?',
      'options': [
        'Yes, changes in color',
        'Yes, changes in odor',
        'No changes',
        'Not sure'
      ]
    },
    {
      'question': '3) Have you ever passed blood in your urine?',
      'options': [
        'Yes, multiple times',
        'Yes, once',
        'No blood in urine',
        'Not sure'
      ]
    },
    {
      'question':
          '4) Do you experience frequent urination or a sense of urgency to urinate?',
      'options': [
        'Yes, frequently',
        'Yes, occasionally',
        'No issues with urination',
        'Not sure'
      ]
    },
    {
      'question': '5) Have you noticed any swelling in your ankles or legs?',
      'options': [
        'Yes, swelling present',
        'No swelling',
        'Not sure',
        'I haven\'t checked'
      ]
    },
  ];

  @override
  void initState() {
    symptomData = widget.dis == 'chest'
        ? chestData
        : widget.dis == 'breast'
            ? breastTumorSymptoms
            : widget.dis == 'kidney'
                ? kidneyIssuesSymptoms
                : [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(selectedOptions);
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Text(
                'Symptoms',
                style: TextStyle(
                  fontSize: deviceSize.width * 0.07,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              // SubHeading
              Text(
                'Please enter patient\'s symptoms',
                style: TextStyle(
                  fontSize: deviceSize.width * 0.032,
                  color: Colors.black38,
                  fontFamily: 'League Spartan',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: deviceSize.height / 1.6,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildSymptomQuestions(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              myButton1(() {
                if (selectedOptions['ans1'] != null &&
                    selectedOptions['ans2'] != null &&
                    selectedOptions['ans3'] != null &&
                    selectedOptions['ans4'] != null &&
                    selectedOptions['ans5'] != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          UploadScreen(widget.user, widget.dis),
                    ),
                  );
                }
              }, "Submit"),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSymptomQuestions() {
    List<Widget> symptomWidgets = [];

    for (int i = 0; i < symptomData.length; i++) {
      String question = symptomData[i]['question'];
      List<String> options = List<String>.from(symptomData[i]['options']);

      symptomWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$question',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildRadioListTiles(options, 'ans${i + 1}'),
            SizedBox(height: 8),
          ],
        ),
      );
    }

    return symptomWidgets;
  }

  Widget _buildRadioListTiles(List<String> options, String ansKey) {
    return Column(
      children: options.asMap().entries.map((entry) {
        int index = entry.key;
        String option = entry.value;

        return RadioListTile(
          title: Text(
            '$option',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
          value: index + 1,
          groupValue: selectedOptions[ansKey],
          onChanged: (value) {
            setState(() {
              selectedOptions[ansKey] = value;
              answers[ansKey] = option;
            });
          },
        );
      }).toList(),
    );
  }
}
