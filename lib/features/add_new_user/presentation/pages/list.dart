import 'dart:js';

import 'package:admin/features/add_new_user/domain/entities/user_entity.dart';
import 'package:admin/utils/page_route_name.dart';
import 'package:admin/utils/routes.dart';
import 'package:admin/widget/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:admin/extensions/extension.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared_components/build_date_time_picker_field.dart';
import '../../../../core/shared_components/build_dialog.dart';
import '../../../../core/shared_components/drop_down_widget.dart';
import '../../../../core/shared_components/styled_content_widget.dart';
import '../../../../core/shared_page/app_empty.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/text_field_validator.dart';
import '../../../../widget/custom_text_field.dart';
import '../../../../widget/data_cell_item.dart';
import '../../../../widget/data_column_Item.dart';
import '../../../../widget/data_controller.dart';
import '../../../../widget/data_table.dart';
import '../../../../widget/gender_selector.dart';
import '../controller/user_controller.dart';

class UsersList extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return controller.obx((state) => buildBody(state, context),
        onLoading: Scaffold(
          body: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
        onEmpty: appEmpty(onPressed: () => Get.toNamed(PageRouteName.ADD_NEW)));
  }

  Scaffold buildBody(List<UserEntity>? users, BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            StyledContent(
              subTitle: 'السكن',
              leadingWidget: CustomButton(
                  width: 200,
                  height: 50,
                  text: 'اضافة شخص جديد',
                  onPressed: () => Get.toNamed(PageRouteName.ADD_NEW)),
              children: [
                dataTable(
                  columns: [
                    dataColumnItem(title: '#'),
                    dataColumnItem(title: 'الاسم'),
                    dataColumnItem(title: 'الحاله الاجتماعيه'),
                    dataColumnItem(title: 'الوظيفه'),
                    dataColumnItem(title: 'العنوان'),
                    dataColumnItem(title: 'رقم الهاتف'),
                    dataColumnItem(title: 'الحيازه'),
                    dataColumnItem(title: 'السكن'),
                    dataColumnItem(title: 'الحاله الصحيه'),
                    dataColumnItem(title: 'الاجرائات'),
                  ],
                  rows: List.generate(users!.length, (index) {
                    var item = users.elementAt(index);
                    return DataRow(
                      cells: [
                        dataCellItem(data: item.nationalId.toString()),
                        dataCellItem(data: item.name!),
                        dataCellItem(data: item.socialStatus!),
                        dataCellItem(data: item.working!),
                        dataCellItem(data: item.address!),
                        dataCellItem(data: item.phone!),
                        dataCellItem(data: item.owning!),
                        dataCellItem(data: item.housing!),
                        dataCellItem(data: item.healthStatus.toString()),
                        dataController(
                            onEditPressed: () =>
                                addEditUserForm(model: item, context: context!),
                            onRemovePressed: () {},
                            onViewPressed: () {})
                      ],
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addEditUserForm({UserEntity? model, BuildContext? context}) {
    final _formKey = GlobalKey<FormState>();
    bool isEdit = false;

    UserEntity userModel;
    print('Get.arguments => ${model}');
    if (model == null) {
      userModel = UserModel();
    } else {
      isEdit = true;
      userModel = model;
    }

    showDialog(
      context: Get.context!,
      barrierColor: Colors.grey[500]!.withOpacity(.4),
      useSafeArea: false,
      builder: (_) => AppDialog(
          height: 900,
          title: 'add_new_note'.tr,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  CustomTextField(
                    validator: TextFieldValidators.isName,
                    prefixIcon:
                        Icon(FontAwesomeIcons.user, size: APP_ICON_SIZE),
                    contentPadding: EdgeInsets.only(right: 10),
                    onChangedText: (String text) => userModel.name = text,
                    hint: 'الاسم',
                    outLineText: 'الاسم',
                    iconPathWidth: 17,
                    initialValue: userModel.name,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    validator: TextFieldValidators.isAddress,
                    contentPadding: EdgeInsets.only(right: 10),
                    prefixIcon:
                        Icon(FontAwesomeIcons.addressBook, size: APP_ICON_SIZE),
                    onChangedText: (String text) => userModel.address = text,
                    hint: 'العنوان',
                    outLineText: 'العنوان',
                    iconPathWidth: 17,
                    initialValue: model!.address,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    validator: TextFieldValidators.isPhone,
                    contentPadding: EdgeInsets.only(right: 10),
                    prefixIcon:
                        Icon(FontAwesomeIcons.addressBook, size: APP_ICON_SIZE),
                    onChangedText: (String text) => userModel.phone = text,
                    hint: 'رقم الهاتف',
                    outLineText: 'رقم الهاتف',
                    initialValue: model.phone,
                    iconPathWidth: 17,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    validator: TextFieldValidators.isNationalId,
                    contentPadding: EdgeInsets.only(right: 10),
                    prefixIcon:
                        Icon(FontAwesomeIcons.idCard, size: APP_ICON_SIZE),
                    onChangedText: (String text) => userModel.nationalId = text,
                    hint: 'الرقم القومي',
                    outLineText: 'الرقم القومي',
                    initialValue: model.name,
                    iconPathWidth: 17,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    contentPadding: EdgeInsets.only(right: 10),
                    prefixIcon:
                        Icon(FontAwesomeIcons.phone, size: APP_ICON_SIZE),
                    // borderColor: AppColor.BORDER_COLOR,
                    onChangedText: (String text) => userModel.owning = text,
                    hint: 'حيازه',
                    outLineText: 'حيازه',
                    iconPathWidth: 17,
                    initialValue: model.owning,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    contentPadding: EdgeInsets.only(right: 10),
                    prefixIcon:
                        Icon(FontAwesomeIcons.phone, size: APP_ICON_SIZE),
                    // borderColor: AppColor.BORDER_COLOR,
                    onChangedText: (String text) => userModel.housing = text,
                    hint: 'السكن',
                    outLineText: 'السكن',
                    iconPathWidth: 17,
                    initialValue: model.housing,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  DropDownWidgetX(
                    labelText: 'الحاله الاجتماعيه',
                    maxHeight: 100,
                    items: statusKeys,
                    selectedItem: statusKeys.first,
                    onChanged: (value) =>
                        userModel.socialStatus = value as String,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    validator: TextFieldValidators.isNotEmpty,
                    contentPadding: EdgeInsets.only(right: 10),
                    prefixIcon:
                        Icon(FontAwesomeIcons.phone, size: APP_ICON_SIZE),
                    onChangedText: (String text) => userModel.working = text,
                    hint: 'الوظيفه',
                    outLineText: 'الوظيفه',
                    initialValue: model.working,
                    iconPathWidth: 17,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  buildDateTimePickerField(
                    labelText: 'تاريخ الميلاد',
                    initialValue: model.birthDate,
                    firstDate: DateTime.now().year,
                    onSaved: (value) => userModel.birthDate = value,
                  ),
                  SizedBox(height: 10),
                  DropDownWidgetX(
                    maxHeight: 100,
                    labelText: 'الحالة الصحية',
                    items: healthKeys,
                    selectedItem: healthKeys.first,
                    onChanged: (value) => userModel.healthStatus = value.toString(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GenderSelector(
                    outLineText: 'النوع',
                    onChanged: (newValue) => userModel.gender = newValue,
                  ),
                ],
              ).addPaddingOnly(bottom: context!.mediaQueryPadding.bottom),
            ),
          ).addPaddingHorizontalVertical(horizontal: 16)),
    );
  }
}
