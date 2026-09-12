import 'package:supabase_flutter/supabase_flutter.dart';

const String url = 'https://jhosaudpgxhdqkudsqjt.supabase.co';
const String publishableKey =
    'sb_publishable_VuKlB5c-ZvjYUN8bqA6MLw_Ea9NRbsB';

Future<void> initSupabase() async {
  await Supabase.initialize(url: url, publishableKey: publishableKey);
}
