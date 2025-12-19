import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/project.dart';

class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({super.key});

  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Complete ML model training',
      status: 'in-progress',
      assignee: 'David Park',
      dueDate: 'Feb 28, 2025',
      priority: 'high',
    ),
    Task(
      id: '2',
      title: 'Design user interface mockups',
      status: 'completed',
      assignee: 'You',
      dueDate: 'Feb 15, 2025',
      priority: 'medium',
    ),
    Task(
      id: '3',
      title: 'Setup backend infrastructure',
      status: 'pending',
      assignee: 'Unassigned',
      dueDate: 'Mar 5, 2025',
      priority: 'high',
    ),
  ];

  final List<Milestone> _milestones = [
    Milestone(
      id: '1',
      title: 'Project Proposal',
      progress: 100,
      dueDate: 'Jan 15, 2025',
      isCompleted: true,
    ),
    Milestone(
      id: '2',
      title: 'Initial Prototype',
      progress: 45,
      dueDate: 'Mar 1, 2025',
      isCompleted: false,
    ),
    Milestone(
      id: '3',
      title: 'Beta Release',
      progress: 0,
      dueDate: 'Apr 15, 2025',
      isCompleted: false,
    ),
  ];

  final List<Meeting> _meetings = [
    Meeting(
      id: '1',
      title: 'Weekly Team Sync',
      dateTime: 'Feb 20, 2025 - 2:00 PM',
      location: 'Block A, Room 301',
      participants: ['Emily Chen', 'David Park', 'You'],
    ),
    Meeting(
      id: '2',
      title: 'Supervisor Meeting',
      dateTime: 'Feb 22, 2025 - 10:00 AM',
      location: 'Block A, Room 405',
      participants: ['Prof. Dr. Michael Roberts', 'You'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Management'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF0EA5E9),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF0EA5E9),
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Milestones'),
            Tab(text: 'Team'),
            Tab(text: 'Meetings'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Project Summary
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI-Powered Medical Diagnosis Assistant',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: LucideIcons.clock,
                        label: 'Status',
                        value: 'In Progress',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoChip(
                        icon: LucideIcons.trendingUp,
                        label: 'Progress',
                        value: '15%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: LucideIcons.calendar,
                        label: 'Due Date',
                        value: 'Aug 2025',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoChip(
                        icon: LucideIcons.users,
                        label: 'Team',
                        value: '2/5',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTasksTab(),
                _buildMilestonesTab(),
                _buildTeamTab(),
                _buildMeetingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Checkbox(
              value: task.status == 'completed',
              onChanged: (value) {},
            ),
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Assigned to: ${task.assignee}'),
                const SizedBox(height: 2),
                Text('Due: ${task.dueDate}'),
              ],
            ),
            trailing: _buildPriorityBadge(task.priority),
          ),
        );
      },
    );
  }

  Widget _buildMilestonesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _milestones.length,
      itemBuilder: (context, index) {
        final milestone = _milestones[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (milestone.isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: milestone.progress / 100,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF0EA5E9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${milestone.progress}% • Due: ${milestone.dueDate}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamTab() {
    final teamMembers = [
      TeamMember(id: '1', name: 'Emily Chen', role: 'Project Lead'),
      TeamMember(id: '2', name: 'David Park', role: 'ML Engineer'),
      TeamMember(id: '3', name: 'You', role: 'UI/UX Designer'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teamMembers.length,
      itemBuilder: (context, index) {
        final member = teamMembers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF0EA5E9),
              child: Text(
                member.name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(member.name),
            subtitle: Text(member.role),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.mail),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(LucideIcons.phone),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeetingsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _meetings.length,
      itemBuilder: (context, index) {
        final meeting = _meetings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.clock,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(meeting.dateTime),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.mapPin,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(meeting.location),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Participants: ${meeting.participants.join(', ')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityBadge(String priority) {
    const redColor = Color(0xFFEF4444);
    const orangeColor = Color(0xFFF59E0B);
    const greenColor = Color(0xFF10B981);

    Color color;
    switch (priority) {
      case 'high':
        color = redColor;
        break;
      case 'medium':
        color = orangeColor;
        break;
      default:
        color = greenColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
