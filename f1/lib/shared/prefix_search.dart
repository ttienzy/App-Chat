List<String> generateKeywords(String input) {
  input = input.toLowerCase().trim();
  List<String> keywords = [];
  for (int i = 1; i <= input.length; i++) {
    keywords.add(input.substring(0, i));
  }
  return keywords;
}
