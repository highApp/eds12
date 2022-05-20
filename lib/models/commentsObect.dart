class CommentsObject {
  CommentsObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  List<Comment> response;
  bool status;

  factory CommentsObject.fromMap(Map<String, dynamic> json) => CommentsObject(
        message: json["message"],
        response:
            List<Comment>.from(json["response"].map((x) => Comment.fromMap(x))),
        status: json["status"],
      );
}

class Comment {
  Comment({
    required this.id,
    required this.gid,
    required this.date,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String gid;
  String date;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        id: json["id"],
        gid: json["gid"],
        date: json["date"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
