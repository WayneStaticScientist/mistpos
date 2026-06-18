class MistTwinSub {
  String key;
  List<String> plans;
  MistTwinSub({required this.key, required this.plans});
}

class MistSubscriptionUtils {
  static const List<String> availablePlans = [
    "trial",
    "free",
    "basic",
    "pro",
    "enterprise",
  ];
  static const List<double> planPrices = [
    0.0, // trial
    0.0, // free
    5.0, // basic
    10.0, // pro
    15.0, // enterprise
  ];
  static const String freePlan = "free";
  static const String basicPlan = "basic";
  static const String proPlan = "pro";
  static const String enterprisePlan = "enterprise";
  static const String trialPlan = "trial";
  static const basicList = ['trial', 'pro', 'enterprise', 'basic'];
  static const proList = ['trial', 'pro', 'enterprise'];
  static const enterpriseList = ['trial', 'enterprise'];

  /// Returns true if [currentPlan] has access to [navKey].
  /// Items not in twinSubs are accessible to everyone.
  static bool hasAccessTo(String navKey, String currentPlan) {
    final sub = twinSubs.firstWhere(
      (e) => e.key == navKey,
      orElse: () => MistTwinSub(key: navKey, plans: availablePlans.toList()),
    );
    return sub.plans.contains(currentPlan);
  }

  /// Returns the minimum plan name required for [navKey], or null if free.
  static String? getRequiredPlanLabel(String navKey) {
    final sub = twinSubs.firstWhere(
      (e) => e.key == navKey,
      orElse: () => MistTwinSub(key: navKey, plans: availablePlans.toList()),
    );
    // Plan hierarchy order (ascending cost): free < basic < pro < enterprise
    const hierarchy = ['free', 'basic', 'pro', 'enterprise'];
    for (final plan in hierarchy) {
      if (sub.plans.contains(plan)) {
        return getPlanDisplayName(plan);
      }
    }
    return null;
  }
  static String getPlanDisplayName(String plan) {
    switch (plan) {
      case 'free':
        return 'Free Plan';
      case 'basic':
        return 'Basic Plan';
      case 'pro':
        return 'Pro Plan';
      case 'enterprise':
        return 'Enterprise Plan';
      default:
        return 'Unknown Plan';
    }
  }

  static List<MistTwinSub> twinSubs = [
    MistTwinSub(
      key: 'Employees',
      plans: ['basic', 'pro', 'enterprise', 'trial'],
    ),
    MistTwinSub(
      key: "Customers",
      plans: ['basic', 'pro', 'enterprise', 'trial', 'free'],
    ),
    MistTwinSub(key: "Stores", plans: ['basic', 'pro', 'enterprise', 'trial']),
    MistTwinSub(key: "Transfer Orders", plans: ['pro', 'enterprise', 'trial']),
    MistTwinSub(key: "Productions", plans: ['enterprise', 'trial']),
    MistTwinSub(key: "Inventory Counts", plans: ['enterprise', 'trial', 'pro']),
    MistTwinSub(key: "Suppliers", plans: ['pro', 'enterprise', 'trial']),
    MistTwinSub(key: "Purchase Orders", plans: ['pro', 'enterprise', 'trial']),
    MistTwinSub(
      key: "Stock Adjustments",
      plans: ['enterprise', 'trial', 'pro'],
    ),
    MistTwinSub(
      key: "Monthly Reports",
      plans: ['trial', 'pro', 'enterprise'],
    ),
    MistTwinSub(
      key: "Yearly Reports",
      plans: ['trial', 'pro', 'enterprise'],
    ),
    MistTwinSub(
      key: "Inventory History",
      plans: ['trial', 'pro', 'enterprise'],
    ),
    MistTwinSub(
      key: "Inventory Valuation",
      plans: ['trial', 'pro', 'enterprise'],
    ),
  ];
}
