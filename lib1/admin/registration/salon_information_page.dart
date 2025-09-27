import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/salon_information/salon_information_viewmodel.dart';
import 'package:wellwait_app/widget/snack_bar_widget.dart';
import '../../models/salon_timing.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../widget/custom_button.dart';
import '../admin_email_login/admin_email_login_viewmodel.dart';
import '../utils/admin_ common_variable.dart';
import '../widget/app_bar.dart';

class SalonInformationPage extends StatefulWidget {
  final Function()? onNext;
  final Function()? onBack;
  final bool salonInfoEdit;

  const SalonInformationPage(
      {super.key, this.onNext, this.onBack, required this.salonInfoEdit});

  @override
  State<SalonInformationPage> createState() => _SalonInformationPageState();
}

class _SalonInformationPageState extends State<SalonInformationPage> {
  late SalonInformationViewModel _viewModel;
  late AdminEmailLoginViewModel _adminEmailLoginViewModel;
  int? timingId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateInfo();
    });
  }

  updateInfo() {
    if (widget.salonInfoEdit) {
      print("Fetching salon timings for ID: $adminServiceProviderId");
      _viewModel.fetchSalonTimings(adminServiceProviderId.toString()).then((_) {
        print("Fetch completed, checking salon timings...");

        if (_viewModel.serviceProviderTimings != null &&
            _viewModel.serviceProviderTimings!.isNotEmpty) {
          final timings = _viewModel.serviceProviderTimings!;
          print("Fetched Salon Timings: $timings");

          timingId = timings.first.id;
          print("Stored timingId: $timingId");

          // Reset all checkbox states
          _viewModel.checkboxStates =
              List.filled(_viewModel.days.length, false);

          // Update checkboxes for working days
          for (var timing in timings) {
            final dayIndex = _viewModel.days.indexOf(timing.day.toString());
            if (dayIndex != -1) {
              _viewModel.checkboxStates[dayIndex] =
                  true; // Mark day as selected
            }
          }

          // Assign timing values from the first available timing
          _viewModel.openingTime = _parseTime(timings.first.startTime);
          _viewModel.closingTime = _parseTime(timings.first.endTime);
          _viewModel.lunchStartTime = _parseTime(timings.first.lunchStart);
          _viewModel.lunchEndTime = _parseTime(timings.first.lunchEnd);

          // Collect selected days as a comma-separated string
          List<String> selectedDays = _viewModel.days
              .asMap()
              .entries
              .where((entry) => _viewModel.checkboxStates[entry.key])
              .map((entry) => entry.value)
              .toList();

          if (selectedDays.isNotEmpty) {
            // Call updateTiming() once with the formatted selectedDays
            _viewModel
                .updateTiming(
              adminServiceProviderId,
              selectedDays,
              _viewModel.openingTime!,
              _viewModel.closingTime!,
              _viewModel.lunchStartTime,
              _viewModel.lunchEndTime,
            )
                .then((response) {
              if (response.containsKey('error') && response['error'] == true) {
                print('Error: ${response['message']}');
              } else {
                print(
                    'Success: Salon timings updated successfully for $selectedDays');
              }
            }).catchError((error) {
              print('Error updating salon timings: $error');
            });
          } else {
            print("No days selected, skipping updateTiming()");
          }
        } else {
          print("Error: Salon timings data is null or empty");
        }
        setState(() {}); // Ensure UI updates
      }).catchError((error) {
        print("Failed to fetch salon timings: $error");
      });
    } else {
      print("salonInfoEdit is false, clearing all fields...");
      timingId = null;
      _viewModel.openingTime = null;
      _viewModel.closingTime = null;
      _viewModel.lunchStartTime = null;
      _viewModel.lunchEndTime = null;
      // Reset checkbox states
      _viewModel.checkboxStates = List.filled(_viewModel.days.length, false);
      setState(() {});
    }
  }

  /// Converts a time string (HH:mm) into TimeOfDay
  TimeOfDay? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    try {
      final parts = time.split(":");
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      print("Error parsing time: $time - $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<SalonInformationViewModel>();
    _adminEmailLoginViewModel =
        Provider.of<AdminEmailLoginViewModel>(context, listen: false);
    return Scaffold(
      appBar: (widget.salonInfoEdit == true)
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(bgColor: Colors.white, showHomeButton: true),
            )
          : null,
      body: Column(
        children: [
          SizedBox(height: (widget.salonInfoEdit == true) ? 0 : 30),
          (widget.salonInfoEdit == true)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset(
                              "assets/icons/back_icon.svg",
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              adminSalonName,
                              style: AppTextStyle.getTextStyle14FontWeightw600G,
                            ),
                            Text(AppString.settingsOperatingSchedule,
                                style: AppTextStyle
                                    .getTextStyle18FontWeightw600FabricColor),
                          ],
                        ),
                      ),
                      Container(),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    AppString.operatingSchedule,
                    style: AppTextStyle.getTextStyle18FontWeightw600FabricColor,
                  ),
                ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black54,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 16),
                                    decoration: BoxDecoration(
                                      color: Color(0xffD5ECEC),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        // Circular border for top-right
                                        bottomRight: Radius.circular(
                                            20), // Circular border for bottom-right
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4, left: 8, right: 8),
                                      child: Text(
                                        AppString.workingDays,
                                        style: AppTextStyle
                                            .getTextStyle16FontWeightBold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Call a method in your view model to toggle all checkboxes
                                      _viewModel.toggleSelectAll();
                                      setState(
                                          () {}); // Trigger UI rebuild to reflect the changes
                                    },
                                    child: Text(
                                      _viewModel.isAllSelected
                                          ? AppString
                                              .selectAll // Change text dynamically
                                          : AppString.selectAll,
                                      // Original text
                                      style: AppTextStyle
                                          .getTextStyle15FontWeightw300FabricColor,
                                    ),
                                  ),
                                ],
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5,
                                ),
                                itemCount: _viewModel.checkboxStates.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Checkbox(
                                        activeColor: fabricColor,
                                        value: _viewModel.checkboxStates[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _viewModel.checkboxStates[index] =
                                                value ?? false;
                                          });
                                          print(
                                              _viewModel.checkboxStates[index]);
                                        },
                                      ),
                                      Text(
                                        _viewModel.days[index],
                                        style: AppTextStyle
                                            .getTextStyle16FontWeightw400Black,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          AppString.openingClosingTime,
                          style: AppTextStyle.getTextStyle20FontWeightBold,
                        ),
                        const SizedBox(height: 14),
                        checkBox(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            timePickerContainer(
                                AppString.openingTime, _viewModel.openingTime,
                                (time) {
                              setState(() {
                                _viewModel.openingTime = time;
                              });
                            }),
                            timePickerContainer(
                                AppString.closingTime, _viewModel.closingTime,
                                (time) {
                              setState(() {
                                _viewModel.closingTime = time;
                              });
                            }),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppString.lunchTime,
                          style: AppTextStyle.getTextStyle20FontWeightBold,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            timePickerContainer(AppString.openingTime,
                                _viewModel.lunchStartTime, (time) {
                              setState(() {
                                _viewModel.lunchStartTime = time;
                              });
                            }),
                            timePickerContainer(
                                AppString.closingTime, _viewModel.lunchEndTime,
                                (time) {
                              setState(() {
                                _viewModel.lunchEndTime = time;
                              });
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: widget.salonInfoEdit == true
                ? Container(
                    width: double.infinity,
                    child: CustomButtonWidget(
                      text: AppString.saveChanges,
                      textColor: Colors.white,
                      onPressed: () async {
                        List<String> selectedDays = [];
                        for (int i = 0;
                            i < _viewModel.checkboxStates.length;
                            i++) {
                          if (_viewModel.checkboxStates[i]) {
                            selectedDays.add(_viewModel.days[i]);
                          }
                        }

                        if (selectedDays.isEmpty) {
                          CustomSnackBar.showSnackBar(
                              'Select at least one day');
                          return;
                        }

                        if (_viewModel.openingTime == null ||
                            _viewModel.closingTime == null) {
                          CustomSnackBar.showSnackBar(
                              'Opening and/or closing time not set.');
                          return;
                        }

                        if (_viewModel.lunchStartTime == null ||
                            _viewModel.lunchEndTime == null) {
                          CustomSnackBar.showSnackBar('Please add lunch time');
                          return;
                        }

                        print("Selected Days: $selectedDays");

                        bool hasError = false;

                        final response = await _viewModel.updateTiming(
                          adminServiceProviderId,
                          selectedDays,
                          _viewModel.openingTime!,
                          _viewModel.closingTime!,
                          _viewModel.lunchStartTime,
                          _viewModel.lunchEndTime,
                        );

                        if (response.containsKey('error') &&
                            response['error'] == true) {
                          hasError = true;
                        }

                        if (!hasError) {
                          Get.back();
                          CustomSnackBar.showSnackBar(
                              "Success: Salon timing updated successfully!");
                        }
                      },
                      buttonColor: fabricColor,
                      borderRadius: 5,
                      buttonHeight: 40,
                      buttonWidth: 1,
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          text: AppString.backButton,
                          textColor: Colors.black,
                          onPressed: () {
                            widget.onBack?.call();
                          },
                          buttonColor: Colors.white,
                          borderRadius: 5,
                          buttonHeight: 40,
                          borderColor: Colors.black54,
                          buttonWidth: 1,
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: CustomButtonWidget(
                          text: AppString.nextButton,
                          textColor: Colors.white,
                          onPressed: () {
                            List<String> selectedDays = [];
                            for (int i = 0;
                                i < _viewModel.checkboxStates.length;
                                i++) {
                              if (_viewModel.checkboxStates[i]) {
                                selectedDays.add(_viewModel.days[i]);
                              }
                            }

                            if (selectedDays.isEmpty) {
                              CustomSnackBar.showSnackBar(
                                  'Select at least one day');
                              return;
                            }

                            if (_viewModel.openingTime == null ||
                                _viewModel.closingTime == null) {
                              CustomSnackBar.showSnackBar(
                                  'Opening and/or closing time not set.');
                              return;
                            }

                            if (_viewModel.lunchStartTime == null ||
                                _viewModel.lunchEndTime == null) {
                              CustomSnackBar.showSnackBar(
                                  'Please add lunch time');
                              return;
                            }

                            _viewModel.updateTiming(
                              adminServiceProviderId,
                              selectedDays,
                              _viewModel.openingTime!,
                              _viewModel.closingTime!,
                              _viewModel.lunchStartTime,
                              _viewModel.lunchEndTime,
                            );

                            widget.onNext?.call();
                          },
                          buttonColor: fabricColor,
                          borderRadius: 5,
                          buttonHeight: 40,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget timePickerContainer(
      String title, TimeOfDay? time, ValueChanged<TimeOfDay?> onTimeChanged) {
    return GestureDetector(
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (selectedTime != null) {
          onTimeChanged(selectedTime);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54, width: 1),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: fabricColor),
            const SizedBox(width: 8),
            Text(
              time != null ? time.format(context) : AppString.selectTime,
              style: AppTextStyle.getTextStyle16FontWeightw400Black,
            ),
          ],
        ),
      ),
    );
  }

  checkBox() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _viewModel.firstAdditionalCheckboxSelected =
                      !_viewModel.firstAdditionalCheckboxSelected;
                  if (_viewModel.firstAdditionalCheckboxSelected) {
                    _viewModel.secondAdditionalCheckboxSelected = false;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _viewModel.firstAdditionalCheckboxSelected
                      ? fabricColor
                      : Colors.transparent,
                  border: Border.all(color: Colors.black54, width: 2),
                ),
                width: 24,
                height: 24,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppString.openAndCloseMySalon,
                style: AppTextStyle.getTextStyle14FontWeightw400Black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _viewModel.secondAdditionalCheckboxSelected =
                      !_viewModel.secondAdditionalCheckboxSelected;
                  if (_viewModel.secondAdditionalCheckboxSelected) {
                    _viewModel.firstAdditionalCheckboxSelected =
                        false; // Deselect the other checkbox
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _viewModel.secondAdditionalCheckboxSelected
                      ? fabricColor
                      : Colors.transparent,
                  border: Border.all(color: Colors.black54, width: 2),
                ),
                width: 24,
                height: 24,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppString.separate,
                style: AppTextStyle.getTextStyle14FontWeightw400Black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
