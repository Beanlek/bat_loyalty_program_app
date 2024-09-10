class Regex {
  static const REGEX_PHONE = r'^(?:[+]6)?0(([0-9]{2,3}((\s[0-9]{3,4}\s[0-9]{4})|(-[0-9]{3,4}\s[0-9]{4})|(-[0-9]{7,8})))|([0-9]{9,10}))$';
  // malaysian phone no, 01112341234 @ 601112341234

  static const REGEX_EMAIL = r'\w+@\w+\.\w+';
  // standard email, imran@gmail.com

  static const REGEX_USERNAME = r'^[a-zA-Z]+[a-zA-Z0-9]*$';
  // starts with a letter

  static const REGEX_NAME = r'^([^0-9]*)$';
  // also used for city and state // text only

  static const REGEX_ADDRESS = r'^.*';
  // allow all

  static const REGEX_PASSWORD = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  // 1 lowercase 1 special 1 digit

  static const REGEX_POSTCODE = r'^[0-9]{5}$';
  // 5 integer only

  static const REGEX_SECURITY_IMAGE = r'^assets/security_images/SIMG-\d{4}\.jpg$';
  // SIMG-<any number>
}