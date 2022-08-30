part of flutter_mentions;

class OptionList extends StatelessWidget {
  OptionList({
    required this.data,
    required this.onTap,
    required this.suggestionListHeight,
    this.suggestionBuilder,
    this.suggestionListDecoration,
  });

  final Widget Function(Map<String, dynamic>)? suggestionBuilder;

  final List<Map<String, dynamic>> data;

  final Function(Map<String, dynamic>) onTap;

  final double suggestionListHeight;

  final BoxDecoration? suggestionListDecoration;

  @override
  Widget build(BuildContext context) {
    return data.isNotEmpty
        ? Container(
            constraints: BoxConstraints(
                maxHeight: suggestionListHeight,
                minHeight: 0,
                maxWidth: 25,
                minWidth: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onTap(data[index]);
                  },
                  onTapDown: (details) {
                    // onTap(data[index]);
                  },
                  child: suggestionBuilder != null
                      ? suggestionBuilder!(data[index])
                      : Container(
                          color: Colors.blue,
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            data[index]['display'],
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                );
              },
            ),
          )
        : Container();
  }

  double getHeight(List<Map<String, dynamic>> totalData) {
    return (totalData.length == 1)
        ? 25
        : (totalData.length == 2)
            ? 50
            : (totalData.length == 3)
                ? 75
                : double.infinity;
  }
}
