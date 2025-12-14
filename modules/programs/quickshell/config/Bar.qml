pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: Theme.crust

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40

            RowLayout {
                spacing: 6
                anchors.fill: parent

                Workspaces {
                    Layout.alignment: Qt.AlignLeft
                }

                WindowTitle {
                    Layout.alignment: Qt.AlignLeft
                }

                ClockWidget {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
