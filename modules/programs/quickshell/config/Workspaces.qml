import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

RowLayout {
  id: root

  spacing: 6

  Repeater {
    model: Hyprland.workspaces

    Item {
      required property var modelData
      implicitHeight: text.implicitHeight
      implicitWidth: text.implicitWidth

      Text {
        id: text
        font.pixelSize: 20
        leftPadding: 1
        rightPadding: 1
        color: {
          if (modelData.active) {
            return Theme.sky
          }
          return Theme.subtext0
        }
        text: modelData.id

        // onClick: modelData.activate
      }
    }
  }
}
