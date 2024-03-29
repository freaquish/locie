import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/components/appBar.dart';
import 'package:locie/components/flatActionButton.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/models/store.dart';

class AddressWidget extends StatefulWidget {
  final CreateOrEditStoreBloc bloc;
  Store store;
  AddressWidget({this.bloc, this.store});
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final TextEditingController textEditingControllerAddress1 =
      TextEditingController();
  // final TextEditingController textEditingControllerAddress2 =
  //     TextEditingController();
  final TextEditingController textEditingControllerState =
      TextEditingController();
  final TextEditingController textEditingControllerPinCode =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //(widget.store);
    if (widget.store.id != null && widget.store.address != null) {
      textEditingControllerAddress1.value =
          TextEditingValue(text: widget.store.address.body);
      textEditingControllerState.value =
          TextEditingValue(text: widget.store.address.city);
      textEditingControllerPinCode.value =
          TextEditingValue(text: widget.store.address.pinCode);
    }
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerAddress1.dispose();
    // textEditingControllerAddress2.dispose();
    textEditingControllerState.dispose();
    textEditingControllerPinCode.dispose();

    super.dispose();
  }

  void onBackClick(BuildContext context) {
    BlocProvider.of<CreateOrEditStoreBloc>(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);

    return WillPopScope(
      onWillPop: () async {
        onBackClick(context);
        return true;
      },
      child: Scaffold(
        appBar: Appbar().appbar(
          onTap: () {
            onBackClick(context);
          },
          context: context,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: PrimaryContainer(
            widget: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screen.horizontal(2),
                  horizontal: screen.horizontal(6)),
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: screen.vertical(30),
                    ),
                    CustomTextField(
                        textAlignment: TextAlign.left,
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Required field';
                          }
                          if (value.length > 150) {
                            return 'Address is greater than 150 character';
                          }
                        },
                        hintText: 'Address Line *',
                        textController: textEditingControllerAddress1,
                        maxLength: 150,
                        minLines: 2,
                        maxLines: 3,
                        keyboard: TextInputType.multiline),
                    SizedBox(
                      height: screen.vertical(10),
                    ),
                    // CustomTextField(
                    //     textAlignment: TextAlign.left,
                    //     hintText: 'Address Line 2',
                    //     maxLength: 100,
                    //     minLines: 1,
                    //     maxLines: 4,
                    //     textController: textEditingControllerAddress2,
                    //     keyboard: TextInputType.multiline),
                    SizedBox(
                      height: screen.vertical(10),
                    ),
                    CustomTextField(
                        textAlignment: TextAlign.left,
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Required field';
                          }
                          if (value.length > 50) {
                            return 'Value is greater than 50 character';
                          }
                        },
                        hintText: 'City, State *',
                        textController: textEditingControllerState,
                        maxLength: 50,
                        keyboard: TextInputType.name),
                    SizedBox(
                      height: screen.vertical(10),
                    ),
                    CustomTextField(
                        textAlignment: TextAlign.left,
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Required field';
                          }
                        },
                        hintText: 'Pin Code *',
                        textController: textEditingControllerPinCode,
                        keyboard: TextInputType.number),
                    SizedBox(
                      height: screen.vertical(300),
                    ),
                    SubmitButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          debugPrint('submit');
                          widget.store.address = Address(
                              body: textEditingControllerAddress1.value.text,
                              city: textEditingControllerState.value.text,
                              pinCode: textEditingControllerPinCode.value.text);
                          widget.bloc..add(ProceedToMetaDataPage(widget.store));
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
      ),
    );
  }
}
