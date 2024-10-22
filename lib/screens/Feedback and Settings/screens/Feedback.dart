import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/feedback.dart';
import 'package:test/widgets/backButton.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = '/feedback-screen';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double rating = 0.0; // Rating variable
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            const Image(
              image: AssetImage('assets/images/eclipse.png'),
            ),
            // Title
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.095,
                left: deviceSize.width * 0.2,
              ),
              child: Text(
                'Feedback',
                style: TextStyle(
                  color: const Color(0xff200E32).withOpacity(0.8),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ),

            // Back Button
            backButton(context),
            Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.2,
                //left: deviceSize.width * 0.05,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: <Widget>[
                const Text(
                  'Your feedback is valuable in enhancing the user experience.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: deviceSize.height * 0.06,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Please enter your feedback',
                      hintStyle: TextStyle(
                        fontSize: deviceSize.width * 0.035,
                        color: Colors.black26,
                      ),
                    ),
                    maxLines: 5,
                    controller: _reasonController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: deviceSize.height * 0.06,
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.rate_review_sharp,
                          color: Colors.black87),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Rate our app",
                        style: TextStyle(
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 25,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (newRating) {
                          setState(() {
                            rating = newRating;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: EdgeInsets.only(
                          top: deviceSize.height * 0.06,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            final feedbackServices = FeedbackServices();

                            feedbackServices.addFeedback(
                              context: context,
                              userId: user.userId!,
                              feedback: _reasonController.text,
                              rating: rating,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFFB9A0E6),
                                  Color(0xFF8587DC),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: deviceSize.width * 0.85,
                              height: deviceSize.height * 0.065,
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                  'Send Feedback',
                                  style: TextStyle(
                                    fontSize: deviceSize.width * 0.048,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
              ]),
            ),
            // Feedback Text
          ],
        ),
      ),
    );
  }
}
