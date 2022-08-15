class PdfModel {
  bool? status;
  String? expensesPdf;

  PdfModel({this.status, this.expensesPdf});

  PdfModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    expensesPdf = json['expenses_pdf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['expenses_pdf'] = this.expensesPdf;
    return data;
  }
}
