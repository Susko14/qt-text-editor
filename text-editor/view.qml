import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs


ApplicationWindow {
    id: window
    width: 400
    height: 400
    visible: true


    Action {
              id: copyAction
              text: "&Copy"
              shortcut: StandardKey.Copy
              // iconName: "edit-copy"
              enabled: textArea.selectedText
              onTriggered: textArea.copy()
          }

          Action {
              id: cutAction
              text: "Cu&t"
              shortcut: StandardKey.Cut
              enabled: textArea.selectedText
              onTriggered: textArea.cut()
          }

          Action {
              id: pasteAction
              text: "&Paste"
              shortcut: StandardKey.Paste
              // iconName: "edit-paste"
              // enabled: !!window.textArea
              onTriggered: textArea.paste()
          }

          Action {
              id: openAction
              text: "&Open"
              shortcut: StandardKey.Open
              onTriggered: {
                  if (textArea.textDocument.modified)
                      discardDialog.open()
                  else
                      openDialog.open()
              }
          }

          Action {
            id: saveAction
            text: "&Save"
            shortcut: StandardKey.Save
            // onTriggered: saveDialog.save()
            onTriggered: {
                if (textArea.textDocument.status === textDocument.Null)
                    // textArea.textDocument.saveAs()
                    saveDialog.open()
                else
                    textArea.textDocument.save()
            }
          }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }
            MenuItem {
                text: qsTr("Open")
                onTriggered: openAction.trigger()
            }
            MenuItem {
                text: qsTr("&Save")
                onTriggered:saveAction.trigger()
            }
            Action { text: qsTr("Save &As...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit") }
        }
        Menu {
            title: qsTr("&Edit")
            MenuItem { action: cutAction }
            MenuItem { action: copyAction }
            MenuItem { action: pasteAction }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }

    FileDialog {
        id: openDialog
        fileMode: FileDialog.OpenFile
        selectedNameFilter.index: 1
        nameFilters: ["Text files (*.txt)", "HTML files (*.html *.htm)", "Markdown files (*.md *.markdown)"]
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: {
            textArea.textDocument.modified = false // we asked earlier, if necessary
            textArea.textDocument.source = selectedFile
        }
    }

    FileDialog {
        id: saveDialog
        fileMode: FileDialog.SaveFile
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: textArea.textDocument.saveAs(selectedFile)
    }

    GridLayout {
        id: grid
        columns: 2
        rows: 1
        anchors.fill: parent

        Column {
            id: column0
            ColumnLayout {
                id: columnLayout
                // anchors.top: parent.top
                // anchors.left: parent.left
                // anchors.right: parent.right
                // anchors.margins: 5

                Button {
                    icon.name: "Open"
                    icon.source: "images/open-folder.png"
                    action: openAction
                }

                Button {
                    icon.name: "Save"
                    icon.source: "images/save-file.png"
                    action: saveAction
                }

                Button {
                    icon.name: "Copy"
                    icon.source: "images/copy.png"
                    action: copyAction
                }

                Button {
                    icon.name: "Cut"
                    icon.source: "images/cut.png"
                    action: cutAction
                }

                Button {
                    icon.name: "Paste"
                    icon.source: "images/paste.png"
                    action: pasteAction
                }
            }
        }

        Column {
            id: column1

            Layout.fillHeight: true
            Layout.fillWidth: true

            Flickable {
                id: flick
                width: column1.width
                height: column1.height
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    clip: false
                 }

                function ensureVisible(r)
                {
                     if (contentX >= r.x)
                         contentX = r.x;
                     else if (contentX+width <= r.x+r.width)
                         contentX = r.x+r.width-width;
                     if (contentY >= r.y)
                         contentY = r.y;
                     else if (contentY+height <= r.y+r.height)
                         contentY = r.y+r.height-height;
                 }

                 TextArea.flickable: TextArea {
                     id: textArea
                     textFormat: Qt.AutoText
                     wrapMode: TextArea.Wrap
                     focus: true
                     selectByMouse: true
                     persistentSelection: true
                 }
             }
        }
    }
}
