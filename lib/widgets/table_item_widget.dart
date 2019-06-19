import 'package:subject_system/bean/TableBean.dart';
import 'package:flutter/material.dart';
import 'package:subject_system/configure/ui_configure.dart';

class TableItemWidget extends StatefulWidget {
  TableBean itemData;

  TableItemWidget(this.itemData);

  @override
  State<StatefulWidget> createState() {
    return _TableItemState();
  }
}

class _TableItemState extends State<TableItemWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildTableItem();
  }

  Widget _buildTableItem() {
    double tabWidth = MediaQuery.of(context).size.width /
        widget.itemData.getAttributesCount();

    List<Widget> items = [];
    widget.itemData.attributes.forEach((String attribute) {
      items.add(Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        width: tabWidth,
        child: Center(
          child: Text(
            attribute == null || attribute == "null" ? "未知" : attribute,
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      ));
    });

    return new Row(children: items);
  }
}
