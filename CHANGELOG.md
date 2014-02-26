## 2014-02-26 Release 1.0.0
### Summary:

This release adds FreeBSD osfamily support and support
for adding nrpe plugins.

### Features:

- Add FreeBSD support
- Add plugin command

### Bugfixes:

- OpenCSW changed the paths of configs files

## 2013-10-20 Release 0.0.4

### Summary:

This is a bug fix release

### Bug fixes:

  - Fix puppet 3.x bug with array namevars
  - Puppet lint fixes

## 2013/09/25 Release 0.0.3

- Add Rakefile, Gemfile and update .gitignore
- Merge pull request #1 from ripienaar/puppet_3_2_1_deprecations
- Puppet 3.2.1 has deprecated 'foo' as a means of accessing variables in templates instead now requiring '@foo' and will log warnings about this.

## 2013/02/02 Release 0.0.2

- Bump version to 0.0.2 for forge release
- Remove nrpe plugin.
- Fix spelling of the word command in README
- Ignore pkg directory
- Add ability to purge nrpe::commands
- Add smoke tests
- Add dependencies to the README
- Fix typo with nagios_plugin package for solaris
- Add nagios-plugin package param
- Add nrpe::command functionality
- Add redhat params to nrpe
- Change allowed_hosts from a string to an array
- Initial commit for nrpe module


