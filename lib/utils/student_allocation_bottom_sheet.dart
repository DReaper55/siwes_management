import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/student.dart';

studentAllocationBottomSheet(context, List<Student> listOfStudents) {
  bool isAppBarExpanded = false;
  final searchFocusField = FocusNode();
  bool isClearFieldButtonVisible = false;

  final searchCtrl = TextEditingController();

  List<Student> selectedStudents = [];

  return StatefulBuilder(builder: (context, myState) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 3.0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: !isAppBarExpanded
              ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back))
              : const SizedBox(),
          leadingWidth: isAppBarExpanded ? 0.0 : 50.0,
          actions: [
            if (!isAppBarExpanded)
              IconButton(
                  onPressed: () => Navigator.of(context).pop([...selectedStudents]),
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                  )),
          ],
          title: Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0)),
            child: StatefulBuilder(
              builder: (ctx, textState) => TextFormField(
                controller: searchCtrl,
                focusNode: searchFocusField,
                style: const TextStyle(fontSize: 18.0),
                textInputAction: TextInputAction.search,
                onTap: () {
                  textState(() {
                    isAppBarExpanded = true;
                  });
                },
                onFieldSubmitted: (value) {
                  textState(() {
                    isAppBarExpanded = false;
                    searchFocusField.unfocus();
                  });
                },
                onChanged: (value) {
                  if (value.isNotEmpty && !isClearFieldButtonVisible) {
                    myState(() {
                      isClearFieldButtonVisible = true;
                    });
                  } else if (value.isEmpty &&
                      isClearFieldButtonVisible) {
                    textState(() {
                      isClearFieldButtonVisible = false;
                    });
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchCtrl.text = "";

                        textState(() {

                        });
                      },
                      splashRadius: 25.0,
                      icon: isClearFieldButtonVisible
                          ? const Icon(Icons.close)
                          : const SizedBox(),
                    ),
                    hintText: "Search inventory...",
                    hintStyle: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 15.0),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          // constraints: const BoxConstraints(maxHeight: 550.0),
          child: Column(
            children: [
              StatefulBuilder(
                builder: (ctx, bodyState) => Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0),
                  height: 400.0,
                  child: ListView.separated(
                      controller: ModalScrollController.of(context),
                      scrollDirection: Axis.vertical,
                      itemCount: listOfStudents.length,
                      separatorBuilder: (ctx, i) => const Divider(indent: 30.0,),
                      itemBuilder: (context, index) {

                        Student student = listOfStudents[index];

                        return ListTile(
                          title: Text(student.fullName!),
                          subtitle: Text(student.matricNumber!),
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: (){
                              if(student.displayImagePath != null){
                                return FileImage(File(student.displayImagePath!));
                              }
                            }(),
                            child: (){
                              String initials = '';

                              if(student.displayImagePath == null){
                                if(student.fullName!.contains(' ')){
                                  String first = student.fullName!.split(' ')[0][0];
                                  String second = student.fullName!.split(' ')[1][0];

                                  initials = '$first $second';
                                }
                              }

                              return Text(initials);

                            }(),
                          ),
                          trailing: Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                                color:
                                student.isSelected
                                    ? Colors.lightBlue
                                    : Colors.transparent,
                                borderRadius:
                                BorderRadius.circular(
                                    50.0),
                                border: Border.all(
                                    color:
                                    student.isSelected
                                        ? Colors
                                        .transparent
                                        : Colors.lightBlue)),
                            child:student.isSelected
                                ? const Icon(Icons.check,
                                color: Colors.white,
                                size: 15.0)
                                : const SizedBox(),
                          ),
                          onTap: () {
                            listOfStudents[index].isSelected = !listOfStudents[index].isSelected;

                            if(listOfStudents[index].isSelected){
                              selectedStudents.add(student);
                            } else {
                              selectedStudents.removeWhere((element) => element.matricNumber == student.matricNumber);
                            }

                            bodyState((){});
                          },
                        );
                      }),
                ),
              ),
            ],
          ),
        ));
  });
}