import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/toDo.dart';

class welcomeScreen extends StatelessWidget {
  const welcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    double Esize = Height < Width ? Width * 0.085 : Height * 0.09;
    double Fsize = Height < Width ? Width * 0.05 : Width * 0.06;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/img.png'),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'write your name',
                    labelText: 'name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: Esize,
                width: Width,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      String name = nameController.text;
                      if (name.isNotEmpty) {
                        final pref = await SharedPreferences.getInstance();
                        await pref.setBool('isLoggedIn', true);
                        await pref.setString('username', name);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Todo(
                                      userName: name,
                                    )));

                        // this is for Showing scackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Name Added Successfully')));
                        nameController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Enter Your Name')));
                      }
                    },
                    child: Text(
                      'Start',
                      style: GoogleFonts.lexend(
                        fontSize: Fsize,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'If you are not Interested to customise.',
                    style: GoogleFonts.lexend(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Todo()));
                    },
                    child: Text(
                      'Skip!',
                      style: GoogleFonts.lexend(
                        color: Colors.teal,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.27,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Developed by ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    TextSpan(
                      text: '\nSHOURAV KUMAR MAHATO\n',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Flutter Developer • Cross-Platform Specialist\n',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    TextSpan(
                      text: '📧 asashish607@gmail.com',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
