import 'package:flutter/material.dart';
import 'conf.dart';
import 'util.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isLocalMode = true;
  final _localAddrCtl = TextEditingController();
  final _remoteAddrCtl = TextEditingController();
  final _picWidthCtl = TextEditingController();
  final _picHeightCtl = TextEditingController();

  @override
  void initState() {
    readData();
    super.initState();
  }

  void readData() async {
    LocalStorage store = await LocalStorage.getInstance();
    _localAddrCtl.text = store.getString('localAddr', LOCAL_ADDR);
    _remoteAddrCtl.text = store.getString('remoteAddr', REMOTE_ADDR);
    _picWidthCtl.text = store.getString('picWidth', PIC_WIDTH);
    _picHeightCtl.text = store.getString('picHeight', PIC_HEIGHT);

    setState(() {
      isLocalMode = store.getBool('isLocalMode', true);
    });
  }

  Future<void> saveData() async {
    LocalStorage store = await LocalStorage.getInstance();
    await store.setString('localAddr', _localAddrCtl.text);
    await store.setString('remoteAddr', _remoteAddrCtl.text);
    await store.setString('picWidth', _picWidthCtl.text);
    await store.setString('picHeight', _picHeightCtl.text);
    await store.setBool('isLocalMode', isLocalMode);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: '本地服务器地址',
                        ),
                        controller: _localAddrCtl,
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: '远程服务器地址',
                        ),
                        controller: _remoteAddrCtl,
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        children: <Widget>[
                          Text(isLocalMode ? '本地模式' : '远程模式'),
                          Switch(
                            value: isLocalMode,
                            onChanged: (bool value) {
                              setState(() {
                                isLocalMode = value;
                              });
                            },
                          ),
                          Expanded(
                            child: Container(),
                          )
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: '图像宽度',
                        ),
                        controller: _picWidthCtl,
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: '图像高度',
                        ),
                        controller: _picHeightCtl,
                      ),
                      ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                            child: Text('保存'),
                            elevation: 4.0,
                            color: theme.primaryColor,
                            onPressed: () async {
                              await saveData();
                              tip(context, '配置保存成功');
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
