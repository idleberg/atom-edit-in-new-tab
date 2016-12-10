{CompositeDisposable} = require 'atom'

module.exports = EditInNewTab =
  config:
    ignoreScope:
      title: "Ignore Scope"
      description: "Don't set the current scope in target tab"
      type: "boolean"
      default: false
      order: 1
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'selection:edit-in-new-tab': => @editInNewTab()

  deactivate: ->
    @subscriptions.dispose()

  editInNewTab: () ->
    return unless editor = atom.workspace.getActiveTextEditor()

    scopeName = editor.getGrammar().scopeName
    selection = editor.getLastSelection()
    text = selection.getText()

    unless text.length > 0
      return atom.beep()

    atom.workspace.open()
      .then (newTab) ->
        newTab.setText(text)
        unless atom.config.get('edit-in-new-tab.ignoreScope') is true
          newTab.setGrammar(atom.grammars.grammarForScopeName(scopeName))
      .catch (error) ->
        atom.notifications.addError(error, dismissable: true)
