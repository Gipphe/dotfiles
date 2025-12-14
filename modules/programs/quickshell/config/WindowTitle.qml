import QtQuick
import Quickshell
import Quickshell.Hyprland

Text {
  id: root
  readonly property var currentWindow: Hyprland.activeTopLevel
  text: currentWindow?.title ?? ''
  color: Theme.subtext1
}
