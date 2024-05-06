class CacheSettings {
  final String secret;
  final String cachePrefix = "shararaCacheSystemIndexer";
  CacheSettings({required this.secret});

  /// its not recommended to use basic factory unless your debugging your app"
  ///
 ///       " for more security use your custom secret
  factory CacheSettings.basic()=>
      CacheSettings(secret:"_gpoShararaInserter==RustEncodeBuilder&2h3k-afe0#irqpgkrm==");
}


