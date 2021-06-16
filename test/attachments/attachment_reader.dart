import 'dart:io';

String attachment(String name) => File('test/attachments/$name').readAsStringSync();