import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Custom_widget/button.dart';
import '../Custom_widget/textfield.dart';
import '../services/auth_services.dart';
import 'home_screen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Controllers for sign-in fields
  final TextEditingController _signinInEmailControllers = TextEditingController();
  final TextEditingController _signinInpasswordControllers = TextEditingController();

  bool isSignIn = true;
  final AuthService _authService = AuthService();
  final storage = FlutterSecureStorage();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signup(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          countryCode: _countryCodeController.text,
          phoneNo: _phoneNoController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful')),
        );

        // Navigate back to the sign-in screen
        setState(() {
          isSignIn = true;
        });
      } catch (e) {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e')),
        );
      }
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.login(
          email: _signinInEmailControllers.text,
          password: _signinInpasswordControllers.text,
        );

        // Check if the response contains the token
        if (response.containsKey('record') && response['record']['authtoken'] != null) {
          final token = response['record']['authtoken'];
          final user = response['record']['firstName'];
          final user1 = response['record']['email'];
          final user2 = response['record']['profileImg'];

          // Store the token securely
          await storage.write(key: 'auth_token', value: token);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful')),
          );

          // Navigate to the home screen with user details
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                token: token,
                userName: user,
                userEmail: user1,
                userProfilePicture: user2, // Assuming the API response includes a profile_picture field
              ),
            ),
          );
        } else {
          throw Exception('Token not found in response');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/Mask Group.png",
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.2,
                    ),
                    // Toggle buttons
                    Stack(
                      children: [
                        Container(
                          height: 2,
                          width: screenWidth * 0.75,
                          color: Colors.grey,
                          margin: EdgeInsets.only(top: 26, left: 6),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignIn = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: isSignIn ? Colors.black : Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 2,
                                    width: screenWidth * 0.2,
                                    color: isSignIn
                                        ? Colors.blue
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignIn = false;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: isSignIn ? Colors.grey : Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 2,
                                    width: screenWidth * 0.55,
                                    color: isSignIn
                                        ? Colors.transparent
                                        : Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Form fields
                    if (isSignIn)
                      Column(
                        children: [
                          CustomTextField(
                            name: 'E-mail',
                            inputType: TextInputType.emailAddress,
                            hintText: 'Enter your email',
                            color: 0xffFFFFFF,
                            name1: 'Enter your email',
                            controller:  _signinInEmailControllers,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            name: 'Password',
                            inputType: TextInputType.visiblePassword,
                            hintText: 'Enter your password',
                            color: 0xffFFFFFF,
                            name1: 'Enter your password',
                            controller:_signinInpasswordControllers,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          button(
                            btnName: 'Login',
                            width: screenWidth,
                            height: screenHeight * 0.06,
                            bgColor: Colors.blue,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w300
                            ),
                            callback: _login,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Handle forgot password action
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'or sign in with',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Handle Google sign in action
                                },
                                icon: Icon(Icons.facebook),
                                color: Colors.blue,
                                iconSize: 30,
                              ),
                              Container(
                                  width: screenWidth*0.1,
                                  height: screenHeight*0.1,
                                  child: Image.asset("assets/7123025_logo_google_g_icon.png")
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle Apple sign in action
                                },
                                icon: Icon(Icons.apple),
                                color: Colors.black,
                                iconSize: 30,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey,fontSize:15,fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignIn = false;
                                  });
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(color: Colors.blue,fontSize:15,fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          CustomTextField(
                            name: 'First Name',
                            inputType: TextInputType.name,
                            hintText: 'Enter your first name',
                            color: 0xffFFFFFF,
                            name1: 'Enter your first name',
                            controller: _firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            name: 'Last Name',
                            inputType: TextInputType.name,
                            hintText: 'Enter your last name',
                            color: 0xffFFFFFF,
                            name1: 'Enter your last name',
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            name: 'Country Code',
                            inputType: TextInputType.phone,
                            hintText: 'Enter your country code',
                            color: 0xffFFFFFF,
                            name1: 'Enter your country code',
                            controller: _countryCodeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your country code';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            name: 'Phone No',
                            inputType: TextInputType.phone,
                            hintText: 'Enter your phone number',
                            color: 0xffFFFFFF,
                            name1: 'Enter your phone number',
                            controller: _phoneNoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            name: 'E-mail',
                            inputType: TextInputType.emailAddress,
                            hintText: 'Enter your email',
                            color: 0xffFFFFFF,
                            name1: 'Enter your email',
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            name: 'Password',
                            inputType: TextInputType.visiblePassword,
                            hintText: 'Enter your password',
                            color: 0xffFFFFFF,
                            name1: 'Enter your password',
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            name: 'Confirm Password',
                            inputType: TextInputType.visiblePassword,
                            hintText: 'Confirm your password',
                            color: 0xffFFFFFF,
                            name1: 'Confirm your password',
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          button(
                            btnName: 'Sign Up',
                            width: screenWidth,
                            height: screenHeight * 0.06,
                            bgColor: Colors.blue,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w300
                            ),
                            callback: _signup,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
