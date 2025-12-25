import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/project_provider.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teamSizeController = TextEditingController();
  final _durationController = TextEditingController();
  
  String? _selectedCategory;
  String? _selectedFaculty;
  String? _selectedSupervisor;
  DateTime? _startDate;
  
  final List<String> _roles = [];
  final List<String> _skills = [];
  final _roleController = TextEditingController();
  final _skillController = TextEditingController();

  final List<String> _categories = [
    'AI & Machine Learning',
    'Web Development',
    'Mobile Development',
    'Data Science',
    'IoT',
    'Research',
  ];

  final List<String> _faculties = [
    'Faculty of Engineering',
    'Faculty of Medicine',
    'Faculty of Business',
    'Faculty of Law',
    'Faculty of Arts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Project'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title',
                  hintText: 'Enter project title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your project',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
                validator: (value) {
                  if (value == null) return 'Please select a category';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedFaculty,
                decoration: const InputDecoration(
                  labelText: 'Faculty',
                  border: OutlineInputBorder(),
                ),
                items: _faculties.map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Text(faculty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedFaculty = value);
                },
                validator: (value) {
                  if (value == null) return 'Please select a faculty';
                  return null;
                },
              ),
              
              const SizedBox(height: 32),

              // Timeline
              _buildSectionTitle('Timeline'),
              const SizedBox(height: 16),
              
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start Date'),
                subtitle: Text(
                  _startDate == null
                      ? 'Select start date'
                      : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                ),
                trailing: const Icon(LucideIcons.calendar),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _startDate = date);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  hintText: 'e.g., 6 months',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 32),

              // Team Requirements
              _buildSectionTitle('Team Requirements'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _teamSizeController,
                decoration: const InputDecoration(
                  labelText: 'Maximum Team Size',
                  hintText: 'Enter number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              
              // Looking For Roles
              _buildChipInput(
                label: 'Looking For (Roles)',
                hint: 'e.g., Backend Developer',
                controller: _roleController,
                items: _roles,
                onAdd: () {
                  if (_roleController.text.isNotEmpty) {
                    setState(() {
                      _roles.add(_roleController.text);
                      _roleController.clear();
                    });
                  }
                },
                onRemove: (index) {
                  setState(() => _roles.removeAt(index));
                },
              ),
              const SizedBox(height: 16),
              
              // Required Skills
              _buildChipInput(
                label: 'Required Skills',
                hint: 'e.g., Flutter, Python',
                controller: _skillController,
                items: _skills,
                onAdd: () {
                  if (_skillController.text.isNotEmpty) {
                    setState(() {
                      _skills.add(_skillController.text);
                      _skillController.clear();
                    });
                  }
                },
                onRemove: (index) {
                  setState(() => _skills.removeAt(index));
                },
              ),
              
              const SizedBox(height: 32),

              // Supervisor
              _buildSectionTitle('Supervisor (Optional)'),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedSupervisor,
                decoration: const InputDecoration(
                  labelText: 'Select Supervisor',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Prof. Dr. Michael Roberts',
                    child: Text('Prof. Dr. Michael Roberts'),
                  ),
                  DropdownMenuItem(
                    value: 'Asst. Prof. Dr. John Davis',
                    child: Text('Asst. Prof. Dr. John Davis'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedSupervisor = value);
                },
              ),
              
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Project'),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChipInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<String> items,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(LucideIcons.plus),
              onPressed: onAdd,
            ),
          ),
          onSubmitted: (_) => onAdd(),
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.asMap().entries.map((entry) {
              return Chip(
                label: Text(entry.value),
                onDeleted: () => onRemove(entry.key),
                backgroundColor: const Color.fromRGBO(14, 165, 233, 0.1),
                labelStyle: const TextStyle(color: Color(0xFF0EA5E9)),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final success = await Provider.of<ProjectProvider>(context, listen: false)
          .createProject(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory ?? 'General',
        lookingFor: _roles,
        maxTeamSize: int.tryParse(_teamSizeController.text),
        startDate: _startDate?.toIso8601String(),
        duration: _durationController.text,
        requirements: _skills,
        objectives: [],
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project created successfully!')),
          );
          Navigator.pop(context);
        } else {
          final error = Provider.of<ProjectProvider>(context, listen: false).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'Failed to create project'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _teamSizeController.dispose();
    _durationController.dispose();
    _roleController.dispose();
    _skillController.dispose();
    super.dispose();
  }
}
