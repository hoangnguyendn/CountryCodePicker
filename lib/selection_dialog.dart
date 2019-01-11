import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(this.elements, this.favoriteElements);

  @override
  State<StatefulWidget> createState() => new _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  List<CountryCode> showedElements = [];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    var result = ListView.builder(
      shrinkWrap: true,
      itemCount: showedElements.length,
      itemBuilder: (context, int index) {
        return Container(
          child: SimpleDialogOption(
            key: Key(showedElements[index].toLongString()),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Image.asset(
                      showedElements[index].flagUri,
                      package: 'country_code_picker',
                      width: 32.0,
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    showedElements[index].toLongString(),
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .textTheme
                            .display1
                            .color,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              _selectItem(showedElements[index]);
            },
          ),);
      },
    );


    return SimpleDialog(
      title: new Column(
        children: <Widget>[
          new TextField(
            style: TextStyle(
                fontSize: 17.0, color: Theme
                .of(context)
                .textTheme
                .display1
                .color),
            decoration: new InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme
                    .of(context)
                    .textTheme
                    .display1
                    .color),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme
                    .of(context)
                    .textTheme
                    .display1
                    .color),
              ),
              contentPadding: EdgeInsets.all(15.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              suffixIcon: Icon(Icons.search, color: Theme
                  .of(context)
                  .textTheme
                  .display1
                  .color,),),
            onChanged: _filterElements,
          ),
          SizedBox(height: 5.0,)
        ],
      ),
      children: [
        widget.favoriteElements.isEmpty
            ? new Container()
            : new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[]
            ..addAll(widget.favoriteElements
                .map(
                  (f) =>
              new SimpleDialogOption(
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(right: 16.0),
                        child: Image.asset(
                          f.flagUri,
                          package: 'country_code_picker',
                          width: 32.0,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: new Text(
                        f.toLongString(),
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .textTheme
                                .display1
                                .color,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _selectItem(f);
                },
              ),
            )
                .toList())
            ..add(new Divider(
              color: Theme
                  .of(context)
                  .textTheme
                  .display1
                  .color,
            ),),),
        Container(
          height: deviceHeight * 0.4,
          width: 200.0
          child: result,
        )
      ],
    );
  }


  @override
  void initState() {
    showedElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      showedElements = widget.elements
          .where((e) =>
      e.code.contains(s) ||
          e.dialCode.contains(s) ||
          e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
