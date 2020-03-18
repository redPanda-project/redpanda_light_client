import 'dart:convert';

class ChannelData {
  bool group = false;
  List userdata = [];

  ChannelData();

  ChannelData.fromJson(Map<String, dynamic> json)
      : group = json['group'],
        userdata = json['userdata'];

  Map<String, dynamic> toJson() => {
        'group': group,
        'userdata': userdata,
      };

  String encodeToJson() {
    return jsonEncode(this);
  }

  static ChannelData decodeToJson(String channelDataString) {
    return ChannelData.fromJson(jsonDecode(channelDataString));
  }
}
