import 'package:challan_app/features/challan/data/models/challan_item.dart';

class Challan {
  final String workerid;
  final String challanNo;
  final DateTime date;
  final String workersNames;
  final int totalPiece;
  final String classification;
  final String isReady;
  final bool isDelivered;
  final DateTime? deliveryDate;
  final List<ChallanItem> items;
  final DateTime? lotCameDate;
  final DateTime? afterComingDate;
  final List<String> garmentTypes;
  final String sethid;

  const Challan({
    required this.challanNo,
    required this.date,
    required this.workersNames,
    required this.totalPiece,
    required this.classification,
    required this.isReady,
    required this.isDelivered,
    this.deliveryDate,
    required this.workerid,
    required this.items,
    this.lotCameDate,
    this.afterComingDate,
    required this.garmentTypes,
     required this.sethid,
  });
}
