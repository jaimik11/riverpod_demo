import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di/app_providers.dart';

Future<void> main() async{
   ProviderContainer().read(mainInitProvider);
}



