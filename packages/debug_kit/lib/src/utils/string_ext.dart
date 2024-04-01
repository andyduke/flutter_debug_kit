extension StringUtils on String {
  containsInsensitive(String other) => toLowerCase().contains(other.toLowerCase());
}
