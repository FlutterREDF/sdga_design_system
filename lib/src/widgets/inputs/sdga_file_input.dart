import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

enum _SDGAFileInputType { single, multiple }

class SDGAFile<T> {
  const SDGAFile({
    required this.file,
    required this.filename,
    this.errorMessage,
    this.isUploading = false,
  });

  final T file;
  final String filename;
  final String? errorMessage;
  final bool isUploading;
}

/// A widget for selecting and managing files.
///
/// This widget allows the user to browse and select one or multiple files,
/// depending on the type specified.
///
/// The selected files can be accessed through the [file] or [files] property,
/// and events for removing a file or browsing for new files can be handled
/// through the [onRemoveFile] and [onBrowseFile] callbacks, respectively.
///
/// There are two types of [SDGAFileInput]:
///
/// - [SDGAFileInput.single]: Allows the user to select a single file.
/// - [SDGAFileInput.multiple]: Allows the user to select multiple files.
///
/// {@tool sample}
/// ```dart
/// SDGAFileInput.single(
///   label: Text('Select a file'),
///   helperText: Text('Allowed formats: .pdf, .doc, .docx'),
///   onBrowseFile: () {
///     // Open file picker
///   },
///   onRemoveFile: (file) {
///     // Remove the selected file
///   },
/// )
/// ```
/// {@end-tool}
class SDGAFileInput<T> extends StatelessWidget {
  /// Creates a single file input.
  ///
  /// The [SDGAFileInput] widget itself does not manage the state or perform
  /// the file picking operation. It relies on the parent widget or the containing
  /// application logic to handle the state management and file selection process.
  /// When the [onBrowseFile] callback is triggered, the parent widget should
  /// initiate the file picking process and update the [file] property accordingly.
  const SDGAFileInput.single({
    super.key,
    required this.label,
    this.helperText,
    this.browseText = "Browse Files",
    this.file,
    this.onRemoveFile,
    this.onBrowseFile,
  })  : files = null,
        icon = null,
        _type = _SDGAFileInputType.single;

  /// The [SDGAFileInput] widget itself does not manage the state or perform
  /// the file picking operation. It relies on the parent widget or the containing
  /// application logic to handle the state management and file selection process.
  /// When the [onBrowseFile] callback is triggered, the parent widget should
  /// initiate the file picking process and update the [files] property accordingly.
  const SDGAFileInput.multiple({
    super.key,
    required this.label,
    this.icon,
    this.helperText,
    this.browseText = "Browse Files",
    required this.files,
    this.onRemoveFile,
    this.onBrowseFile,
  })  : file = null,
        _type = _SDGAFileInputType.multiple;

  /// The selected file.
  final SDGAFile<T>? file;

  /// The list of selected files.
  final List<SDGAFile<T>>? files;

  /// Callback function called when a file needs to be removed.
  final void Function(SDGAFile<T> file)? onRemoveFile;

  /// Callback function called when the browse button is pressed.
  final void Function()? onBrowseFile;

  /// The label of this input.
  ///
  /// {@macro sdga.text_style}
  final Widget label;

  /// The icon to be displayed above the label.
  ///
  /// {@macro sdga.icon_style}
  final Widget? icon;

  /// Additional information or context about the input.
  ///
  /// This can be used to provide more details or explanations to the user;
  /// like allowed file formats and maximum file size.
  ///
  /// {@macro sdga.text_style}
  final Widget? helperText;

  /// The text for the browse button
  final String browseText;

  final _SDGAFileInputType _type;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    switch (_type) {
      case _SDGAFileInputType.single:
        return _buildSingle(context, colors);
      case _SDGAFileInputType.multiple:
        return _buildMultiple(colors);
    }
  }

  Widget _buildSingle(BuildContext context, SDGAColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: SDGATextStyles.textMediumRegular.copyWith(
              color: onBrowseFile != null
                  ? colors.forms.fieldTextLabel
                  : colors.globals.textDefaultDisabled),
          child: label,
        ),
        if (helperText != null) ...[
          const SizedBox(height: SDGANumbers.spacingMD),
          DefaultTextStyle(
            style: SDGATextStyles.textMediumRegular.copyWith(
                color: onBrowseFile != null
                    ? colors.texts.primaryParagraph
                    : colors.globals.textDefaultDisabled),
            child: helperText!,
          ),
        ],
        const SizedBox(height: SDGANumbers.spacingXL),
        if (file == null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SDGAButton(
              size: SDGAWidgetSize.small,
              style: Theme.of(context).brightness == Brightness.light
                  ? SDGAButtonStyle.primaryNeutral
                  : SDGAButtonStyle.secondary,
              onPressed: onBrowseFile,
              child: Text(browseText),
            ),
          )
        else
          _buildFile(colors, file!),
      ],
    );
  }

  Widget _buildMultiple(SDGAColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMultipleContainer(colors),
        if (files != null && files!.isNotEmpty) ...[
          const SizedBox(height: SDGANumbers.spacingMD),
          for (final file in files!) ...[
            const SizedBox(height: SDGANumbers.spacingMD),
            _buildFile(colors, file),
          ],
        ],
      ],
    );
  }

  Widget _buildMultipleContainer(SDGAColorScheme colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: onBrowseFile != null ? colors.backgrounds.neutral100 : null,
        border: SDGADashedBorder(
          border: BorderSide(
            width: 1.0,
            color: onBrowseFile == null
                ? colors.globals.borderDisabled
                : colors.borders.neutralPrimary,
          ),
        ),
        borderRadius:
            const BorderRadius.all(Radius.circular(SDGANumbers.radiusSmall)),
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 32.0,
          color: onBrowseFile == null
              ? colors.globals.iconDefaultDisabled
              : colors.icons.defaultColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SDGANumbers.spacing3XL),
          child: Column(
            children: [
              if (icon != null)
                icon!
              else
                const SDGAIcon(SDGAIconsStroke.fileUpload),
              const SizedBox(height: SDGANumbers.spacingXL),
              DefaultTextStyle(
                style: SDGATextStyles.textMediumRegular.copyWith(
                    color: onBrowseFile != null
                        ? colors.forms.fieldTextLabel
                        : colors.globals.textDefaultDisabled),
                child: label,
              ),
              if (helperText != null) ...[
                const SizedBox(height: SDGANumbers.spacingMD),
                DefaultTextStyle(
                  style: SDGATextStyles.textMediumRegular.copyWith(
                      color: onBrowseFile != null
                          ? colors.texts.primaryParagraph
                          : colors.globals.textDefaultDisabled),
                  child: helperText!,
                ),
              ],
              const SizedBox(height: SDGANumbers.spacingXL),
              SDGAButton(
                style: SDGAButtonStyle.secondary,
                size: SDGAWidgetSize.medium,
                onPressed: onBrowseFile,
                child: Text(browseText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFile(SDGAColorScheme colors, SDGAFile<T> file) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgrounds.neutral100,
        borderRadius: const BorderRadius.all(
          Radius.circular(SDGANumbers.radiusSmall),
        ),
        border: Border.all(
          color: file.errorMessage != null
              ? colors.borders.error
              : colors.borders.neutralPrimary,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SDGANumbers.spacingMD),
        child: Row(
          children: [
            if (file.isUploading)
              const SDGASpinner(
                size: SDGASpinnerSizes.tiny,
                style: SDGAWidgetStyle.neutral,
              )
            else if (file.errorMessage != null)
              const SDGAFeedbackIcon(
                size: SDGAWidgetSize.medium,
                type: SDGAFeedbackIconType.error,
                color: SDGAWidgetColor.error,
              )
            else if (!file.isUploading && file.errorMessage == null)
              const SDGAFeedbackIcon(
                size: SDGAWidgetSize.medium,
                type: SDGAFeedbackIconType.success,
                color: SDGAWidgetColor.success,
              ),
            const SizedBox(width: SDGANumbers.spacingMD),
            Expanded(child: Text(file.filename)),
            if (onRemoveFile != null) ...[
              const SizedBox(width: SDGANumbers.spacingMD),
              SDGAButton.close(
                size: SDGACloseButtonSize.xSmall,
                removeBackground: true,
                onPressed: () => onRemoveFile!.call(file),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
