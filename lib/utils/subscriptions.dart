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
}
