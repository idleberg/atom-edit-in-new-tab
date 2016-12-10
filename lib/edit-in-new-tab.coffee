{CompositeDisposable} = require 'atom'

# 3rd-party dependencies
fs = require 'fs'
path = require 'path'
CSON = require 'cson'
parseCson = require 'cson-parser'
parseJson = require 'parse-json'

# Atom = require './includes/atom'
# SublimeText = require './includes/sublime-text'
# TextMate = require './includes/textmate'
# VsCode = require './includes/vscode'

module.exports = Atomizr =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'selection:edit-in-new-tab': => @editInNewTab()

  deactivate: ->
    @subscriptions.dispose()

  editInNewTab: ->
    return unless editor = atom.workspace.getActiveTextEditor()

    scopeName = editor.getGrammar().scopeName
    selection = editor.getLastSelection().getText()

    unless selection.length > 0
      return atom.beep()

    atom.workspace.open()
      .then (editor) ->
        editor.setText(selection)
        editor.setGrammar(atom.grammars.grammarForScopeName(scopeName))
      .catch (error) ->
        atom.notifications.addError(error, dismissable: true)
