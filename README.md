[![CI Status](https://github.com/idanarye/nvim-days-without/workflows/CI/badge.svg)](https://github.com/idanarye/nvim-days-without/actions)

INTRODUCTION
============

Days Without is a plugin for encouraging Neovim users to refrain from playing with their configuration instead of doing actual work. It does so by displaying the number of days it has been since the last time the configuration was touched.

Days Without was developed and tested on Linux. I don't care enoguh to make sure it works on other operation systems, but if someone does I wouldn't mind merging their PR.

[![asciicast](https://asciinema.org/a/snAZF4bPWYXywrERXauTH8Lni.svg)](https://asciinema.org/a/snAZF4bPWYXywrERXauTH8Lni)

FEATURES (IMPLEMENTED/PLANNED)
==============================

* [x] Determining the last time the configuration was changed.
* [x] Exposing that information for other plugins (e.g. custom splash screens) to use.
* [x] Displaying a billboard (using a floating window) with that information.

SETUP
=====

Install Days Without with your plugin manager of choice, and add this to your `init.lua`:

```lua
require'days-without'.setup {
    path = '~/path/to/git/worktree/containing/neovim/configuration',
}
```

The `path` **must** be a Git repository. If `setup` is called from somewhere inside the Git worktree, `path` can be omitted, and Days Without will detect it automatically:

```lua
require'days-without'.setup {}
```

By default the billboard to appear at startup. To disable it on startup, set:

```lua
require'days-without'.setup {
    show_on_startup = false,
}
```

And run it manually with:

```vim
:lua require'days-without'.show()
```


ALTERNATIVES
============

* [ConfigPulse](https://github.com/mrquantumcodes/configpulse)
* [Ohne Accidents](https://github.com/blumaa/ohne-accidents)

Both of these plugins differ from Days Without:

* They are based on the modification date of the files - unlike Days Without which checks the Git information.
* They `print` their message - Days Without shows a pretty billboard.

CONTRIBUTION GUIDELINES
=======================

* If your contribution can be reasonably tested with automation tests, add tests. The tests run with [a specific branch in a fork of Plenary](https://github.com/idanarye/plenary.nvim/tree/async-testing) that allows async testing ([there is a PR to include it in the main repo](https://github.com/nvim-lua/plenary.nvim/pull/426))
* Documentation comments must be compatible with both [Sumneko Language Server](https://github.com/sumneko/lua-language-server/wiki/Annotations) and [lemmy-help](https://github.com/numToStr/lemmy-help/blob/master/emmylua.md). If you do something that changes the documentation, please run `make docs` to update the vimdoc.
* Days Without uses Google's [Release Please](https://github.com/googleapis/release-please), so write your commits according to the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format.
