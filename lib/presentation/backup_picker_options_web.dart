import 'package:file_picker_web/file_picker_web.dart';

// Keep browser file reads lazy so validation can enforce the size limit.
// ignore: deprecated_member_use
const backupWebOptions = FilePickerWebOptions(withData: false);
