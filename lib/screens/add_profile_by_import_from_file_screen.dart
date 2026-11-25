// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/text_field.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class AddProfileByImportFromFileScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "AddProfileByImportFromFileScreen");
  }

  const AddProfileByImportFromFileScreen({super.key});

  @override
  State<AddProfileByImportFromFileScreen> createState() =>
      _AddProfileByImportFromFileScreenState();
}

class _AddProfileByImportFromFileScreenState
    extends LasyRenderingState<AddProfileByImportFromFileScreen> {
  String _filePath = "";

  final _textControllerRemark = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textControllerRemark.dispose();
    super.dispose();
  }

  Future<void> onAdd(BuildContext context) async {
    final tcontext = Translations.of(context);
    if (_filePath.trim().isEmpty) {
      await onPressChooseFile();
      if (_filePath.trim().isEmpty) {
        return;
      }
    }

    String text = _textControllerRemark.text.trim();
    if (text.isEmpty && _filePath.isNotEmpty) {
      text = path.basenameWithoutExtension(_filePath);
    }

    setState(() {
      _loading = true;
    });
    final error = await ProfileManager.addLocal(_filePath, remark: text);

    if (!mounted) {
      return;
    }
    _loading = false;
    setState(() {});

    if (error == null) {
      await DialogUtils.showAlertDialog(context, tcontext.meta.addSuccess);
      if (!mounted) {
        return;
      }
      Navigator.pop(context, true);
      return;
    }
    if (!mounted) {
      return;
    }

    DialogUtils.showAlertDialog(
      context,
      error.message,
      showCopy: true,
      showFAQ: true,
      withVersion: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.meta.import,
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              tooltip: tcontext.meta.save,
              icon: const Icon(Icons.check_rounded, size: 22),
              onPressed: () async {
                await onAdd(context);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      await onPressChooseFile();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? ThemeDefine.kColorDarkInner
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _filePath.isNotEmpty
                              ? ThemeDefine.kColorBlue.withValues(alpha: 0.5)
                              : (isDark
                                  ? ThemeDefine.kColorDarkBorder
                                  : const Color(0xFFCBD5E1)),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color:
                                  ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _filePath.isNotEmpty
                                  ? Icons.description_rounded
                                  : Icons.upload_file_rounded,
                              color: ThemeDefine.kColorBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _filePath.isNotEmpty
                                      ? path.basename(_filePath)
                                      : tcontext.meta.fileChoose,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (_filePath.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    _filePath,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: ThemeDefine.kColorGrey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.folder_open_rounded,
                            size: 18,
                            color: ThemeDefine.kColorBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFieldEx(
                    controller: _textControllerRemark,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: tcontext.meta.remark,
                      hintText: tcontext.meta.required,
                      prefixIcon: const Icon(
                        Icons.edit_note_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPressChooseFile() async {
    final tcontext = Translations.of(context);
    List<String> extensions = [];
    List<String> extensionsAll = ['yaml', 'yml', 'txt', 'json', 'conf'];

    extensions = ['yaml', 'yml'];

    try {
      FilePickerResult? fresult = await FilePicker.pickFiles(
        type: Platform.isAndroid ? FileType.any : FileType.custom,
        allowedExtensions: Platform.isAndroid ? null : extensions,
      );
      if (fresult != null) {
        String ext = path
            .extension(fresult.files.first.name)
            .replaceAll('.', '')
            .toLowerCase();
        if (!extensionsAll.contains(ext)) {
          DialogUtils.showAlertDialog(
            context,
            tcontext.meta.fileTypeInvalid(p: ext),
          );
          return;
        }
        _filePath = fresult.files.first.path!;
        final baseName =
            path.basenameWithoutExtension(fresult.files.first.name);
        if (_textControllerRemark.text.isEmpty) {
          _textControllerRemark.value = _textControllerRemark.value.copyWith(
            text: baseName,
          );
        }
        setState(() {});
      }
    } catch (err) {
      if (!mounted) {
        return;
      }
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
    }
  }
}
