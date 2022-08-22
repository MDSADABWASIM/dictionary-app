class Definition {
    Definition({
        this.type,
        this.definition,
        this.example,
        this.imageUrl,
        this.emoji,
    });

    String? type;
    String? definition;
    String? example;
    String? imageUrl;
    String? emoji;

    factory Definition.fromMap(Map<String, dynamic> json) => Definition(
        type: json["type"] ?? "",
        definition: json["definition"] ?? "",
        example: json["example"] ?? "",
        imageUrl: json["image_url"] ?? "",
        emoji: json["emoji"] ?? "",
    );

    Map<String, dynamic> toMap() => {
        "type": type ?? "",
        "definition": definition ?? "",
        "example": example ?? "",
        "image_url": imageUrl ?? "",
        "emoji": emoji ?? "",
    };
}