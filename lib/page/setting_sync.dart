import 'package:flutter/material.dart';
import 'package:password_note/model/setting.dart';
import 'package:provider/provider.dart';

import '../provider/app_data_provider.dart';

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
    final appData = Provider.of<NoteDataModel>(context);

    var webdavConf = appData.webdavConf;

    var urlController = TextEditingController(text: webdavConf?.url ?? '');
    var userController = TextEditingController(text: webdavConf?.user ?? '');
    var pwdController = TextEditingController(text: webdavConf?.password ?? '');
    var pathController = TextEditingController(text: webdavConf?.path ?? '');
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

                    var newWebdavConf = WebdavConfig(urlController.text, userController.text,
                        pwdController.text, pathController.text);
                    appData.setWebdavConfig(newWebdavConf);

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
