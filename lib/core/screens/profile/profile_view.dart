import 'package:flutter/material.dart';

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

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 18,
            child: Icon(Icons.check, color: Colors.white),
          ),
          SizedBox(width: 10),
          Text(
            "Sales Maneger",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ManageWidget extends StatelessWidget {
  const ManageWidget({
    super.key,
    required this.icon,
    required this.text,
    this.button,
  });
  final Icon icon;
  final String text;
  final TextButton? button;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              SizedBox(width: 10),
              Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),

          Icon(Icons.arrow_right_sharp, color: Colors.white),
        ],
      ),
    );
  }
}
