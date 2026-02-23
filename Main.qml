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

        // 2. Custom Handle (The Red Needle and Center Cap)
        handle: Item {
            id: dialHandle
            x: speedometer.background.x + speedometer.background.width / 2 - width / 2
            y: speedometer.background.y + speedometer.background.height / 2 - height / 2
            width: 20
            height: speedometer.height

            // The Dial control automatically calculates the correct visual angle for us
            rotation: speedometer.angle

            // Red Needle
            Rectangle {
                id: needle
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: -15 // Let it overlap the center cap slightly
                anchors.horizontalCenter: parent.horizontalCenter
                height: speedometer.height * 0.45
                width: 6
                color: "#e74c3c" // A nice automotive red
                antialiasing: true
                radius: 3
            }

            // Grey Center Pivot Cap
            Rectangle {
                anchors.centerIn: parent
                width: 32
                height: 32
                radius: 16
                color: "#7f8c8d"
                border.color: "#333333"
                border.width: 2
            }
        }

        // 3. Digital Speed Readout
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50

            // Math.round keeps the text clean from decimals
            text: Math.round(speedometer.value)
            color: "white"
            font.pixelSize: 42
            font.bold: true

            // Optional: Add "km/h" or "mph" label underneath
            Text {
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "km/h"
                color: "#7f8c8d"
                font.pixelSize: 16
            }
        }

        Component.onCompleted: forceActiveFocus()
    }

}
