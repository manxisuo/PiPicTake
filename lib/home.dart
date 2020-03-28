import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'util.dart';
import 'conf.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class RequestParam {
  RequestParam(this.addr, this.width, this.height);
  final String addr;
  final String width;
  final String height;
}

Future<RequestParam> getRequestParam() async {
  LocalStorage store = await LocalStorage.getInstance();
  bool isLocalMode = store.getBool('isLocalMode', true);
  String addr = isLocalMode
      ? store.getString('localAddr', LOCAL_ADDR)
      : store.getString('remoteAddr', REMOTE_ADDR);
  String width = store.getString('picWidth', PIC_WIDTH);
  String height = store.getString('picHeight', PIC_HEIGHT);

  return RequestParam(addr, width, height);
}

class _HomePageState extends State<HomePage> {
  /// 照片的URL
  // String imageUrl;
  Uint8List imageData;

  /// 是否正在拍照中
  bool isTaking = false;

  @override
  void initState() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              semanticLabel: 'setting',
            ),
            onPressed: () => Navigator.pushNamed(context, '/setting'),
          )
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                Text('点击“拍照”按钮开始拍照'),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: AspectRatio(
                    aspectRatio: 1.0 / 1.0,
                    child: isTaking
                        ? Center(child: CircularProgressIndicator())
                        : GestureDetector(
                            child: imageData == null ? Image.asset('images/placeholder.jpg') : Image.memory(imageData),
                            onTap: () => Navigator.pushNamed(context, '/image', arguments: imageData),
                          ),
                  ),
                ),
                Expanded(child: Container()),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15.0),
                    RaisedButton(
                      child: Text('拍照', style: TextStyle(color: Colors.white)),
                      elevation: 4.0,
                      color: theme.primaryColor,
                      onPressed: isTaking
                          ? null
                          : () async {
                              setState(() => isTaking = true);
                              RequestParam param = await getRequestParam();
                              Map data = await jsonGet(
                                'http://${param.addr}/take_pic',
                                {
                                  'width': param.width,
                                  'height': param.height,
                                },
                              );
                              if (data['error'] == null) {
                                imageData = await getNetworkImageData(data['image_url']);
                              }
                              else {
                                tip(context, data['error']);
                              }
                              setState(() => isTaking = false);
                            },
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      icon: Icon(Icons.save),
                      tooltip: '保存照片',
                      onPressed: () async {
                        await ImageGallerySaver.saveImage(imageData);
                        tip(context, '照片保存成功');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      tooltip: '分享照片',
                      onPressed: () async {
                        Share.file('树莓派照片', '树莓派照片.jpg', imageData, 'image/jpeg',
                            text: '树莓派@${timeString()}');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
