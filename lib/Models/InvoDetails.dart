import 'package:invogen/Models/ItemModel.dart';

class InvoDetails {
  String custName;
  String custAddress;
  String invoId;
  String dateGenerated;
  double subTotal;
  double tax;
  double total;
  double totaltax;
  List<ItemModel> addedList;
  String qty;
  List terms;
  String brandName;
  String brandimage;
  String companyAddress;
  bool showContact;
  String brandEmail;
  String phone;

  InvoDetails({
      this.custName,
      this.custAddress,
      this.invoId,
      this.dateGenerated,
      this.subTotal,
      this.tax,
      this.total,
      this.addedList,
      this.qty,
      this.terms,
      this.brandName,
      this.brandimage,
      this.totaltax,
      this.showContact,
      this.brandEmail,
      this.phone,
      this.companyAddress});
}