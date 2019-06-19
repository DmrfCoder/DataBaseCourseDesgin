import 'package:subject_system/bean/TableBean.dart';
import 'package:subject_system/configure/ui_configure.dart';
import 'package:subject_system/widgets/table_item_widget.dart';
import 'package:flutter/material.dart';

abstract class ListViewCallBack {
  onItemClick(TableBean item);

  onSortClick(int index);
}

enum SortType { UP, DOWN, DEFAULT, NONE }

class TableListView extends StatefulWidget {
  final List<TableBean> datas;
  final ListViewCallBack listViewCallBack;
  final List<String> heads;
  List<SortType> sortTypes;

  TableListView(this.datas, this.listViewCallBack, this.heads,
      List<SortType> tempSrtTypes) {
    if (this.sortTypes == null) {
      this.sortTypes = tempSrtTypes;
    }
  }

  @override
  State<StatefulWidget> createState() => _ListViewState();
}

class _ListViewState extends State<TableListView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tableItems = [];

    for (TableBean tableBean in widget.datas) {
      tableItems.add(GestureDetector(
          onTap: () => widget.listViewCallBack.onItemClick(tableBean),
          child: TableItemWidget(tableBean)));
    }

    tableItems.add(Center(
      child: Text(
        "没有更多了，共${widget.datas.length}条数据~",
        style: TextStyle(fontSize: 15.0),
      ),
    ));

    var listTile = ListTile.divideTiles(
            tiles: tableItems, context: context)
        .toList();

    return Column(
      children: <Widget>[
        _buildHead(context, widget.heads),
        Divider(
          height: 1.0,
          color: UiConfigure.black,
        ),
        Expanded(
          child: ListView(
            children: listTile,
            shrinkWrap: true,
          ),
        )
      ],
    );
  }

  _buildHead(BuildContext context, List<String> data) {
    double tabWidth = MediaQuery.of(context).size.width / data.length;

    List<Widget> items = [];
    var imagePath = "";
    for (int index = 0; index < data.length; index++) {
      switch (widget.sortTypes[index]) {
        case SortType.UP:
          imagePath = 'images/sort_up.png';
          break;
        case SortType.DOWN:
          imagePath = 'images/sort_down.png';
          break;
        case SortType.DEFAULT:
          imagePath = 'images/sort_default.png';
          break;
        case SortType.NONE:
          imagePath = "";
          break;
      }
      if (imagePath == "") {
        items.add(
          Container(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            width: tabWidth,
            child: Center(
              child: Text(
                data[index] == null ? "未知" : data[index],
                style: new TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      } else {
        items.add(
          Container(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            width: tabWidth,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  data[index] == null ? "未知" : data[index],
                  style: new TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.sortTypes[index] == SortType.NONE) {
                      return;
                    }
                    widget.listViewCallBack.onSortClick(index);
                  },
                  child: Container(
                    height: 23.0,
                    width: 23.0,
                    child: Image.asset(imagePath),
                  ),
                )
              ],
            )),
          ),
        );
      }
    }

    return Row(children: items);
  }
}
