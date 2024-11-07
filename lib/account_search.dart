import 'package:flutter/material.dart';

import 'account_list.dart';

class AccountSearch extends StatefulWidget {
  const AccountSearch({super.key});

  @override
  AccountSearchState createState() => AccountSearchState();
}

class AccountSearchState extends State<AccountSearch> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _buildSearchField(),
      ),
      body: Center(
        child: AccountListWidget(filter: _filter),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 4.0),
            child: Icon(Icons.search),
          ),
          hintText: '搜索',
          hintStyle: TextStyle(fontSize: 12),
        ),
        onChanged: (v) {
          setState(() {
            _filter = v;
          });
        },
      ),
    );
  }
}
