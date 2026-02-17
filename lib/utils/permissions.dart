class PermissionStructure {
  final String name;
  final String value;
  const PermissionStructure({required this.name, required this.value});
}

class UserPermissions {
  static const List<PermissionStructure> permissions = [
    PermissionStructure(name: "Add Inventory Items", value: "inventory-add"),
    PermissionStructure(
      name: "Add/Approve Inventory Items",
      value: "inventory-*",
    ),
    PermissionStructure(name: "Add/Update/Delete products", value: "product"),
    PermissionStructure(
      name: "Add/Update/Delete categories",
      value: "categories",
    ),
    PermissionStructure(
      name: "Add/Update/Delete Employees",
      value: "employement",
    ),
    PermissionStructure(name: "Add/Update/Delete Suppliers", value: "supplier"),
    PermissionStructure(name: "View Admin Statistics", value: "statistics"),
    PermissionStructure(name: "Add/Update/Delete company", value: "company"),
    PermissionStructure(
      name: "Add/Update/Delete modifiers",
      value: "modifiers",
    ),
    PermissionStructure(
      name: "Add/Update/Delete discounts",
      value: "discounts",
    ),
    PermissionStructure(name: "Add Expenses", value: "expense-add"),
    PermissionStructure(
      name: "Approve Expenses/Reject",
      value: "expense-approve",
    ),
    PermissionStructure(name: "Delete Customers", value: "customer-*"),
    PermissionStructure(name: "Have Cashier Capabilites", value: "cashier"),
    PermissionStructure(name: "Payment Integrations", value: "payment"),
    PermissionStructure(name: "Add/Remove and manage taxes", value: "tax"),
    PermissionStructure(name: "Subscribe to paid plans", value: "subscribe"),
  ];
}
