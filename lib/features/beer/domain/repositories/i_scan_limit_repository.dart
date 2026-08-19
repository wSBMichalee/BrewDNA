abstract class IScanLimitRepository {
  /// Sprawdza ile skanów pozostało w obecnym cyklu rozliczeniowym (dla kont Free limit to 5)
  Future<int> getRemainingScans(String userId);

  /// Zwiększa licznik skanów o 1, wykonując leniwy reset jeśli minął miesiąc
  Future<void> incrementScanCount(String userId);
}
