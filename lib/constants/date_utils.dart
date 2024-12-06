List<String> translateMonthYearList(List inputList) {
  // Map of English months to Uzbek months
  final Map<String, String> monthTranslations = {
    'January': 'Yanvar',
    'February': 'Fevral',
    'March': 'Mart',
    'April': 'Aprel',
    'May': 'May',
    'June': 'Iyun',
    'July': 'Iyul',
    'August': 'Avgust',
    'September': 'Sentabr',
    'October': 'Oktabr',
    'November': 'Noyabr',
    'December': 'Dekabr',
  };

  // Iterate over the input list and translate the month part
  return inputList.map((item) {
    // Split the item into month and year
    List<String> parts = item.split(', '); // ['September', '2022']

    // Translate the month part
    String translatedMonth = monthTranslations[parts[0]] ?? parts[0];

    // Return the translated month with the year
    return '$translatedMonth';
  }).toList();
}