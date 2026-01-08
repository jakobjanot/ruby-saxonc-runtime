# saxonc-runtime

A small helper gem that downloads and exposes SaxonC binaries for the `saxonc` gem (or any consumer that needs `SAXONC_HOME`). It detects your platform, fetches the right archive, and keeps it in a cache.

## Installation

```bash
gem install saxonc-runtime
# or
bundle add saxonc-runtime
```

By default it installs the Home Edition (HE). Pick another edition with:

```bash
SAXONC_EDITION=pe gem install saxonc-runtime
# or ee
```

Force a fresh download (ignore cache):

```bash
SAXONC_LIBS_FORCE=1 gem install saxonc-runtime
```

## Using with `saxonc`

When `saxonc` builds its native extension it will, by default, ask this gem for `SAXONC_HOME`. You don't need to do anything extra.

If you already have a SaxonC install, skip the download and point `saxonc` (and this helper) at it:

```bash
export SAXONC_HOME=/Users/janot/Code/ruby-saxonc/SaxonCHE-macos-arm64-12-9-0/SaxonCHE
gem install saxonc
```

Or use mkmf flags when compiling `saxonc` from source:

```bash
gem install saxonc -- --with-saxonche-dir=/path/to/SaxonCHE
# or supply include/lib separately
gem install saxonc -- \
	--with-saxonche-include=/path/to/SaxonCHE/include \
	--with-saxonche-lib=/path/to/SaxonCHE/lib
```

Precedence when locating SaxonC: `--with-saxonche-*` flags > `SAXONC_HOME` > cached runtime from this gem.

## Development

```bash
bundle install
bundle exec rake spec
```

To release, bump `lib/saxon/runtime/version.rb`, tag `vX.Y.Z`, and push; the GitHub Actions release workflow will build, attach the gem to the GitHub Release, and publish to RubyGems.
