import 'package:flutter/cupertino.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import '../../models/count.dart';
import '../../models/panel.dart';
import '../../services/services.dart';
import '../../utils/common_variables.dart';
import '../../widget/snack_bar_widget.dart';

class ServiceProviderPanelsViewModels extends ChangeNotifier {
  List<Panel> panels = [];
  bool isLoading = false;

  //int? selectedPanelId;

  final ApiService apiService = ApiService();

  Future<void> fetchPanels() async {
    isLoading = true;
    notifyListeners();

    try {
      panels = await apiService.fetchPanels(adminServiceProviderId);

      if (panels.isNotEmpty) {
        panelId = panels.first.id; // Store first panel ID
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching panels: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setPanelStatus(Panel panel, int status) async {
    try {
      if (panel.id != null) {
        if (await apiService.setPanelStatus(panel.id!, status)) {
          fetchPanels();
        }
      }
    } catch (e) {
      print("Error fetching panels: $e");
    }
  }

  Future<void> deletePanel(int panelId,int count) async {
    isLoading = true;
    notifyListeners();
    try {
      bool success = await apiService.deletePanel(panelId);
      if (success) {
        CustomSnackBar.showSnackBar("Panel ${count} deleted successfully!");
      }
    } catch (e) {
      CustomSnackBar.showSnackBar("catch Error: ${e}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookingCount() async {
    try {
      for (var p in panels) {
        Count count = await apiService.getBookingCount(p.id!);
        p.queueCount = count.count;
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching booking count: $e");
      throw Exception('Failed to fetch booking count');
    }
  }

  void setSelectedPanelId(int adminPanelId) {
    panelId = adminPanelId;
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}
