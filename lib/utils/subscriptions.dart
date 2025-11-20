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
  ];
}
