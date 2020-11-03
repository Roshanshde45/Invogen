import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:invogen/Models/InvoDetails.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePreviewScreen extends StatefulWidget {
  final InvoDetails invoDetails;
  InvoicePreviewScreen({this.invoDetails});

  @override
  _InvoicePreviewScreenState createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
   PdfImage pdfImage;


  int total(int price , int qty) {
    print(price);
    print(qty);
    return price*qty;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Invoice Preview"),
        centerTitle: true,
        backgroundColor:  Color(0xff2C3335),
      ),
      body: PdfPreview(
        canChangePageFormat: false,
        build: (format) => writeOnPdf(format),
      ),
    );
  }

  Future<Uint8List> writeOnPdf(PdfPageFormat format,) async{
    final pdf = pw.Document();

    var imageProvider =  NetworkImage(widget.invoDetails.brandimage);
    final PdfImage image = await pdfImageFromImageProvider(pdf: pdf.document, image: imageProvider);


    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("INVOICE",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 44)),
                      pw.Container(
                          height: 60,
                          width: 70,
                          child: pw.Image(image)),
                    ]
                )
            ),
            pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                      width: 300,
                      child: pw.Container(
                        width: 300,
                        decoration: pw.BoxDecoration(
                            borderRadius: 10
                        ),
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.RichText(
                              text: pw.TextSpan(
                                text: 'Invoice to: \n',
                                children: <pw.TextSpan>[
                                  pw.TextSpan(
                                      text: '${widget.invoDetails.custName}\n',
                                      style:
                                      pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                  pw.TextSpan(
                                      text:
                                      widget.invoDetails.custAddress),
                                ],
                              ),
                              maxLines: 5
                          ),
                        ),
                      )),
                  pw.SizedBox(height: 8),
                  pw.Container(
                      color: PdfColor.fromHex("#c1c1c1"),
                      width: 300,
                      child: pw.Column(children: <pw.Widget>[
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text("Invoice#",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text(widget.invoDetails.invoId,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold, letterSpacing: 1)),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text("Date",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text(widget.invoDetails.dateGenerated)
                          ],
                        )
                      ])),
                  pw.SizedBox(height: 30),
                  pw.Table.fromTextArray(context: context, data: <List<String>>[
                    <String>['Product Id', 'Product', 'Price', 'Qty',"Total"],
                    ...widget.invoDetails.addedList.map(
                            (val) => ["58912468",val.name,val.price.toString(),val.qty.toString(),
                          total(val.price, val.qty).toString()
                        ]),
                  ]),
                ]
              )
            ),
            pw.Container(
              child: pw.Column(
                children: [
                  pw.Container(
                      alignment: pw.Alignment.topLeft,
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: <pw.Widget> [
                                  pw.Column(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                      children: <pw.Widget>[
                                        pw.SizedBox(height: 35),
                                        pw.Text("Thank you for your business",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16)),
                                        pw.SizedBox(height: 20),
                                        pw.Text("Payment Info: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                        pw.SizedBox(height: 8),
                                        pw.SizedBox(
                                            width: 200,
                                            child: pw.Text("877 N. Chapel Lane Ashtabula, OH 44004")
                                        ),
                                        pw.SizedBox(height: 20,),
                                        pw.Container(
                                            height: 1,
                                            width: 210,
                                            color: PdfColor.fromHex("#000000")
                                        ),
                                        pw.SizedBox(height: 30),
                                        pw.Text("Terms & Conditions",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                        pw.SizedBox(height: 8),
                                        pw.SizedBox(
                                            width: 200,
                                            child: pw.Column(
                                              children: widget.invoDetails.terms.map((e) => pw.Container(
                                                width: 600,child: pw.Text(" * $e\n\n"),)).toList(),
                                            )
                                        )
                                      ]
                                  ),
                                  pw.Column(
                                      children: <pw.Widget>[
                                        pw.Container(
                                            width: 220,
                                            decoration: pw.BoxDecoration(
                                              borderRadius: 0.0,
                                              color: PdfColor.fromHex("#DAE0E2"),
                                            ),
                                            padding: pw.EdgeInsets.all(8),
                                            child: pw.Column(
                                                children: <pw.Widget>[
                                                  pw.Row(
                                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                      children: <pw.Widget>[
                                                        pw.Text("Subtotal: ",style: pw.TextStyle(fontSize: 20,)),
                                                        pw.Text(widget.invoDetails.subTotal.toString(),style: pw.TextStyle(fontSize: 20,)),
                                                      ]
                                                  ),
                                                  pw.SizedBox(height: 10),
                                                  pw.Row(
                                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                      children: <pw.Widget>[
                                                        pw.Text("Tax: ",style: pw.TextStyle(fontSize: 20,)),
                                                        pw.Text(widget.invoDetails.tax.toString(),style: pw.TextStyle(fontSize: 20,)),
                                                      ]
                                                  ),
                                                  pw.SizedBox(height: 10),
                                                  pw.Container(
                                                      height: 1.3,
                                                      width: 200,
                                                      color: PdfColor.fromHex("#000000")
                                                  ),
                                                  pw.SizedBox(height: 8),
                                                  pw.Row(
                                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                      children: <pw.Widget>[
                                                        pw.Text("Total: ",style: pw.TextStyle(fontSize: 21,fontWeight: pw.FontWeight.bold)),
                                                        pw.Text(widget.invoDetails.total.toString(),style: pw.TextStyle(fontSize: 21,fontWeight: pw.FontWeight.bold,)),
                                                      ]
                                                  ),
                                                ]
                                            )
                                        ),
                                        pw.Container(
                                            height: 1,
                                            color: PdfColor.fromHex("#2C3335")
                                        ),
                                        widget.invoDetails.showContact? pw.Container(
                                            child: pw.Column(
                                                children: [
                                                  pw.SizedBox(height: 50),
                                                  pw.Text("Contact Us",style: pw.TextStyle(fontSize: 17)),
                                                  pw.Text("Phone No. +${widget.invoDetails.phone.toString()}",style: pw.TextStyle(fontSize: 13)),
                                                  pw.Text("Email ${widget.invoDetails.brandEmail}",style: pw.TextStyle(fontSize: 13)),
                                                ]
                                            )
                                        ): pw.Container()
                                      ]
                                  )
                                ]
                            )
                          ]
                      )
                  ),
                ]
              )
            ),
            pw.SizedBox(height: 100),
            pw.Text(widget.invoDetails.brandName,textAlign: pw.TextAlign.center),
            pw.Container(
                height: 1,
                color: PdfColor.fromHex("#000000")
            )
          ];
        }
      )
    );
    return pdf.save();
  }
}

