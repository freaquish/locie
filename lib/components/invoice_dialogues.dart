import 'package:flutter/material.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/components/text_field.dart';
import 'package:locie/helper/screen_size.dart';

class AddItemInvoiceDialogue extends StatefulWidget {
  @override
  _AddItemInvoiceDialogueState createState() => _AddItemInvoiceDialogueState();
}

class _AddItemInvoiceDialogueState extends State<AddItemInvoiceDialogue> {
  TextEditingController textEditingControllerPrice = TextEditingController();

  @override
  void dispose() {
    textEditingControllerPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Dialog(
      child: PrimaryContainer(
        widget: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screen.horizontal(4),
                vertical: screen.horizontal(1)),
            child: Column(
              children: [
                CustomTextField(
                    validator: (value) {
                      if (value.isEmpty || value == null) {
                        return 'Required field';
                      }
                    },
                    textAlignment: TextAlign.start,
                    hintText: 'Price',
                    maxLines: 3,
                    minLines: 2,
                    textController: textEditingControllerPrice,
                    keyboard: TextInputType.number),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
