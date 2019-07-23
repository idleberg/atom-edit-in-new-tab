# edit-in-new-tab

[![apm](https://img.shields.io/apm/l/edit-in-new-tab.svg?style=flat-square)](https://atom.io/packages/edit-in-new-tab)
[![apm](https://img.shields.io/apm/v/edit-in-new-tab.svg?style=flat-square)](https://atom.io/packages/edit-in-new-tab)
[![apm](https://img.shields.io/apm/dm/edit-in-new-tab.svg?style=flat-square)](https://atom.io/packages/edit-in-new-tab)
[![Travis](https://img.shields.io/travis/idleberg/atom-edit-in-new-tab.svg?style=flat-square)](https://travis-ci.org/idleberg/atom-edit-in-new-tab)
[![David](https://img.shields.io/david/dev/idleberg/atom-edit-in-new-tab.svg?style=flat-square)](https://david-dm.org/idleberg/atom-edit-in-new-tab?type=dev)

Opens the current selection in a new tab. Based on an idea by [Lea Verou](https://twitter.com/LeaVerou/status/807287092493553665).

![Screenshot](https://raw.github.com/idleberg/atom-edit-in-new-tab/master/screenshot-1.gif)

*Edit selection in a new tab*

![Screenshot](https://raw.github.com/idleberg/atom-edit-in-new-tab/master/screenshot-2.gif)

*Edit in new tab and write changes back to origin*

## Installation

Install `edit-in-new-tab` from Atom's [Package Manager](http://flight-manual.atom.io/using-atom/sections/atom-packages/) or the command-line equivalent:

`$ apm install edit-in-new-tab`

### Using Git

Change to your Atom packages directory:

```bash
# Windows
$ cd %USERPROFILE%\.atom\packages

# Linux & macOS
$ cd ~/.atom/packages/
```

Clone the repository as `edit-in-new-tab`:

```bash
$ git clone https://github.com/idleberg/atom-edit-in-new-tab edit-in-new-tab
```

Inside the cloned directory, install Node dependencies:

```bash
$ yarn || npm install
```

## Usage

This package provides several commands in the command palette, the context menu or by using the keyboard shortcuts

* **Edit in New Tab: Copy Selection** – Edit current selection in new tab (<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd>) 
* **Edit in New Tab: Settings** – Open the settings pane for this package

## Settings

It's well worth taking a look at the package settings, where you can tweak the default behaviour.

Option                 | Default | Description
-----------------------|---------|--------------------------------------------------------
Synchronize Changes    | `true`  | Writes changes in the new tab back to the origin¹
Target Pane            |         | Specifies the default pane for the new tab
Auto-indent Origin     | `false` | Auto indent changes written back to the originating tab
Ignore Scope           | `false` | Doesn't apply the origin's grammar on the new tab
Default Tab-name       |         | Define a default scheme for new tabs²
Select                 | `false` | Selects the newly added text
Auto-indent            | `true`  | Indents all inserted text appropriately
Auto-indent New Line   | `true`  | Indent newline appropriately
Auto-decrease Indent   | `true`  | Decreases indent level appropriately
Normalize Line Endings | `true`  | Normalizes line endings 

¹ [see it in action](https://twitter.com/idleberg/status/822193943362359297)  
² accepts placeholders `%file%`, `%id%`, and `%count%`  

## License

This work is licensed under the [The MIT License](LICENSE.md).

## Donate

You are welcome to support this project using [Flattr](https://flattr.com/submit/auto?user_id=idleberg&url=https://github.com/idleberg/atom-edit-in-new-tab) or Bitcoin `17CXJuPsmhuTzFV2k4RKYwpEHVjskJktRd`
