import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = 'OtpScreen';
  const OtpScreen({Key key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                color: AppColors.primary,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3,
                        right: MediaQuery.of(context).size.width / 3,
                        top: MediaQuery.of(context).size.width / 3,
                      ),
                      child: Image.asset('img/mobile-phone.png'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please enter your OTP code sent to your number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,

                        // color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
                // decoration: BoxDecoration(
                //   color: Theme.of(context).cardColor,
                //   // color: Colors.white,
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textFieldOTP(first: true, last: false),
                          _textFieldOTP(first: false, last: false),
                          _textFieldOTP(first: false, last: false),
                          _textFieldOTP(first: false, last: true),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Did not receive the message",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            // color: Colors.purple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Send again",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 15,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   height: 18,
              // ),
              // Text(
              //   "Resend New Code",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     // color: Colors.purple,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({bool first, last}) {
    return Container(
      height: MediaQuery.of(context).size.height / 11,
      width: MediaQuery.of(context).size.width / 6,
      // margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // color: Colors.red,
      ),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Card(
          // color: Colors.green,
          elevation: 10,

          child: TextFormField(
            strutStyle: StrutStyle.fromTextStyle(TextStyle(color: Colors.red)),
            autofocus: true,
            onChanged: (value) {
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.length == 0 && first == false) {
                FocusScope.of(context).previousFocus();
              }
            },
            showCursor: false,
            readOnly: false,

            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.number,
            // maxLength: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.green,
              hoverColor: Colors.amber,
              counter: Offstage(),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: const BorderSide(color: Colors.red, width: 2.0),
              //   borderRadius: BorderRadius.circular(25.0),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //     width: 2,
              //     // color: Colors.black12,
              //   ),
              //   // borderRadius: BorderRadius.circular(12),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //     width: 2,
              //     // color: Colors.purple,
              //   ),
              //   // borderRadius: BorderRadius.circular(12),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
