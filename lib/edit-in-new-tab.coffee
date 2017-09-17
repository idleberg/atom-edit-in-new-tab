# Kudos http://stackoverflow.com/a/17606289
String::replaceAll = (search, replacement) ->
  target = this
  target.replace new RegExp(search, 'g'), replacement

module.exports = EditInNewTab =
  config:
    synchronizeChanges:
      title: "Synchronize Changes"
      description: "Writes changes in the new tab back to the origin"
      type: "boolean"
      default: true
      order: 1
    targetPane:
      title: "Target Pane"
      description: "Specifies the default pane for the new tab"
      type: "string",
      default: "",
      enum: [
        { value: "", description: "(current)"}
        { value: 'up', description: 'Split Up'}
        { value: 'down', description: 'Split Down'}
        { value: 'left', description: 'Split Left'}
        { value: 'right', description: 'Split Right'}
      ]
      order: 2
    indentOrigin:
      title: "Auto-indent Origin"
      description: "Auto-indent changes written back to the originating tab"
      type: "boolean"
      default: false
      order: 3
    ignoreScope:
      title: "Ignore Scope"
      description: "Doesn't apply the origin's grammar on the new tab"
      type: "boolean"
      default: false
      order: 4
    defaultTabName:
      title: "Default Tab-name"
      description: "Define a default scheme for new tabs. Available placeholders: `%file%` for file-name, `%id%` for editor ID, and `%count%` to count tabs"
      type: "string"
      default: ""
      order: 5
    outputFormat:
      title: "Formatting Options"
      type: 'object'
      order: 6
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
  counter: 0

  activate: (state) ->
    {CompositeDisposable} = require 'atom'

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    #
    @subscriptions = new CompositeDisposable

    # Register commands
    #
    @subscriptions.add atom.commands.add 'atom-workspace', 'edit-in-new-tab:copy-selection': => @editInNewTab(false)
    @subscriptions.add atom.commands.add 'atom-workspace', 'edit-in-new-tab:move-selection': => @editInNewTab(true)
    @subscriptions.add atom.commands.add 'atom-workspace', 'edit-in-new-tab:settings': => @openSettings()

  deactivate: ->
    @subscriptions.dispose()

  editInNewTab: (cutSelection) ->
    return unless parentEditor = atom.workspace.getActiveTextEditor()

    parentSelection = parentEditor.getLastSelection()

    target =
      scope: parentEditor.getGrammar().scopeName
      text: parentSelection.getText()

    unless target.text.length > 0
      return atom.beep()

    # Move to new Tab?
    #
    if cutSelection is true
      parentSelection.delete()

    targetPane = atom.config.get('edit-in-new-tab.targetPane')
    defaultTabName = atom.config.get('edit-in-new-tab.defaultTabName')
    @counter += 1

    if not defaultTabName
      newTabname = null
    else
      {basename, extname} = require 'path'

      fileName = atom.workspace.getActiveTextEditor().getFileName().toString()
      fileExt = extname(fileName)
      fileBase = basename(fileName, fileExt)

      saneName = defaultTabName
                  .replaceAll("%file%", fileBase)
                  .replaceAll("%id%", parentEditor.id)
                  .replaceAll("%count%", @counter)

      newTabName = "#{saneName}#{fileExt}"

    atom.workspace.open(newTabName, { split: targetPane })
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
          childEditor = atom.workspace.getActiveTextEditor()

          atom.workspace.observeTextEditors (editor) ->
            # makes sure tabs don't get mixed up
            #
            return unless editor.id is childEditor.id

            childEditor.onDidChange ->
              parentSelection.insertText(editor.getText(), { select: true })

              if atom.config.get('edit-in-new-tab.indentOrigin') is true
                atom.commands.dispatch(atom.views.getView(parentEditor), 'editor:auto-indent')

      .catch (error) ->
        atom.notifications.addError(error, dismissable: true)

  openSettings: ->
    atom.workspace.open("atom://config/packages/edit-in-new-tab", {pending: true, searchAllPanes: true})
