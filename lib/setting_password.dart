import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'hive.dart';

class SettingPasswordForm extends StatefulWidget {
  const SettingPasswordForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<SettingPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var settingBox = Hive.box<String>(hiveSettingBox);
    var secret = settingBox.get('secret');
    var password = TextEditingController(text: '');
    var newPassword = TextEditingController(text: '');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('加密密码'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "原密码"),
                validator: (value) {
                  if (secret != null && secret.isNotEmpty) {
                    if (value == null || value.isEmpty) {
                      return '请输入原密码';
                    } else if (value != secret) {
                      return '原密码错误';
                    }
                  }
                  return null;
                },
                controller: password,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "密码"),
                controller: newPassword,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    hiveSetStringSecret(newPassword.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('保存成功')),
                    );
                  },
                  child: const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
