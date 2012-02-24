## 1.0.0 (next major release)

Upgrade to match Guard 1.0 API:

 * Deprecate `:notify` option, use guard notification configuration (Yann
   Lugrin)

Features:

 * Add `:cli` option and deprecate `:seed` and `:verbose` options (Yann
   Lugrin)

## 0.5.0 (Feb 24, 2012)

Bug Fixes:

 * Hard coded tests folders path (Nathan Youngman)
 * Watch subfolder in Guardfile template (Wilker Lúcio, Mark Kremer)
 * Notification work with DRB (Brian Morearty)
 * Initialized constant with ruby 1.9 (Jonas Grimfelt)

Features:

 * Option to overwrite test folders and test files pattern (japgolly)

## 0.4.0 (Jun 15, 2011)

Features:

 * Support of MiniTest 2 (Yann Lugrin)
 * DRB support (Oriol Gual)
 * Use regexp in Guardfile Template (Emmanuel Gomez)

Dependencies:

 * Need guard 0.4 (Yann Lugrin)

## 0.3.0 (Oct 27, 2010)

Bug Fixes:

 * All guard API action return a boolean value
 * Depends on guard 0.2.2 to fix darwin watching problems

Features:

 * Desktop notification can be disabled
 * Bundler usage can be disabled
 * Rubygems usage can be enable (only if bundler is not present or disable)

## 0.2.2 (Oct 24, 2010)

Bug Fixes:

 * Depends on guard 0.2.1 to fix linux watching probalems
 * Remove duplicate code

## 0.2.1 (Oct 22, 2010)

Bug Fixes:

 * Don't set minitest seed option by default

Documentation:

 * Tested on ruby 1.8.6

## 0.2.0 (Oct 20, 2010)

First stable release

