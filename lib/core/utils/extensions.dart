extension DoublePrecision on double {
  double get toPrecision {
    return double.parse(this.toStringAsFixed(2));
  }
}
