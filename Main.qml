import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Car Dashboard")
    color: "black"

    Dial {
        id: speedometer
        anchors.centerIn: parent
        width: 400
        height: 400

        from: 0
        to: 180
        value: 0
        focus: true

        property bool acceleration: false

        Keys.onUpPressed: {
            acceleration = true
        }

        Keys.onReleased: (event) => {
            if (event.key === Qt.Key_Up) {
                acceleration = false
                event.accepted = true
            }
        }

        Behavior on value {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        // Create Custom Design

        // 1. Custom Background (Tick marks and numbers)
        background: Item {
            id: dialBackground
            width: speedometer.width
            height: speedometer.height

            Repeater {
                model: 91 // 180 degrees total, tick every 2 units = 91 ticks
                Item {
                    id: tickMark
                    width: dialBackground.width
                    height: dialBackground.height

                    // We map 0-180 to a 270 degree sweep (-135 to +135 from top center)
                    rotation: -135 + (index * 3)

                    // The white tick mark
                    Rectangle {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: (index % 5 === 0) ? 4 : 2   // Thicker for major ticks
                        height: (index % 5 === 0) ? 14 : 8 // Longer for major ticks
                        color: "white"
                        antialiasing: true
                    }

                    // The numbers (0, 10, 20...)
                    Text {
                        visible: index % 5 === 0 // Only show numbers on major ticks
                        text: index * 2
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true

                        // Position text slightly inside the ticks
                        anchors.top: parent.top
                        anchors.topMargin: 25
                        anchors.horizontalCenter: parent.horizontalCenter

                        // Counter-rotate the text so the numbers remain upright
                        rotation: -tickMark.rotation
                    }
                }
            }
        }

        Component.onCompleted: forceActiveFocus()
    }

}
