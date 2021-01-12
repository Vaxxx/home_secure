import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:home_secure/model/authentication.dart';
import 'package:home_secure/model/firestore-services.dart';
import 'package:home_secure/model/model-plan.dart';
import 'package:home_secure/pages/dashboard.dart';
import 'package:home_secure/pages/plan.dart';
import 'package:home_secure/utilities/constants.dart';
import 'package:http/http.dart' as http;

class Subscribe extends StatefulWidget {
  final String email;

  const Subscribe({Key key, this.email}) : super(key: key);
  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  String backendUrl = 'https://paystack.com/pay/tr07ny2l9i';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
  String paystackPublicKey = 'pk_live_e7175476f997f15d454381f38450f008726c0438';
  String appName = 'Home Secure';

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  var _border = new Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );
  int _radioValue = 0;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  List<Plan> _plan = Plan.getPlan();
  List<DropdownMenuItem<Plan>> _dropdownMenuItems;
  Plan _selectedPlan;

  String currentEmail = '';

  @override
  void initState() {
    currentEmail = widget.email;
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
    _dropdownMenuItems = buildDropdownMenuItems(_plan);
    _selectedPlan = _dropdownMenuItems[0].value;
    //  getCurrentEmail();
    super.initState();
  }

  List<DropdownMenuItem<Plan>> buildDropdownMenuItems(List plans) {
    List<DropdownMenuItem<Plan>> items = List();
    for (Plan plan in plans) {
      items.add(DropdownMenuItem(value: plan, child: Text(plan.value)));
    }
    return items;
  }

  onChangeDropdownItem(Plan selectedPlan) {
    setState(() {
      _selectedPlan = selectedPlan;
    });
  }

  // getCurrentEmail() {
  //   setState(() {
  //     if (HomePage.HOME_EMAIL != null) {
  //       currentEmail = HomePage.HOME_EMAIL;
  //     } else if (Authentication.MAIL != null) {
  //       print('The authentication mail is ${Authentication.MAIL}');
  //       currentEmail = Authentication.MAIL;
  //     } else {
  //       currentEmail = LoginPage.EMAIL;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(appName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(email: currentEmail),
            ));
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: new SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Image.asset('assets/images/logo.png')),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'Choose a Subscription Plan',
                  style: captionFont,
                ),
                SizedBox(
                  height: 15.0,
                ),
                DropdownButton(
                  value: _selectedPlan,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  child: _getPlatformButton(
                    'Make Payment',
                    () => _handleCheckout(context),
                  ),
                ),
                // RaisedButton(
                //   child: Text('payment'),
                //   onPressed: () {
                //     print('the plan is: ${_selectedPlan.amount}');
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChanged(int value) =>
      setState(() => _radioValue = value);

  _handleCheckout(BuildContext context) async {
    print("The Email is ${Authentication.MAIL}");
    _method = CheckoutMethod.card;
    setState(() => _inProgress = true);
    _formKey.currentState.save();
    Charge charge = Charge()
      ..amount = int.parse(_selectedPlan.amount) // In base currency
      ..email = currentEmail
      ..card = _getCardFromUI();

    if (!_isLocal) {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

    try {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        logo: MyLogo(),
      );
      print('This is the final response..............ooooo');
      saveSubscribedState(currentEmail, _selectedPlan.value);
      print('Response = $response');
      setState(() {
        _inProgress = false;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => Subscribe(email: currentEmail),
        ));
      });

      _updateStatus(response.reference, '$response');
    } catch (e) {
      setState(() => _inProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  _startAfreshCharge() async {
    _formKey.currentState.save();

    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);

    if (_isLocal) {
      // Set transaction params directly in app (note that these params
      // are only used if an access_code is not set. In debug mode,
      // setting them after setting an access code would throw an exception

      charge
        ..amount = int.parse(_selectedPlan.amount) // In base currency
        ..email = currentEmail
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Flutter SDK');
      _chargeCard(charge);
    } else {
      // Perform transaction/initialize on Paystack server to get an access code
      // documentation: https://developers.paystack.co/reference#initialize-a-transaction
      charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    }
  }

  _chargeCard(Charge charge) async {
    final response = await PaystackPlugin.chargeCard(context, charge: charge);

    final reference = response.reference;

    // Checking if the transaction is successful
    if (response.status) {
      _verifyOnServer(reference);
      return;
    }

    // The transaction failed. Checking if we should verify the transaction
    if (response.verify) {
      _verifyOnServer(reference);
    } else {
      setState(() => _inProgress = false);
      _updateStatus(reference, response.message);
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = new CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeBlue,
        child: new Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = new RaisedButton(
        onPressed: function,
        color: Colors.blueAccent,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        child: new Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
    return widget;
  }

  Future<String> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String accessCode;
    try {
      print("Access code url = $url");
      http.Response response = await http.get(url);
      accessCode = response.body;
      print('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  void _verifyOnServer(String reference) async {
    _updateStatus(reference, 'Verifying...');
    String url = '$backendUrl/verify/$reference';
    try {
      http.Response response = await http.get(url);
      var body = response.body;
      _updateStatus(reference, body);
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
    setState(() => _inProgress = false);
  }

  _updateStatus(String reference, String message) {
    print('Reference: $reference \n\ Response: $message');
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  bool get _isLocal => _radioValue == 0;

  void saveSubscribedState(String currentEmail, String value) async {
    ModelPlan plan = new ModelPlan(email: currentEmail, plan: value);
    await FirestoreService().addSubscription(plan);
  }
}

var banks = ['Selectable', 'Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        "CO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

const Color green = const Color(0xFF3db76d);
const Color lightBlue = const Color(0xFF34a5db);
const Color navyBlue = const Color(0xFF031b33);
