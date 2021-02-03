import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/category_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/color.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/category.dart';

class CategorySelection extends StatefulWidget {
  final CategoryBloc bloc;
  final List<Category> categories;
  CategorySelection({this.bloc, this.categories});
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  Category groupValue;

  void onSelect(Category category) {
    // //printcategory.name);
    setState(() {
      groupValue = category;
    });
  }

  void onClickForwardArrow(Category category) {
    //printwidget.bloc);
    widget.bloc..add(ProceedToNextCategoryPage(category.id));
  }

  void onAddClick(BuildContext context) {
    if (groupValue == null) {
      showNoCategorySelectedError(context);
    } else {
      widget.bloc..add(InitiateAddNewCategory(groupValue.id));
    }
  }

  void onBackClick() {
    if (widget.bloc.categoriesAcrossPages.length > 1) {
      widget.bloc..add(ProceedToLastCategoryPage());
    } else {
      Navigator.of(context).pop();
    }
  }

  void onNext(BuildContext context) {
    // Navigate to create item builder but do not bloc jump

    if (groupValue != null) {
      BlocProvider.of<NavigationBloc>(context)
        ..add(NavigateToCreateListing(groupValue));
    } else {
      showNoCategorySelectedError(context);
    }
  }

  void showNoCategorySelectedError(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colour.bgColor,
              content:
                  Container(child: RailwayText("You must select one category")),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Colour.bgColor,
            width: scale.horizontal(100),
            height: scale.vertical(120),
            padding: EdgeInsets.symmetric(
                vertical: scale.vertical(20), horizontal: scale.horizontal(4)),
            child: SubmitButton(
              onPressed: () {
                onNext(context);
                // showNoCategorySelectedError(context);
              },
              buttonName: 'Continue',
              buttonColor: Colour.submitButtonColor,
            ),
          ),
        ),
      ),
      appBar: Appbar().appbar(
          context: context,
          title: LatoText(
            'Category',
            size: 18,
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  onAddClick(context);
                })
          ],
          onTap: () {
            onBackClick();
          }),
      body: PrimaryContainer(
        widget: Container(
          child: (widget.categories == null)
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: scale.vertical(15),
                          horizontal: scale.horizontal(1)),
                      child: ListTile(
                        leading: Radio<Category>(
                            value: widget.categories[index],
                            groupValue: groupValue,
                            activeColor: Colors.amber,
                            hoverColor: Colors.blue,
                            onChanged: (category) {
                              onSelect(category);
                            }),
                        title: LatoText(
                          widget.categories[index].name,
                          size: 18,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            onClickForwardArrow(widget.categories[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
