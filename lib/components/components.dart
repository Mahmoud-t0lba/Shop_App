import 'package:flutter/material.dart';
import 'constants.dart';
import '../view/home/cubit/cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  double radius = 3,
  var function,
  String? text,
}) {
  return Container(
    width: width,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        radius,
      ),
      color: background,
    ),
    child: MaterialButton(
      onPressed: function,
      child: Text(
        text!,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget defaultTextButton({
  var function,
  String? text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(text!),
    );

Widget defaultFormField({
  TextEditingController? controller,
  TextInputType? type,
  var onSubmit,
  var onChange,
  var onTap,
  bool isPassword = false,
  String? validate,
  String? label,
  IconData? prefix,
  IconData? suffix,
  var suffixPressed,
  bool? isClickable = true,
  bool? autocorrect,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: (val) {
        if (val!.isEmpty) {
          return '$validate';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

void showToast({
  String? text,
  ToastStates? state,
}) =>
    Fluttertoast.showToast(
      msg: text!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state!),
      textColor: Colors.white,
      fontSize: 16,
    );

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget buildListProduct(model, context, {bool isOldPrice = true}) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: SizedBox(
      height: 120,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image),
                width: 120,
                height: 120,
              ),
              if (model.discount != 0 && isOldPrice)
                Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      model.price.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (model.discount != 0 && isOldPrice)
                      Text(
                        model.oldPrice.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorites(model.id!);
                        print(model.id);
                      },
                      icon: CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            ShopCubit.get(context).favorites[model.id]!
                                ? defaultColor
                                : Colors.grey,
                        child: const Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
