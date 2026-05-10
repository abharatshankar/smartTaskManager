import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_cubit.dart';

class TaskFormSheet extends StatefulWidget {
  final Map<String, dynamic>? task;
  const TaskFormSheet({super.key, this.task});

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  String _priority = 'Medium';
  String _status = 'Pending';

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?['title']?.toString() ?? '');
    _descCtrl = TextEditingController(text: widget.task?['description']?.toString() ?? '');
    _priority = widget.task?['priority']?.toString() ?? 'Medium';
    _status = widget.task?['status']?.toString() ?? 'Pending';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    final cubit = context.read<TaskCubit>();
    final id = widget.task?['id'];

    if (isEditing && id != null) {
      await cubit.updateTask(
        id: id is int ? id : int.parse(id.toString()),
        title: title,
        description: _descCtrl.text.trim(),
        priority: _priority,
        status: _status,
      );
    } else {
      await cubit.createTask(
        title: title,
        description: _descCtrl.text.trim(),
        priority: _priority,
        status: _status,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(99))),
              const SizedBox(height: 18),
              Text(isEditing ? 'Edit Task' : 'Add Task', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: _titleCtrl, decoration: _decoration('Title', Icons.title)),
              const SizedBox(height: 14),
              TextField(controller: _descCtrl, maxLines: 3, decoration: _decoration('Description', Icons.description_outlined)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _dropdown('Priority', _priority, ['High', 'Medium', 'Low'], (v) => setState(() => _priority = v!))),
                  const SizedBox(width: 12),
                  Expanded(child: _dropdown('Status', _status, ['Pending', 'In Progress', 'Completed'], (v) => setState(() => _status = v!))),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F5FE8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(isEditing ? 'Update Task' : 'Add Task', style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)));
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
