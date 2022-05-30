bool isValidPhoneNumber(String val) {
  // RegExp regExp = new RegExp(
  //   r'^((?:[+?0?0?966]+)(?:\s?\d{2})(?:\s?\d{7}))$',
  //   caseSensitive: false,
  //   multiLine: false,
  // );
  // return regExp.hasMatch(val);
  //todo handle again

  if (val.length < 9)
    return false;
  else
    return true;
}

String getDelivertMethod(String deliveryMethod) {
  switch (deliveryMethod) {
    case 'delivery':
      return 'Delivery';
    case 'pick_up':
      return 'Pick up';
    default:
      return deliveryMethod;
  }
}
