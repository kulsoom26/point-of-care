import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/auth.dart';
import 'package:test/screens/Result%20and%20Reporting/screens/reportScreen.dart';
import 'package:test/widgets/backButton.dart';

import '../../../providers/reports.dart';

class ReportList extends StatefulWidget {
  static const routeName = 'report-list';

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  bool flag = true;

  @override
  void initState() {
    Provider.of<Reports>(context, listen: false).fetchReports().then((_) {
      setState(() {
        flag = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    final report = Provider.of<Reports>(context, listen: false);
    var reportList = user.role == 'Radiologist'
        ? report.reports
            .where((element) => element['Verification'] == 'Pending')
            .toList()
        : report.reports
            .where((element) => element['id'] == user.userId)
            .toList();
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          //header
          const Image(
            image: AssetImage('assets/images/topWaves1.png'),
          ),

          Container(
            margin: const EdgeInsets.only(left: 100, top: 73),
            width: deviceSize.width * 0.55,
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  labelStyle: TextStyle(
                    fontFamily: 'League Spartan',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                  prefixIcon: Icon(Icons.search_outlined),
                  prefixIconColor: Colors.black,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'League Spartan',
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 50, top: 160),
            child: const Text(
              'My Reports',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            // ignore: sized_box_for_whitespace
            child: Container(
              height: deviceSize.height * 0.7,
              width: deviceSize.width,
              margin: const EdgeInsets.only(top: 200),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: flag
                          ? Image.asset(
                              "assets/images/heart-beat.gif",
                              height: 120,
                              width: 120,
                            )
                          : reportList.isEmpty
                              ? const Text("No reports to show!")
                              : ListView.builder(
                                  itemCount: reportList.length,
                                  itemBuilder: (context, position) {
                                    var time = reportList[position]['time']
                                        .split(' ')[0];
                                    return GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportScreen(
                                                      reportList[position]))),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: deviceSize.width * 0.8,
                                          child: Card(
                                              elevation: 18,
                                              child: ListTile(
                                                title: Text(
                                                  reportList[position]['name'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xFF200e32),
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                trailing: Text(
                                                    reportList[position]
                                                        ['Verification']),
                                                subtitle: Text(
                                                  time,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                leading: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          Color(0xFFB9A0E6),
                                                          Color(0xFF8587DC),
                                                        ]),
                                                  ),
                                                  child: Container(
                                                    width: 55,
                                                    height: 55,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: const Center(
                                                      child: Text(
                                                        "Report",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backButton(context)
        ],
      ),
    );
  }
}
