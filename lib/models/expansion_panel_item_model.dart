class ExpansionPanelItemModel{
  ExpansionPanelItemModel({this.isExpanded = false, required this.header, required this.body });
  bool isExpanded;
  final String header;
  final String body;
}