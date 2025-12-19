import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildStatusBadge(project.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF0EA5E9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: project.progress / 100,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0EA5E9)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${project.progress}% Complete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            _buildSection(
              context,
              title: 'Description',
              child: Text(
                project.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // Project Details
            _buildSection(
              context,
              title: 'Project Details',
              child: Column(
                children: [
                  _buildDetailRow(context, 'Team Size', project.teamSizeDisplay),
                  _buildDetailRow(context, 'Start Date', project.startDate),
                  _buildDetailRow(context, 'Duration', project.duration),
                  _buildDetailRow(context, 'Faculty', project.faculty),
                ],
              ),
            ),

            // Looking For
            _buildSection(
              context,
              title: 'Looking For',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.lookingFor
                    .map((role) => Chip(
                          label: Text(role),
                          backgroundColor: const Color.fromRGBO(14, 165, 233, 0.1),
                          labelStyle: const TextStyle(color: Color(0xFF0EA5E9)),
                        ))
                    .toList(),
              ),
            ),

            // Requirements
            _buildSection(
              context,
              title: 'Requirements',
              child: Column(
                children: project.requirements
                    .map((req) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 20)),
                              Expanded(child: Text(req)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Objectives
            _buildSection(
              context,
              title: 'Project Objectives',
              child: Column(
                children: project.objectives
                    .map((obj) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 20)),
                              Expanded(child: Text(obj)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Creator Info
            _buildSection(
              context,
              title: 'Project Creator',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF0EA5E9),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(project.creator),
                subtitle: Text(project.faculty),
              ),
            ),

            // Supervisor
            if (project.supervisor != null)
              _buildSection(
                context,
                title: 'Supervisor',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF0EA5E9),
                    child: Icon(Icons.school, color: Colors.white),
                  ),
                  title: Text(project.supervisor!),
                  subtitle: const Text('Project Advisor'),
                ),
              ),

            // Team Members
            _buildSection(
              context,
              title: 'Current Team',
              child: Column(
                children: project.teamMembers
                    .map((member) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF0EA5E9),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(member.name),
                          subtitle: Text(member.role),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: ElevatedButton(
          onPressed: () {
            _showJoinRequestDialog(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Request to Join Project'),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    const greenColor = Color(0xFF10B981);
    const blueColor = Color(0xFF0EA5E9);
    const grayColor = Color(0xFF6B7280);
    
    Color color;
    switch (status) {
      case 'Recruiting':
        color = greenColor;
        break;
      case 'In Progress':
        color = blueColor;
        break;
      default:
        color = grayColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showJoinRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Request'),
        content: const Text(
          'Your request to join this project will be sent to the project creator. '
          'They will review your profile and respond accordingly.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Join request sent successfully!'),
                ),
              );
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }
}
