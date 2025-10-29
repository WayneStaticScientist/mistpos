class Inventory {
  static const purchaseOrderStatus = [
    {"label": "All", "value": ""},
    {"label": "Drafts", "value": "draft"},
    {"label": "Pending", "value": "pending"},
    {"label": "Declined", "value": "declined"},
    {"label": "Accepted", "value": "accepted"},
  ];
  static const adjustStockReasons = [
    {"label": "Receive Items", "value": "add"},
    {"label": "Inventory Count", "value": "count"},
    {"label": "Loss", "value": "loss"},
    {"label": "Damaged", "value": "damaged"},
  ];
}
