import 'package:flutter/material.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/store.dart';

class MetaDataWidget extends StatefulWidget {
  final CreateOrEditStoreBloc bloc;
  Store store;
  MetaDataWidget({this.bloc, this.store});
  @override
  _MetaDataWidgetState createState() => _MetaDataWidgetState();
}

class _MetaDataWidgetState extends State<MetaDataWidget> {
  final TextEditingController textEditingControllerGSTIN =
      TextEditingController();
  final TextEditingController textEditingControllerDescription =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textEditingControllerGSTIN.dispose();
    textEditingControllerDescription.dispose();

    super.dispose();
  }

  String storeState() {
    return widget.store.id == null ? 'Create' : 'Edit';
  }

  @override
  void initState() {
    if (widget.store.id != null) {
      textEditingControllerDescription.value =
          TextEditingValue(text: widget.store.description);
      if (widget.store.gstin != null) {
        textEditingControllerGSTIN.value =
            TextEditingValue(text: widget.store.gstin);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);

    return Scaffold(
      appBar: Appbar().appbar(
        onTap: () {
          widget.bloc..add(ProceedToAddressPage(widget.store));
        },
        context: context,
        title: LatoText(
          '${storeState()} Store',
          size: 22,
          weight: FontWeight.bold,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: PrimaryContainer(
          widget: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screen.horizontal(2),
                horizontal: screen.horizontal(8)),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: screen.vertical(30),
                  ),
                  TextBox(
                      textAlignment: TextAlign.left,
                      // validator: (value) {
                      //   if (value.isEmpty || value == null) {
                      //     return 'Required field';
                      //   }
                      // },
                      hintText: 'GSTIN',
                      textController: textEditingControllerGSTIN,
                      maxLength: 40,
                      keyboard: TextInputType.name),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  TextBox(
                      textAlignment: TextAlign.left,
                      hintText: 'Description *',
                      maxLength: 150,
                      minLines: 5,
                      maxLines: 5,
                      textController: textEditingControllerDescription,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Required field';
                        }
                        if (value.length > 150) {
                          return 'Description is greater than 150 character';
                        }
                      },
                      keyboard: TextInputType.multiline),
                  SizedBox(
                    height: screen.vertical(380),
                  ),
                  SubmitButton(
                    //TODO run a function for next page
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        debugPrint('submit');
                        widget.store.description =
                            textEditingControllerDescription.value.text;
                        if (textEditingControllerGSTIN.value.text != null &&
                            textEditingControllerGSTIN.value.text.isNotEmpty) {
                          widget.store.gstin =
                              textEditingControllerGSTIN.value.text;
                        }
                        widget.bloc..add(CreateStore(store: widget.store));
                      }
                    },
                    buttonName: 'Continue',
                    buttonColor: Color(0xff355cfd),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
