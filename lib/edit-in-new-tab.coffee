{CompositeDisposable} = require 'atom'
meta = require '../package.json'

module.exports = EditInNewTab =
  config:
    synchronizeChanges:
      title: "Synchronize Changes"
      description: "Writes changes in the new tab back to the origin"
      type: "boolean"
      default: false
      order: 1
    ignoreScope:
      title: "Ignore Scope"
      description: "Doesn't apply the origin's grammar on the new tab"
      type: "boolean"
      default: false
      order: 2
    targetPane:
      title: "Target Pane"
      description: "Specifies the default pane for the new tab"
      type: "string",
      default: "",
      enum: [
        { value: "", description: "(same pane)"}
        { value: 'up', description: 'Split Up'}
        { value: 'down', description: 'Split Down'}
        { value: 'left', description: 'Split Left'}
        { value: 'right', description: 'Split Right'}
      ]
      order: 3
    outputFormat:
      title: "Output Format"
      type: 'object'
      order: 4
      properties:
        select:
          title: "Select"
          description: "Selects the newly added text"
          type: "boolean"
          default: false
          order: 1
        autoIndent:
          title: "Auto-indent"
          description: "Indents all inserted text appropriately"
          type: "boolean"
          default: true
          order: 2
        autoIndentNewline:
          title: "Auto-indent New Line"
          description: "Indent new line appropriately"
          type: "boolean"
          default: true
          order: 3
        autoDecreaseIndent:
          title: "Auto-decrease Indent"
          description: "Decreases indent level appropriately (for example, when a closing bracket is inserted)"
          type: "boolean"
          default: true
          order: 4
        normalizeLineEndings:
          title: "Normalize Line Endings"
          type: "boolean"
          default: true
          order: 5
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'edit-in-new-tab:copy-selection': => @editInNewTab(false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'edit-in-new-tab:move-selection': => @editInNewTab(true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'edit-in-new-tab:open-package-settings': => @openSettings()

  deactivate: ->
    @subscriptions.dispose()

  editInNewTab: (cutSelection) ->
    return unless editor = atom.workspace.getActiveTextEditor()

    parentEditor = editor.id
    parentSelection = editor.getLastSelection()

    target =
      scope: editor.getGrammar().scopeName
      text: parentSelection.getText()

    unless target.text.length > 0
      return atom.beep()

    # Move to new Tab?
    if cutSelection is true
      parentSelection.delete()

    targetPane = atom.config.get('edit-in-new-tab.targetPane')

    atom.workspace.open(null, { split: targetPane })
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

        if atom.config.get('edit-in-new-tab.synchronizeChanges') is true and cutSelection is false
          childEditor = atom.workspace.getActiveTextEditor().id

          atom.workspace.observeTextEditors (editor) =>
            return unless editor.id is childEditor

            editor.onDidChange =>
              parentSelection.insertText(editor.getText(), { select: true })

      .catch (error) ->
        atom.notifications.addError(error, dismissable: true)

  openSettings: ->
    atom.workspace.open("atom://config/packages/#{meta.name}")
