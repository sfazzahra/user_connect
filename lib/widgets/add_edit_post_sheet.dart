import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AddEditPostSheet extends StatefulWidget {
  final String? initialTitle;
  final String? initialBody;
  final Future<void> Function(String title, String body) onSubmit;

  const AddEditPostSheet({super.key, this.initialTitle, this.initialBody, required this.onSubmit});

  @override
  State<AddEditPostSheet> createState() => _AddEditPostSheetState();
}

class _AddEditPostSheetState extends State<AddEditPostSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  bool _isSubmitting = false;

  bool get isEditMode => widget.initialTitle != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _bodyController = TextEditingController(text: widget.initialBody ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(_titleController.text.trim(), _bodyController.text.trim());
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${e.toString()}'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
            ),
            Text(
              isEditMode ? 'Edit Postingan' : 'Tambah Postingan Baru',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Judul tidak boleh kosong';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Isi Postingan'),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Isi postingan tidak boleh kosong';
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(isEditMode ? 'Simpan Perubahan' : 'Tambah Postingan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}