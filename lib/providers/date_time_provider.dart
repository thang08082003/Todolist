import "package:riverpod/riverpod.dart";

final StateProvider<String> dateProvider = StateProvider<String>(
  (Ref ref) => "mm/dd/yyyy",
);

final StateProvider<String> timeProvider = StateProvider<String>(
  (Ref ref) => "hh : mm",
);
