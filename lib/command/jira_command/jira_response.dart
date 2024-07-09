import 'dart:convert';

import 'package:equatable/equatable.dart';

class JiraResponse extends Equatable {
  const JiraResponse({
    required this.expand,
    required this.startAt,
    required this.maxResults,
    required this.total,
    required this.issues,
  });

  factory JiraResponse.fromMap(
    Map<String, dynamic> map,
  ) {
    return JiraResponse(
      expand: map['expand'],
      startAt: int.tryParse(map['startAt']?.toString() ?? ''),
      maxResults: int.tryParse(map['maxResults']?.toString() ?? ''),
      total: int.tryParse(map['total']?.toString() ?? ''),
      issues: map['issues'] is List
          ? List.from(
              (map['issues'] as List)
                  .where((element) => element != null)
                  .map((e) => IssuesJira.fromMap(e)),
            )
          : null,
    );
  }

  factory JiraResponse.fromJson(String source) =>
      JiraResponse.fromMap(json.decode(source));

  final String? expand;
  final int? startAt;
  final int? maxResults;
  final int? total;
  final List<IssuesJira>? issues;

  Map<String, dynamic> toMap() {
    return {
      'expand': expand,
      'startAt': startAt,
      'maxResults': maxResults,
      'total': total,
      'issues': issues
          ?.map(
            (e) => e.toMap(),
          )
          .toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        expand,
        startAt,
        maxResults,
        total,
        issues,
      ];
}

class IssuesJira extends Equatable {
  const IssuesJira({
    required this.expand,
    required this.id,
    required this.self,
    required this.key,
    required this.fields,
  });

  factory IssuesJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return IssuesJira(
      expand: map['expand'],
      id: map['id'],
      self: map['self'],
      key: map['key'],
      fields: map['fields'] == null
          ? null
          : FieldsJira.fromMap(
              map['fields'],
            ),
    );
  }

  factory IssuesJira.fromJson(String source) =>
      IssuesJira.fromMap(json.decode(source));

  final String? expand;
  final String? id;
  final String? self;
  final String? key;
  final FieldsJira? fields;

  Map<String, dynamic> toMap() {
    return {
      'expand': expand,
      'id': id,
      'self': self,
      'key': key,
      'fields': fields?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        expand,
        id,
        self,
        key,
        fields,
      ];
}

class FieldsJira extends Equatable {
  const FieldsJira({
    required this.summary,
    required this.parent,
  });

  factory FieldsJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return FieldsJira(
      summary: map['summary'],
      parent: map['parent'] == null
          ? null
          : ParentJira.fromMap(
              map['parent'],
            ),
    );
  }

  factory FieldsJira.fromJson(String source) =>
      FieldsJira.fromMap(json.decode(source));

  final String? summary;
  final ParentJira? parent;

  Map<String, dynamic> toMap() {
    return {
      'summary': summary,
      'parent': parent?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        summary,
        parent,
      ];
}

class ParentJira extends Equatable {
  const ParentJira({
    required this.id,
    required this.key,
    required this.self,
    required this.fields,
  });

  factory ParentJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return ParentJira(
      id: map['id'],
      key: map['key'],
      self: map['self'],
      fields: map['fields'] == null
          ? null
          : AlphaFieldsJira.fromMap(
              map['fields'],
            ),
    );
  }

  factory ParentJira.fromJson(String source) =>
      ParentJira.fromMap(json.decode(source));

  final String? id;
  final String? key;
  final String? self;
  final AlphaFieldsJira? fields;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'self': self,
      'fields': fields?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        id,
        key,
        self,
        fields,
      ];
}

class AlphaFieldsJira extends Equatable {
  const AlphaFieldsJira({
    required this.summary,
    required this.status,
    required this.priority,
    required this.issuetype,
  });

  factory AlphaFieldsJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return AlphaFieldsJira(
      summary: map['summary'],
      status: map['status'] == null
          ? null
          : StatusJira.fromMap(
              map['status'],
            ),
      priority: map['priority'] == null
          ? null
          : PriorityJira.fromMap(
              map['priority'],
            ),
      issuetype: map['issuetype'] == null
          ? null
          : IssuetypeJira.fromMap(
              map['issuetype'],
            ),
    );
  }

  factory AlphaFieldsJira.fromJson(String source) =>
      AlphaFieldsJira.fromMap(json.decode(source));

  final String? summary;
  final StatusJira? status;
  final PriorityJira? priority;
  final IssuetypeJira? issuetype;

  Map<String, dynamic> toMap() {
    return {
      'summary': summary,
      'status': status?.toMap(),
      'priority': priority?.toMap(),
      'issuetype': issuetype?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        summary,
        status,
        priority,
        issuetype,
      ];
}

class StatusJira extends Equatable {
  const StatusJira({
    required this.self,
    required this.description,
    required this.iconUrl,
    required this.name,
    required this.id,
    required this.statusCategory,
  });

  factory StatusJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return StatusJira(
      self: map['self'],
      description: map['description'],
      iconUrl: map['iconUrl'],
      name: map['name'],
      id: map['id'],
      statusCategory: map['statusCategory'] == null
          ? null
          : StatusCategoryJira.fromMap(
              map['statusCategory'],
            ),
    );
  }

  factory StatusJira.fromJson(String source) =>
      StatusJira.fromMap(json.decode(source));

  final String? self;
  final String? description;
  final String? iconUrl;
  final String? name;
  final String? id;
  final StatusCategoryJira? statusCategory;

  Map<String, dynamic> toMap() {
    return {
      'self': self,
      'description': description,
      'iconUrl': iconUrl,
      'name': name,
      'id': id,
      'statusCategory': statusCategory?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        self,
        description,
        iconUrl,
        name,
        id,
        statusCategory,
      ];
}

class StatusCategoryJira extends Equatable {
  const StatusCategoryJira({
    required this.self,
    required this.id,
    required this.key,
    required this.colorName,
    required this.name,
  });

  factory StatusCategoryJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return StatusCategoryJira(
      self: map['self'],
      id: int.tryParse(map['id']?.toString() ?? ''),
      key: map['key'],
      colorName: map['colorName'],
      name: map['name'],
    );
  }

  factory StatusCategoryJira.fromJson(String source) =>
      StatusCategoryJira.fromMap(json.decode(source));

  final String? self;
  final int? id;
  final String? key;
  final String? colorName;
  final String? name;

  Map<String, dynamic> toMap() {
    return {
      'self': self,
      'id': id,
      'key': key,
      'colorName': colorName,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        self,
        id,
        key,
        colorName,
        name,
      ];
}

class PriorityJira extends Equatable {
  const PriorityJira({
    required this.self,
    required this.iconUrl,
    required this.name,
    required this.id,
  });

  factory PriorityJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return PriorityJira(
      self: map['self'],
      iconUrl: map['iconUrl'],
      name: map['name'],
      id: map['id'],
    );
  }

  factory PriorityJira.fromJson(String source) =>
      PriorityJira.fromMap(json.decode(source));

  final String? self;
  final String? iconUrl;
  final String? name;
  final String? id;

  Map<String, dynamic> toMap() {
    return {
      'self': self,
      'iconUrl': iconUrl,
      'name': name,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        self,
        iconUrl,
        name,
        id,
      ];
}

class IssuetypeJira extends Equatable {
  const IssuetypeJira({
    required this.self,
    required this.id,
    required this.description,
    required this.iconUrl,
    required this.name,
    required this.subtask,
    required this.avatarId,
    required this.hierarchyLevel,
  });

  factory IssuetypeJira.fromMap(
    Map<String, dynamic> map,
  ) {
    return IssuetypeJira(
      self: map['self'],
      id: map['id'],
      description: map['description'],
      iconUrl: map['iconUrl'],
      name: map['name'],
      subtask: map['subtask'],
      avatarId: int.tryParse(map['avatarId']?.toString() ?? ''),
      hierarchyLevel: int.tryParse(map['hierarchyLevel']?.toString() ?? ''),
    );
  }

  factory IssuetypeJira.fromJson(String source) =>
      IssuetypeJira.fromMap(json.decode(source));

  final String? self;
  final String? id;
  final String? description;
  final String? iconUrl;
  final String? name;
  final bool? subtask;
  final int? avatarId;
  final int? hierarchyLevel;

  Map<String, dynamic> toMap() {
    return {
      'self': self,
      'id': id,
      'description': description,
      'iconUrl': iconUrl,
      'name': name,
      'subtask': subtask,
      'avatarId': avatarId,
      'hierarchyLevel': hierarchyLevel,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        self,
        id,
        description,
        iconUrl,
        name,
        subtask,
        avatarId,
        hierarchyLevel,
      ];
}
