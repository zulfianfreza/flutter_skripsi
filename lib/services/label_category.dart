class LabelCategory {
  String setLabel(
    int value,
    String category,
    int age,
  ) {
    String label = "";

    if (category == 'heartrate') {
      if (age < 1) {
        if (value < 80) {
          label = 'rendah';
        } else if (value >= 80 && value < 150) {
          label = 'normal';
        } else {
          label = 'tinggi';
        }
      } else if (age >= 1 && age < 3) {
        if (value < 80) {
          label = 'rendah';
        } else if (value >= 80 && value < 130) {
          label = 'normal';
        } else {
          label = 'tinggi';
        }
      } else if (age >= 3 && age < 5) {
        if (value < 80) {
          label = 'rendah';
        } else if (value >= 80 && value < 120) {
          label = 'normal';
        } else {
          label = 'tinggi';
        }
      } else if (age >= 5 && age < 7) {
        if (value < 75) {
          label = 'rendah';
        } else if (value >= 75 && value < 115) {
          label = 'normal';
        } else {
          label = 'tinggi';
        }
      } else if (age >= 7 && age < 10) {
        if (value < 70) {
          label = 'rendah';
        } else if (value >= 70 && value < 110) {
          label = 'normal';
        } else {
          label = 'tinggi';
        }
      } else if (age >= 10) {
        if (value < 60) {
          label = 'rendah';
        } else if (value >= 60 && value < 100) {
          label = 'normal';
        } else {
          label = 'tinggi';
        }
      }
    } else if (category == 'bloodoxygen') {
      if (value < 95) {
        label = 'rendah';
      } else {
        label = 'normal';
      }
    }

    return label;
  }
}
