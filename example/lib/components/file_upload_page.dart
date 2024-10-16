import 'package:flutter/material.dart';

import 'package:sdga_design_system/sdga_design_system.dart';
import 'base_components_page.dart';

enum _SDGAButtonType {
  single('Single File'),
  multiple('Multiple');

  final String text;

  const _SDGAButtonType(this.text);
}

enum _SDGAFileStatus {
  success('Success'),
  uploading('Uploading'),
  error('Error');

  final String text;

  const _SDGAFileStatus(this.text);
}

class FileUploadPage extends BaseComponentsPage {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends BaseComponentsPageState<FileUploadPage> {
  _SDGAButtonType _type = _SDGAButtonType.single;
  _SDGAFileStatus _status = _SDGAFileStatus.success;
  bool _disabled = false;
  bool _hasData = false;

  @override
  Widget buildContent() {
    switch (_type) {
      case _SDGAButtonType.single:
        return Padding(
          padding: const EdgeInsets.all(SDGANumbers.spacingXL),
          child: SDGAFileInput.single(
            label: const Text('Upload Files'),
            helperText: const Text(
                'Maximum file size allowed is 2MB, supported file formats include .jpg, .png, and .pdf.'),
            onBrowseFile:
                _disabled ? null : () => setState(() => _hasData = true),
            onRemoveFile:
                _disabled ? null : (_) => setState(() => _hasData = false),
            file: _hasData
                ? SDGAFile<String>(
                    file: 'file',
                    filename: "file-name.png",
                    isUploading: _status == _SDGAFileStatus.uploading,
                    errorMessage: _status == _SDGAFileStatus.error
                        ? "Here goes the helper text."
                        : null,
                  )
                : null,
          ),
        );
      case _SDGAButtonType.multiple:
        return Padding(
          padding: const EdgeInsets.all(SDGANumbers.spacingXL),
          child: SDGAFileInput.multiple(
            label: const Text('Upload Files'),
            helperText: const Text(
                'Maximum file size allowed is 2MB, supported file formats include .jpg, .png, and .pdf.'),
            onBrowseFile:
                _disabled ? null : () => setState(() => _hasData = true),
            onRemoveFile:
                _disabled ? null : (_) => setState(() => _hasData = false),
            files: _hasData
                ? [
                    SDGAFile<String>(
                      file: 'file',
                      filename: "file-name.png",
                      isUploading: _status == _SDGAFileStatus.uploading,
                      errorMessage: _status == _SDGAFileStatus.error
                          ? "Here goes the helper text."
                          : null,
                    ),
                    const SDGAFile<String>(
                      file: 'file',
                      filename: "file-name.png",
                      isUploading: true,
                    ),
                    const SDGAFile<String>(
                      file: 'file',
                      filename: "file-name.png",
                      errorMessage: "Here goes the helper text.",
                    )
                  ]
                : null,
          ),
        );
    }
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildTypeProperty(),
      _buildStatusProperty(),
      _buildDisabledProperty(),
      _buildHasFileProperty(),
    ];
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.text,
      values: _SDGAButtonType.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _type = item),
    );
  }

  Widget _buildStatusProperty() {
    return buildSelectionProperty(
      title: 'Status',
      value: _status.text,
      values: _SDGAFileStatus.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _status = item),
    );
  }

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }

  Widget _buildHasFileProperty() {
    return SDGASwitchListTile(
      value: _hasData,
      title: const Text('Has File'),
      onChanged: (value) => setState(() => _hasData = value),
    );
  }
}
