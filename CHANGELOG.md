## Master

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.3.0...master)

## 1.3.0 - Sept 12, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.2.0...v1.3.0)

### New feature

* [#82][] Adds simple notifications support in zeus mode. ([@pschyska][])

## 1.2.0 - Sept 10, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.1.0...v1.2.0)

### Improvement

* [#81][] Clears memoized test files on additions and removals. ([@pschyska][])

## 1.1.0 - Aug 19, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.0.1...v1.1.0)

### New feature

* [#77][] Allow specifying arbitrary include paths. ([@psyho][])

## 1.0.1 - Jul 23, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.0.0...v1.0.1)

### Bug fixes

* [#73][] Don't unecessary require 'minitest/autorun'. ([@jakebellacera][], [@rafmagana][] & [@rymai][])
* [#72][] Don't require `test` with `-Itest` when using DRb. ([@rafmagana][] & [@rymai][])

## 1.0.0 - Jul 10, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.0.0.rc.3...v1.0.0)

No significant changes compared to RC 3.

## 1.0.0.rc.3 - Jun 22, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.0.0.rc.2...v1.0.0.rc.3)

### Improvements

* [#70][] Use `-r minitest/autorun` instead of `-e 'Minitest.autorun'` in the runner. ([@kejadlen][])
* Refactor / simplify `Guard::Minitest::Inspector`. ([@rymai][])
* [#69][] Use `Gem::Requirement.new` to compare versions. ([@kejadlen][])
* [#68][] Remove the unused test directory. ([@kejadlen][])

## 1.0.0.rc.2 - Jun 19, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.0.0.rc.1...v1.0.0.rc.2)

### Bug fixes

* Drop the `--pride` option. Users should add `require 'minitest/pride'` to their `test_helper.rb` instead. ([@rymai][])
* Ensure `Minitest::Reporter` is used for Minitest < 5.0.4 (precisely). ([@rymai][])

## 1.0.0.rc.1 - Jun 19, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.0.0.beta.2...v1.0.0.rc.1)

### Bug fixes

* [#65][] Use `Minitest::StatisticsReporter` instead of `Minitest::Reporter` for Minitest > 5.0. ([@kejadlen][])
* [#66][] Don't use the `--pride` option for Minitest < 5.0. ([@sbl][])

## 1.0.0.beta.2 - Jun 5, 2013

[Full Changelog](https://github.com/guard/guard-minitest/compare/v1.0.0.beta1...v1.0.0.beta.2)

### Improvements

* [#62][] Add notification when `spring` is used. ([@rymai][])
* [#39][] Fix `watch` `Regex` for `lib` directory. ([@rymai][])
* [#51][] Add color using the pride Minitest plugin (`--pride` option). ([@rymai][])
* [#59][] Update spring command from test to testunit. ([@sbrink][])
* [#57][] Add support for spring. ([@aspiers][])
* [#56][] Include test directory in load path when DRb used. ([@sbleon][])
* [#54][] Add support for zeus. ([@leemhenson][])
* [#55][] Add `:all_on_start` option. ([@aflock][])
* [#41][] Simplifying the DRb version of the runner. ([@chadoh][])
* [#38][] Improve notification message formatting. ([@arronmabrey][])

## 1.0.0.beta1 - Dec 10, 2012

[Full Changelog](https://github.com/guard/guard-minitest/compare/0.5.0...v1.0.0.beta1)

### Improvements

Upgrade to match Guard 1.1 API:

* Deprecate the `:notify` option. Use Guard notification configuration instead ([via the CLI](https://github.com/guard/guard#-n--notify-option) or [via the Guardfile](https://github.com/guard/guard#notification)) ([@yannlugrin][])
* [#45][] Use `run_on_changes` method. ([@statianzo][])

###  New feature

* Add `:cli` option and deprecate `:seed` and `:verbose` options ([@yannlugrin][])

### Improvements

* [#49][] Update Guardfile template for Rails 4. ([@itzki][])
* [#43][] & [#46][] Fix README links. ([@manewitz][] & [@sometimesfood][])

## 0.5.0 - Feb 24, 2012

[Full Changelog](https://github.com/guard/guard-minitest/compare/0.4.0...0.5.0)

### Bug fixes

* Hard coded tests folders path. (Nathan Youngman)
* Watch subfolder in Guardfile template. (Wilker Lúcio, Mark Kremer)
* Notifications work with DRb. (Brian Morearty)
* Initialized constant with Ruby 1.9. (Jonas Grimfelt)

### New features

* Option to overwrite test folders and test files pattern. ([@japgolly][])

## 0.4.0 - Jun 15, 2011

[Full Changelog](https://github.com/guard/guard-minitest/compare/0.3.0...0.4.0)

### New features

* Support of MiniTest 2. ([@yannlugrin][])
* DRB support. (Oriol Gual)
* Use regexp in Guardfile Template. (Emmanuel Gomez)

### Improvement

* Need guard 0.4 ([@yannlugrin][])

## 0.3.0 - Oct 27, 2010

[Full Changelog](https://github.com/guard/guard-minitest/compare/0.2.2...0.3.0)

### Bug fixes

* All guard API action return a boolean value
* Depends on guard 0.2.2 to fix darwin watching problems

### New features

* Desktop notification can be disabled
* Bundler usage can be disabled
* Rubygems usage can be enable (only if bundler is not present or disable)

## 0.2.2 - Oct 24, 2010

[Full Changelog](https://github.com/guard/guard-minitest/compare/0.2.1...0.2.2)

### Bug fixes

* Depends on guard 0.2.1 to fix linux watching probalems
* Remove duplicate code

## 0.2.1 - Oct 22, 2010

[Full Changelog](https://github.com/guard/guard-minitest/compare/0.2.0...0.2.1)

### Bug fixes

* Don't set minitest seed option by default

### Improvement

* Tested on Ruby 1.8.6

## 0.2.0 - Oct 20, 2010

First stable release.

<!--- The following link definition list is generated by PimpMyChangelog --->
[#38]: https://github.com/guard/guard-minitest/issues/38
[#39]: https://github.com/guard/guard-minitest/issues/39
[#41]: https://github.com/guard/guard-minitest/issues/41
[#43]: https://github.com/guard/guard-minitest/issues/43
[#45]: https://github.com/guard/guard-minitest/issues/45
[#46]: https://github.com/guard/guard-minitest/issues/46
[#49]: https://github.com/guard/guard-minitest/issues/49
[#51]: https://github.com/guard/guard-minitest/issues/51
[#54]: https://github.com/guard/guard-minitest/issues/54
[#55]: https://github.com/guard/guard-minitest/issues/55
[#56]: https://github.com/guard/guard-minitest/issues/56
[#57]: https://github.com/guard/guard-minitest/issues/57
[#59]: https://github.com/guard/guard-minitest/issues/59
[#62]: https://github.com/guard/guard-minitest/issues/62
[#65]: https://github.com/guard/guard-minitest/issues/65
[#66]: https://github.com/guard/guard-minitest/issues/66
[#68]: https://github.com/guard/guard-minitest/issues/68
[#69]: https://github.com/guard/guard-minitest/issues/69
[#70]: https://github.com/guard/guard-minitest/issues/70
[#72]: https://github.com/guard/guard-minitest/issues/72
[#73]: https://github.com/guard/guard-minitest/issues/73
[#77]: https://github.com/guard/guard-minitest/issues/77
[#81]: https://github.com/guard/guard-minitest/issues/81
[#82]: https://github.com/guard/guard-minitest/issues/82
[@aflock]: https://github.com/aflock
[@arronmabrey]: https://github.com/arronmabrey
[@aspiers]: https://github.com/aspiers
[@chadoh]: https://github.com/chadoh
[@itzki]: https://github.com/itzki
[@jakebellacera]: https://github.com/jakebellacera
[@japgolly]: https://github.com/japgolly
[@kejadlen]: https://github.com/kejadlen
[@leemhenson]: https://github.com/leemhenson
[@manewitz]: https://github.com/manewitz
[@pschyska]: https://github.com/pschyska
[@psyho]: https://github.com/psyho
[@rafmagana]: https://github.com/rafmagana
[@rymai]: https://github.com/rymai
[@sbl]: https://github.com/sbl
[@sbleon]: https://github.com/sbleon
[@sbrink]: https://github.com/sbrink
[@sometimesfood]: https://github.com/sometimesfood
[@statianzo]: https://github.com/statianzo
[@yannlugrin]: https://github.com/yannlugrin
