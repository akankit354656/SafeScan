enum QRType {
  upiPayment,
  url,
  googleForm,
  wifi,
  email,
  phone,
  sms,
  contact,
  plainText,
}

class QRClassifier {
  static QRType classify(String content) {
    if (content.startsWith('upi://')) return QRType.upiPayment;
    if (content.startsWith('WIFI:')) return QRType.wifi;
    if (content.startsWith('mailto:')) return QRType.email;
    if (content.startsWith('tel:')) return QRType.phone;
    if (content.startsWith('smsto:') || content.startsWith('sms:')) return QRType.sms;
    if (content.startsWith('BEGIN:VCARD')) return QRType.contact;
    if (content.contains('forms.gle') || content.contains('docs.google.com/forms')) return QRType.googleForm;
    if (content.startsWith('http://') || content.startsWith('https://')) return QRType.url;
    return QRType.plainText;
  }
}