# Tarcom ProGuard/R8 rules.
# Flutter plugins (connectivity_plus, get_storage, android_intent_plus,
# path_provider, etc.) ship their own consumer ProGuard rules inside their
# AAR packages, which Gradle merges automatically — no keep-rules needed
# for them here.
#
# If a release-only crash occurs (ClassNotFoundException / NoSuchMethodError),
# add a keep rule for the offending class/package above and rebuild.
