class Inventory {
  static const purchaseOrderStatus = [
    {"label": "All", "value": ""},
    {"label": "Drafts", "value": "draft"},
    {"label": "Pending", "value": "pending"},
    {"label": "In Process", "value": "partial-received"},
    {"label": "Declined", "value": "declined"},
    {"label": "Accepted", "value": "accepted"},
  ];
  static const adjustStockReasons = [
    {"label": "Receive Items", "value": "add"},
    {"label": "Inventory Count", "value": "count"},
    {"label": "Loss", "value": "loss"},
    {"label": "Damaged", "value": "damaged"},
  ];
  static const inventoryCountStatus = [
    {"label": "All", "value": ""},
    {"label": "Pending", "value": "pending"},
    {"label": "Accepted", "value": "completed"},
  ];
}
