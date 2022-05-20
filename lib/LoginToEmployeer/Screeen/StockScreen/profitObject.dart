class ProfitObject {
  ProfitObject({
    this.message,
    this.response,
    this.status,
  });

  String? message;
  Profit? response;
  bool? status;

  factory ProfitObject.fromMap(Map<String, dynamic> json) => ProfitObject(
        message: json["message"] == null ? null : json["message"],
        response:
            json["response"] == null ? null : Profit.fromMap(json["response"]),
        status: json["status"] == null ? null : json["status"],
      );
}

class Profit {
  Profit({
    this.totalProfit,
    this.totalExpense,
    this.totalLose,
    this.totalAmount,
    this.totalRemaining,
  });

  int? totalProfit;
  int? totalExpense;
  int? totalLose;
  int? totalAmount;
  int? totalRemaining;

  factory Profit.fromMap(Map<String, dynamic> json) => Profit(
        totalProfit: json["totalProfit"] == null ? null : json["totalProfit"],
        totalExpense:
            json["totalExpense"] == null ? null : json["totalExpense"],
        totalLose: json["totalLose"] == null ? null : json["totalLose"],
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
        totalRemaining:
            json["totalRemaining"] == null ? null : json["totalRemaining"],
      );
}
