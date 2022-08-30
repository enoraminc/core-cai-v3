class ExampleData {
  final String id;
  final String title;
  final String description;
  final String state;

  static List<ExampleData> getDataDummyList() {
    return [
      ExampleData(
        id: "1",
        title: "Example 1",
        description: "This is description of Example 1",
        state: "Created",
      ),
      ExampleData(
        id: "2",
        title: "Example 2",
        description: "This is description of Example 2",
        state: "Created",
      ),
      ExampleData(
        id: "3",
        title: "Example 3",
        description: "This is description of Example 3",
        state: "Created",
      ),
      ExampleData(
        id: "4",
        title: "Example 4",
        description: "This is description of Example 4",
        state: "Created",
      ),
    ];
  }

  ExampleData({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
  });
}
