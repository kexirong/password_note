import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'hive.dart';

class SettingSyncForm extends StatefulWidget {
  const SettingSyncForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<SettingSyncForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var settingBox = Hive.box<String>(hiveSettingBox);
    var webdavUrl = settingBox.get('webdav_url');
    var webdavUser = settingBox.get('webdav_user');
    var webdavPwd = settingBox.get('webdav_pwd');
    var webdavPath = settingBox.get('webdav_path');
    var urlController = TextEditingController(text: webdavUrl);
    var userController = TextEditingController(text: webdavUser);
    var pwdController = TextEditingController(text: webdavPwd);
    var pathController = TextEditingController(text: webdavPath);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('webdav'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "URL"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入URL';
                  }
                  return null;
                },
                controller: urlController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "USER"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入USER';
                  }
                  return null;
                },
                controller: userController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "PASSWORD"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入新密码';
                  }
                  return null;
                },
                controller: pwdController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "PATH"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入路径';
                  }
                  return null;
                },
                controller: pathController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    var settingBox = Hive.box<String>(hiveSettingBox);
                    settingBox.put('webdav_url', urlController.text);
                    settingBox.put('webdav_user', userController.text);
                    settingBox.put('webdav_pwd', pwdController.text);
                    settingBox.put('webdav_path', pathController.text);

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
