class Plan {

  String amount;
  String value;
  Plan( this.amount, this.value);

  static List<Plan> getPlan() {
    return <Plan>[
      Plan("300000", "Monthly"),
      Plan("700000", "Quarterly"),
      Plan("3600000", "Yearly")
    ];
  }
}
