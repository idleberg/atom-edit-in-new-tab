{CompositeDisposable} = require 'atom'

module.exports = EditInNewTab =
  config:
    ignoreScope:
      title: "Ignore Scope"
      description: "Don't set the current scope in target tab"
      type: "boolean"
      default: false
      order: 1
    outputFormat:
      title: "Output Format"
      type: 'object'
      properties:
        select:
          title: "Select"
          description: "Selects the newly added text"
          type: "boolean"
          default: false
          order: 2
        autoIndent:
          title: "Auto-indent"
          description: "Indents all inserted text appropriately"
          type: "boolean"
          default: false
          order: 3
        autoIndentNewline:
          title: "Auto-indent New Line"
          description: "Indent newline appropriately"
          type: "boolean"
          default: false
          order: 4
        autoDecreaseIndent:
          title: "Auto-decreate Indent"
          description: "Decreases indent level appropriately (for example, when a closing bracket is inserted)"
          type: "boolean"
          default: false
          order: 5
        normalizeLineEndings:
          title: "Normalize Line Endings"
          type: "boolean"
          default: true
          order: 6
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

    selection = editor.getLastSelection()

    target =
      scope: editor.getGrammar().scopeName
      text: selection.getText()

    unless target.text.length > 0
      return atom.beep()

    atom.workspace.open()
      .then (newTab) ->
        options =
          select: atom.config.get('edit-in-new-tab.outputFormat.select')
          autoIndent: atom.config.get('edit-in-new-tab.outputFormat.autoIndent')
          autoIndentNewline: atom.config.get('edit-in-new-tab.outputFormat.autoIndentNewline')
          autoDecreaseIndent: atom.config.get('edit-in-new-tab.outputFormat.autoDecreaseIndent')
          normalizeLineEndings: atom.config.get('edit-in-new-tab.outputFormat.normalizeLineEndings')

        newTab.insertText(target.text, options)
        unless atom.config.get('edit-in-new-tab.ignoreScope') is true
          newTab.setGrammar(atom.grammars.grammarForScopeName(target.scope))
      .catch (error) ->
        atom.notifications.addError(error, dismissable: true)
