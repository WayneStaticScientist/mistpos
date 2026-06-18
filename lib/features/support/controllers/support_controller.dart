import 'package:get/get.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';

class SupportController extends GetxController {
  final tickets = [].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  bool get canAccessSupport {
    return true;
  }

  Future<void> fetchTickets() async {
    if (!canAccessSupport) return;
    isLoading.value = true;
    try {
      final response = await Net.get('/support/tickets');
      if (!response.hasError) {
        tickets.value = response.body;
      }
    } catch (e) {
      Toaster.showError("Failed to fetch tickets");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTicket(String subject, String message) async {
    if (!canAccessSupport) {
      Toaster.showError("Support tickets are not available on the Free plan.");
      return false;
    }
    if (subject.isEmpty || message.isEmpty) {
      Toaster.showError("Subject and message are required");
      return false;
    }

    isSubmitting.value = true;
    try {
      final response = await Net.post(
        '/support/tickets',
        data: {"subject": subject, "message": message},
      );

      if (!response.hasError) {
        Toaster.showSuccess("Ticket created successfully");
        await fetchTickets();
        return true;
      } else {
        Toaster.showError(response.response ?? "Failed to create ticket");
        return false;
      }
    } catch (e) {
      Toaster.showError("An error occurred");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> replyToTicket(String ticketId, String message) async {
    if (message.isEmpty) return false;

    isSubmitting.value = true;
    try {
      final response = await Net.post(
        '/support/tickets/$ticketId/reply',
        data: {"message": message},
      );

      if (!response.hasError) {
        Toaster.showSuccess("Reply sent");
        await fetchTickets();
        return true;
      } else {
        Toaster.showError(response.response ?? "Failed to send reply");
        return false;
      }
    } catch (e) {
      Toaster.showError("An error occurred");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
