import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterFormPage extends StatefulWidget {
  @override
  _RegisterFormPageState createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;

  final _formKey =  GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  List<String> _countries = ['Russia', 'Ukraine', 'Germany', 'France'];
  String _selectedCountry;

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  @override

  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Register Form', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _nameFocus, _phoneFocus);
              },
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'What do people call you?',
                prefixIcon: Icon(Icons.person),
                suffixIcon: Icon(Icons.delete_outline,
                color: Colors.red,),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(color: Colors.black, width: 2.0)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0)
              ),
            ),
              validator: _validateName,
            ),
            SizedBox(height: 10,),
            TextFormField(
              focusNode: _phoneFocus,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _phoneFocus, _passFocus);
              },
              controller: _phoneController,
              decoration: InputDecoration(
              labelText: 'Phone Number *',
              hintText: 'Where can we reach you?',
              helperText: 'Phone format: (XXX)XXX-XXXX',
              prefixIcon: Icon(Icons.call),
              suffixIcon: Icon(Icons.delete_outline,
                color: Colors.red,),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0)
              ),
            ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                //FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter(RegExp(r'^[()\d -] {1,15}$'), allow: true)
              ],
              validator: (value) => _validatePhoneNumber(value)
                  ? null
                  : 'Phone Number must be entered as (###)###-####',
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter an email address',
                icon: Icon(Icons.mail)
            ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            SizedBox(height: 10,),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.map),
                labelText: 'Country?'
              ),

                items: _countries.map((country) {
                  return DropdownMenuItem(
                    child: Text(country),
                    value: country,
                  );
                }).toList(),
                onChanged: (data) {
                print(data);
                setState(() {
                  _selectedCountry = data;
                });
                },
              value: _selectedCountry,
              // validator: (val) {
              //   return val == null ? 'Please select a country' : null;
              // },
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _storyController,
              decoration: InputDecoration(
                labelText: 'Life Story',
                hintText: 'Tell us about yourself',
                helperText: 'Keep it short, this is just a demo',
                border: OutlineInputBorder()
            ),
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100)
              ],
            ),
            SizedBox(height: 10,),
            TextFormField(
              focusNode: _passFocus,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: 'Enter the password',
                suffixIcon: IconButton(
                  icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                ),
              icon: Icon(Icons.security)
            ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              obscureText: _hidePass,
              maxLength: 8,
              controller: _confirmPassController,
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                hintText: 'Confirm the password',
                icon: Icon(Icons.border_color)
              ),
              validator: _validatePassword,
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor :Colors.green,
              ),
              child: Text('Submit Form', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('Form is Valid');
      print('Name: ${_nameController.text}');
      print('Phone: ${_phoneController.text}');
      print('Email: ${_emailController.text}');
      print('Country: $_selectedCountry')
      print('Story: ${_storyController.text}');
    } else {
      print('Form is not valid! Please review and correct');
    }
  }

  String _validateName(String value) {
    final _nameExp = RegExp(r'^[A-Za-z]+$');
    if (value.isEmpty) {
      return 'Name is required.';
    } else if(!_nameExp.hasMatch(value)){
      return 'Please enter alphabetical characters';
    } else {
      return null;
    }
  }

  bool _validatePhoneNumber(String input) {
    final _phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return _phoneExp.hasMatch(input);
  }

  String _validateEmail(String value) {
    if(value.isEmpty) {
      return 'Email cannot be empty';
    } else if(!_emailController.text.contains('@')) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    if (_passController.text.length != 8) {
      return '8 character required for password';
    } else if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }
}
