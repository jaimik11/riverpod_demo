class DropdownModel{

  int id = -1;
  String label = '';
  String subLabel = '';

  DropdownModel({required this.id,required this.label});

  DropdownModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    label = json['subLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['subLabel'] = this.subLabel;
    return data;
  }

}