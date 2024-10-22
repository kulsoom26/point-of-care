import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:test/constants/const.dart';
import 'package:test/widgets/backButton.dart';

class FAQScreen extends StatefulWidget {
  static const routeName = '/faq-screen';
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<String> data = [
    "Unfortunately, our system requires specific conditions for accurate results, such as proper lighting at a specific angle. This is challenging with hardcopy X-rays. However, you can capture a digital format image using your device camera or upload it directly.",
    "Inappropriate conditions may lead to inaccurate results. It's crucial to follow the guidelines for capturing the image to ensure the system's reliability.",
    "The system provides a detailed analysis with Class Activation Maps, which highlights the affected area in the X-ray image, aiding in a better understanding of the diagnosis.",
    "Yes, the limitations for capturing images apply to both chest X-rays and mammograms. It's essential to follow the recommended guidelines.",
    "Yes, you can easily book appointments with our registered doctors. The app provides a user-friendly interface for scheduling appointments. You have to provide information and desired slots for your appointment.",
    "Certainly! Our app facilitates online chatting, allowing users to interact with doctors for any queries or concerns.",
    "Yes, both doctors and patients can send diagnostic reports to radiologists for verification. This ensures an additional layer of accuracy in the diagnosis.",
    "Absolutely! We have comprehensive tutorials for radiologists, doctors, and patients, making the application user-friendly for everyone.",
    "Yes, patients can explore nearby doctors based on their location for physical meetings, providing convenience in accessing healthcare services.",
    "Unfortunately, No! but you can get all the details being it physical location or the contact number you can access that through our application",
  ];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            // Title
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.095,
                left: deviceSize.width * 0.2,
              ),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: const Color(0xff200E32).withOpacity(0.8),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),

            // Back Button
            backButton(context),

            Container(
              margin: EdgeInsets.symmetric(vertical: 150),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  FAQ(
                    question:
                        "1. Can I upload a hardcopy of my chest X-ray for diagnosis?",
                    answer: data[0],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "2. I am unable to get accurate results for mobile captures, why is that?",
                    answer: data[1],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "3. Is there anyway I can know the affected area in the chest X-rays?",
                    answer: data[2],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "4. Is the same image capture limitation applicable for breast cancer diagnosis through mammograms?",
                    answer: data[3],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "5. How can I book appointments with registered doctors through the app?",
                    answer: data[4],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "6. Is online chatting available for resolving queries with doctor?",
                    answer: data[5],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "7. How can I be sure if the generated analysis is accurate?",
                    answer: data[6],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "8. Having doubts related to the application, can I get any help?",
                    answer: data[7],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "9. I need to find nearby doctors for physical meetings?",
                    answer: data[8],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  FAQ(
                    question:
                        "10. Can I book appointments with these physical doctors?",
                    answer: data[9],
                    expandedIcon: const Icon(Icons.minimize),
                    collapsedIcon: const Icon(Icons.add),
                    showDivider: false,
                    queStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    ansStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    ansPadding: const EdgeInsets.all(20),
                    queDecoration: BoxDecoration(
                      color:
                          Colors.purple[50], // Set your background color here
                      borderRadius: BorderRadius.circular(5),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple[50],
                    ),
                  ),
                  // Add similar styling for other FAQs
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
