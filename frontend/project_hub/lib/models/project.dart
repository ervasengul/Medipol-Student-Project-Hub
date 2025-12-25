class Project {
  final String id;
  final String title;
  final String description;
  final String category;
  final String faculty;
  final String creator;
  final String status;
  final List<String> lookingFor;
  final int currentTeamSize;
  final int maxTeamSize;
  final String startDate;
  final String duration;
  final int progress;
  final List<String> requirements;
  final List<String> objectives;
  final String? supervisor;
  final List<TeamMember> teamMembers;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.faculty,
    required this.creator,
    required this.status,
    required this.lookingFor,
    required this.currentTeamSize,
    required this.maxTeamSize,
    required this.startDate,
    required this.duration,
    required this.progress,
    required this.requirements,
    required this.objectives,
    this.supervisor,
    required this.teamMembers,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      faculty: json['faculty'] ?? '',
      creator: json['creator']?['name'] ?? json['creator'] ?? '',
      status: json['status'] ?? 'Planning',
      lookingFor: List<String>.from(json['looking_for'] ?? json['lookingFor'] ?? []),
      currentTeamSize: json['current_team_size'] ?? json['currentTeamSize'] ?? 0,
      maxTeamSize: json['max_team_size'] ?? json['maxTeamSize'] ?? 5,
      startDate: json['start_date'] ?? json['startDate'] ?? '',
      duration: json['duration'] ?? '',
      progress: json['progress'] ?? 0,
      requirements: List<String>.from(json['requirements'] ?? []),
      objectives: List<String>.from(json['objectives'] ?? []),
      supervisor: json['supervisor']?['name'] ?? json['supervisor'],
      teamMembers: (json['team_members'] ?? json['teamMembers'] ?? [])
          .map<TeamMember>((m) => TeamMember.fromJson(m is Map<String, dynamic> ? m : {'id': '0', 'name': m.toString(), 'role': 'Member'}))
          .toList(),
    );
  }

  String get teamSizeDisplay => '$currentTeamSize/$maxTeamSize';
}

class TeamMember {
  final String id;
  final String name;
  final String role;
  final String? avatar;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    this.avatar,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'].toString(),
      name: json['name'] ?? json['user']?['name'] ?? '',
      role: json['role'] ?? 'Member',
      avatar: json['avatar'] ?? json['user']?['profile_image'],
    );
  }
}

class Task {
  final String id;
  final String title;
  final String status;
  final String assignee;
  final String dueDate;
  final String priority;

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.assignee,
    required this.dueDate,
    required this.priority,
  });
}

class Milestone {
  final String id;
  final String title;
  final int progress;
  final String dueDate;
  final bool isCompleted;

  Milestone({
    required this.id,
    required this.title,
    required this.progress,
    required this.dueDate,
    required this.isCompleted,
  });
}

class Meeting {
  final String id;
  final String title;
  final String dateTime;
  final String location;
  final List<String> participants;

  Meeting({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.participants,
  });
}
