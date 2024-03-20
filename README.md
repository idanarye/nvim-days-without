[![CI Status](https://github.com/idanarye/nvim-days-without/workflows/CI/badge.svg)](https://github.com/idanarye/nvim-days-without/actions)

INTRODUCTION
============

Days Without is a plugin for encouraging Neovim users to refrain from playing with their configuration instead of doing actual work. It does so by displaying the number of days it has been since the last time the configuration was touched.

FEATURES (IMPLEMENTED/PLANNED)
==============================

* [ ] Determining the last time the configuration was changed.
* [ ] Exposing that information for other plugins (e.g. custom splash screens) to use.
* [ ] Displaying a billboard (using a floating window) with that information.

SETUP
=====

Install Days Without with your plugin manager of choice, and add this to your `init.lua`:

```lua
require'days-without'.setup {
}
```

CONTRIBUTION GUIDELINES
=======================

* If your contribution can be reasonably tested with automation tests, add tests. The tests run with [a specific branch in a fork of Plenary](https://github.com/idanarye/plenary.nvim/tree/async-testing) that allows async testing ([there is a PR to include it in the main repo](https://github.com/nvim-lua/plenary.nvim/pull/426))
* Documentation comments must be compatible with both [Sumneko Language Server](https://github.com/sumneko/lua-language-server/wiki/Annotations) and [lemmy-help](https://github.com/numToStr/lemmy-help/blob/master/emmylua.md). If you do something that changes the documentation, please run `make docs` to update the vimdoc.
* Days Without uses Google's [Release Please](https://github.com/googleapis/release-please), so write your commits according to the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format.
