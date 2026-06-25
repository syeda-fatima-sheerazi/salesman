import 'package:flutter/material.dart';
import 'package:practices/core/screens/profile/widgets/edit_profile_widget.dart';
import 'package:practices/core/screens/profile/widgets/manage_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sales Man",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: Colors.white),
          ),
        ),
        actions: [
          Icon(Icons.notifications, size: 30),
          SizedBox(width: 10),
          Icon(Icons.menu, size: 30),
        ],
        actionsPadding: EdgeInsets.only(right: 20),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: BoxBorder.all(color: Colors.black, width: 3),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                "Ali Ahmed",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "0312-0002791",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              EditProfileWidget(),
              SizedBox(height: 20),
              ManageWidget(
                icon: Icon(Icons.person, color: Colors.white),
                text: "My Account",
              ),
              SizedBox(height: 3),
              ManageWidget(
                icon: Icon(Icons.notifications, color: Colors.white),
                text: "Notification",
              ),
              SizedBox(height: 3),

              ManageWidget(
                icon: Icon(Icons.phone, color: Colors.white),
                text: "Change Phone Number",
              ),
              SizedBox(height: 3),

              ManageWidget(
                icon: Icon(Icons.language, color: Colors.white),
                text: "Language",
              ),
              SizedBox(height: 3),

              ManageWidget(
                icon: Icon(Icons.lock, color: Colors.white),
                text: "Password & Security",
              ),
              SizedBox(height: 3),

              ManageWidget(
                icon: Icon(Icons.help, color: Colors.white),
                text: "Help & Support",
              ),
              SizedBox(height: 3),

              ManageWidget(
                icon: Icon(Icons.question_answer, color: Colors.white),
                text: "About Us",
              ),
              SizedBox(height: 20),

              Container(
                height: 40,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Logout",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
