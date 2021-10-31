class ElectionItems {
  final int number;
  final String displayName;

  ElectionItems({
    required this.number,
    required this.displayName,
  });

  factory ElectionItems.fromJson(Map<String, dynamic> json) {
    return ElectionItems(
      number: json['number'],
      displayName: json['displayName'],
    );
  }

  ElectionItems.fromJson2(Map<String, dynamic> json)
      : number = json['number'],
        displayName = json['displayName'];


  @override
  String toString() {
    return '$number: $displayName';
  }
}