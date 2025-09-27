import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:wellwait_app/admin/registration/salonRegistrationViewModel.dart';
import 'package:wellwait_app/admin/salon_detail/solon_detail_viewmodel.dart';
import '../../utils/app_strings.dart';
import '../registration/salon_detail_page.dart';
import '../registration/salon_documents_page.dart';
import '../registration/salon_information_page.dart';
import '../registration/salon_service_page.dart';

class StepperNavBar extends StatefulWidget {
  bool isGoogleAuth;
  String email;

  StepperNavBar({super.key, required this.isGoogleAuth, this.email = ""});

  @override
  _StepperNavBarState createState() => _StepperNavBarState();
}

class _StepperNavBarState extends State<StepperNavBar> {
  int _selectedIndex = 0;
  bool _isTimelineInteractive = true;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    Provider.of<SolonRegistrationViewModel>(context, listen: false).initValues(
      widget.isGoogleAuth,
      widget.email,
    );
    _pages = [
      // SalonServicePage(
      //   onNext: () => goToNextStep(3),
      //   onBack: () => goToPreviousStep(),
      // ),
      SalonDetailPage(
        onNext: () => goToNextStep(1),
        salonDetailEdit: false,
        //onBack: () => goToPreviousStep(),
      ),
      SalonInformationPage(
        onNext: () => goToNextStep(2),
        onBack: () => goToPreviousStep(),
        salonInfoEdit: false,
      ),
      SalonServicePage(
        onNext: () => goToNextStep(3),
        onBack: () => goToPreviousStep(),
        salonServiceEdit: false,
      ),
      SalonDocumentsPage(
        onBack: () => goToPreviousStep(),
        salonDocumentEdit: false,
      ), // Last step has no "Next" button
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Timeline navigation bar
          Container(
            height: 100,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                // Horizontal scrollable timeline
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: _isTimelineInteractive && _selectedIndex >= index
                            ? () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              }
                            : null, // Disable tap if not interactive
                        child: TimelineTile(
                          axis: TimelineAxis.horizontal,
                          isFirst: index == 0,
                          isLast: index == 3,
                          beforeLineStyle: LineStyle(
                            color: _selectedIndex > index
                                ? Colors.teal
                                : Colors.grey,
                            thickness: 2,
                          ),
                          afterLineStyle: LineStyle(
                            color: _selectedIndex > index
                                ? Colors.teal
                                : Colors.grey,
                            thickness: 2,
                          ),
                          indicatorStyle: IndicatorStyle(
                            width: 24,
                            height: 24,
                            indicator: _buildStepCircle(index),
                          ),
                          alignment: TimelineAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                // Step labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          _getLabelForIndex(index),
                          style: TextStyle(
                            color: _selectedIndex == index
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: _selectedIndex == index
                                ? FontWeight.w500
                                : FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          // Display the selected page content
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  // Function to go to the next step and mark previous step as completed
  void goToNextStep(int nextIndex) {
    setState(() {
      _selectedIndex = nextIndex;
      if (_selectedIndex == _pages.length - 1) {
        _isTimelineInteractive = false; // Disable interactions after last step
      }
    });
  }

  void goToPreviousStep() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex--;
      });
    }
  }

  // Widget to build a step circle with a check mark for completed steps
  Widget _buildStepCircle(int index) {
    bool isCompleted =
        _selectedIndex > index; // Step is completed if current index is greater
    bool isSelected = _selectedIndex == index; // Current step is highlighted

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: isCompleted || isSelected ? Colors.teal : Colors.grey,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.teal : Colors.grey,
                ),
                child: Icon(Icons.check,
                    color: isCompleted ? Colors.white : Colors.transparent,
                    size: 16))
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.teal : Colors.grey,
                ),
                width: 18,
                height: 18,
              ),
      ),
    );
  }

  // Get label for each step
  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return AppString.salonDetails;
      case 1:
        return AppString.salonInformation;
      case 2:
        return AppString.salonServices;
      case 3:
        return AppString.salonDocuments;
      default:
        return '';
    }
  }
}
