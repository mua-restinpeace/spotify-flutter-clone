  import 'package:supabase_flutter/supabase_flutter.dart';

String songCoverUrl(String path) {
    var url =
        Supabase.instance.client.storage.from('covers').getPublicUrl(path);

    return url;
  }

String songUrl(String path){
  var url = Supabase.instance.client.storage.from('songs').getPublicUrl(path);

  return url;
}