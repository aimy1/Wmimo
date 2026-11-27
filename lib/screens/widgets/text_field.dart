import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';

class TextFieldEx extends TextField {
  static bool _popupEdit = false;
  static final List<VoidCallback> _listeners = [];

  static bool get popupEdit => _popupEdit;
  static set popupEdit(bool value) {
    setPopupEdit(value);
  }

  static void setPopupEdit(bool value) {
    if (_popupEdit == value) return;
    _popupEdit = value;
    for (final cb in List<VoidCallback>.from(_listeners)) {
      try {
        cb();
      } catch (_) {}
    }
  }

  static void addPopupEditListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  static void removePopupEditListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Checks whether [key] is a TV remote / D-pad confirmation key.
  static bool isTvConfirmKey(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.select ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.gameButtonA ||
        key == LogicalKeyboardKey.space;
  }

  /// Maps a D-pad arrow key to its [TraversalDirection], or null if not an arrow key.
  static TraversalDirection? arrowToTraversalDirection(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowUp) {
      return TraversalDirection.up;
    } else if (key == LogicalKeyboardKey.arrowDown) {
      return TraversalDirection.down;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      return TraversalDirection.left;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      return TraversalDirection.right;
    }
    return null;
  }

  const TextFieldEx({
    super.key,
    super.controller,
    super.focusNode,
    super.undoController,
    super.decoration = const InputDecoration(),
    TextInputType? keyboardType,
    super.textInputAction,
    super.textCapitalization = TextCapitalization.none,
    super.style,
    super.strutStyle,
    super.textAlign = TextAlign.start,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly = false,
    super.showCursor,
    super.autofocus = false,
    super.statesController,
    super.obscuringCharacter = '•',
    super.obscureText = false,
    super.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    super.enableSuggestions = true,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
    super.enabled,
    super.ignorePointers,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.keyboardAppearance,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled = false,
    super.onTapOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints = const <String>[],
    super.contentInsertionConfiguration,
    super.clipBehavior = Clip.hardEdge,
    super.restorationId,
    super.stylusHandwritingEnabled = true,
    super.enableIMEPersonalizedLearning = true,
    super.canRequestFocus = true,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    this.title,
  });

  @override
  State<TextFieldEx> createState() => _TextFieldExState();
  final String? title;
}

class _TextFieldExState extends State<TextFieldEx> {
  final FocusNode _tvFocusNode = FocusNode();
  bool _isTvFocused = false;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _tvFocusNode.addListener(_onFocusChanged);
    _tvFocusNode.onKeyEvent = _handleTvKeyEvent;
    TextFieldEx.addPopupEditListener(_onPopupEditModeChanged);
  }

  void _onFocusChanged() {
    if (!mounted) return;
    final hasFocus = _tvFocusNode.hasFocus;
    if (_isTvFocused != hasFocus) {
      setState(() {
        _isTvFocused = hasFocus;
      });
    }
  }

  void _onPopupEditModeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  KeyEventResult _handleTvKeyEvent(FocusNode node, KeyEvent event) {
    if (!TextFieldEx.popupEdit) {
      return KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (TextFieldEx.isTvConfirmKey(key)) {
      if (widget.enabled != false && !widget.readOnly) {
        showTextFieldInputDialog();
      }
      return KeyEventResult.handled;
    }

    final direction = TextFieldEx.arrowToTraversalDirection(key);
    if (direction != null) {
      FocusScope.of(context).focusInDirection(direction);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    TextFieldEx.removePopupEditListener(_onPopupEditModeChanged);
    _tvFocusNode.removeListener(_onFocusChanged);
    _tvFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useTvPopup = TextFieldEx.popupEdit;
    final showFocusOutline = useTvPopup && _isTvFocused;

    final textFieldWidget = TextField(
      controller: widget.controller,
      focusNode: useTvPopup ? _tvFocusNode : widget.focusNode,
      undoController: useTvPopup ? null : widget.undoController,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: useTvPopup || widget.readOnly,
      showCursor: useTvPopup ? false : widget.showCursor,
      autofocus: useTvPopup ? false : widget.autofocus,
      statesController: widget.statesController,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onChanged: useTvPopup ? null : widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: useTvPopup ? null : widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      ignorePointers: useTvPopup ? true : widget.ignorePointers,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorOpacityAnimates: widget.cursorOpacityAnimates,
      cursorColor: widget.cursorColor,
      cursorErrorColor: widget.cursorErrorColor,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      // When TV popupEdit is enabled, only the outer InkWell handles taps so
      // touching the field never triggers two stacked dialogs.
      onTap: useTvPopup ? null : widget.onTap,
      onTapAlwaysCalled: useTvPopup ? false : widget.onTapAlwaysCalled,
      onTapOutside: widget.onTapOutside,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      canRequestFocus: useTvPopup ? true : widget.canRequestFocus,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
    );

    if (!useTvPopup) {
      return textFieldWidget;
    }

    return AnimatedContainer(
      duration: ThemeDefine.durationMicro,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showFocusOutline ? ThemeDefine.kColorBlue : Colors.transparent,
          width: showFocusOutline ? 2.0 : 0.0,
        ),
        boxShadow: showFocusOutline
            ? [
                BoxShadow(
                  color: ThemeDefine.kColorBlue.withValues(alpha: 0.25),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : const [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        canRequestFocus: false,
        onTap: (widget.enabled == false || widget.readOnly)
            ? null
            : () async {
                _tvFocusNode.requestFocus();
                await showTextFieldInputDialog();
              },
        child: textFieldWidget,
      ),
    );
  }

  Future<void> showTextFieldInputDialog() async {
    if (!context.mounted || _isDialogOpen) {
      return;
    }
    _isDialogOpen = true;
    final tcontext = Translations.of(context);
    final originalText = widget.controller?.text ?? '';

    try {
      await showDialog(
        context: context,
        barrierDismissible: true,
        routeSettings: const RouteSettings(name: "showTextFieldInputDialog"),
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: (widget.title != null && widget.title!.trim().isNotEmpty)
                ? Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: ThemeConfig.kFontSizeListItem,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
            content: SizedBox(
              width: 420,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                undoController: widget.undoController,
                decoration: widget.decoration,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                textCapitalization: widget.textCapitalization,
                style: widget.style,
                strutStyle: widget.strutStyle,
                textAlign: widget.textAlign,
                textAlignVertical: widget.textAlignVertical,
                textDirection: widget.textDirection,
                readOnly: false,
                showCursor: widget.showCursor,
                autofocus: true,
                statesController: widget.statesController,
                obscuringCharacter: widget.obscuringCharacter,
                obscureText: widget.obscureText,
                autocorrect: widget.autocorrect,
                smartDashesType: widget.smartDashesType,
                smartQuotesType: widget.smartQuotesType,
                enableSuggestions: widget.enableSuggestions,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                expands: widget.expands,
                maxLength: widget.maxLength,
                maxLengthEnforcement: widget.maxLengthEnforcement,
                onChanged: widget.onChanged,
                onEditingComplete: () {
                  FocusScope.of(
                    dialogContext,
                  ).focusInDirection(TraversalDirection.down);
                },
                onSubmitted: (val) {
                  widget.onSubmitted?.call(val);
                  if (Navigator.canPop(dialogContext)) {
                    Navigator.pop(dialogContext);
                  }
                },
                onAppPrivateCommand: widget.onAppPrivateCommand,
                inputFormatters: widget.inputFormatters,
                enabled: true,
                ignorePointers: widget.ignorePointers,
                cursorWidth: widget.cursorWidth,
                cursorHeight: widget.cursorHeight,
                cursorRadius: widget.cursorRadius,
                cursorOpacityAnimates: widget.cursorOpacityAnimates,
                cursorColor: widget.cursorColor,
                cursorErrorColor: widget.cursorErrorColor,
                selectionHeightStyle: widget.selectionHeightStyle,
                selectionWidthStyle: widget.selectionWidthStyle,
                keyboardAppearance: widget.keyboardAppearance,
                scrollPadding: widget.scrollPadding,
                dragStartBehavior: widget.dragStartBehavior,
                enableInteractiveSelection: widget.enableInteractiveSelection,
                selectionControls: widget.selectionControls,
                onTap: widget.onTap,
                onTapAlwaysCalled: widget.onTapAlwaysCalled,
                onTapOutside: widget.onTapOutside,
                mouseCursor: widget.mouseCursor,
                buildCounter: widget.buildCounter,
                scrollController: widget.scrollController,
                scrollPhysics: widget.scrollPhysics,
                autofillHints: widget.autofillHints,
                contentInsertionConfiguration:
                    widget.contentInsertionConfiguration,
                clipBehavior: widget.clipBehavior,
                restorationId: widget.restorationId,
                stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
                enableIMEPersonalizedLearning:
                    widget.enableIMEPersonalizedLearning,
                canRequestFocus: true,
                spellCheckConfiguration: widget.spellCheckConfiguration,
                magnifierConfiguration: widget.magnifierConfiguration,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (widget.controller != null &&
                      widget.controller!.text != originalText) {
                    widget.controller!.text = originalText;
                    widget.onChanged?.call(originalText);
                  }
                  Navigator.pop(dialogContext);
                },
                child: Text(tcontext.meta.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.controller != null) {
                    widget.onSubmitted?.call(widget.controller!.text);
                  }
                  Navigator.pop(dialogContext);
                },
                child: Text(tcontext.meta.ok),
              ),
            ],
          );
        },
      );
    } finally {
      _isDialogOpen = false;
    }
  }
}
