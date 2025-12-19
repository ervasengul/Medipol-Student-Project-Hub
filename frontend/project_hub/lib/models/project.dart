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
