// --- IMPORTS ---
// Core QML engine and basic visual types (Item, Rectangle, Text)
import QtQuick
// Provides the Window component to create the main application screen
import QtQuick.Window
// Provides UI components like Dial, which we are heavily customizing
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Car Dashboard")
    color: "black" // Sets the main window background to black

    // --- MAIN SPEEDOMETER COMPONENT ---
    // We use a Dial because it natively understands circular values and angles
    Dial {
        id: speedometer
        anchors.centerIn: parent
        width: 400
        height: 400

        // Define the minimum and maximum speed values
        from: 0
        to: 180

        // The current speed
        value: 0

        // 'focus' must be true for this component to listen to keyboard presses
        focus: true

        // Custom property to track if the user is holding the "gas pedal" (Up Arrow)
        property bool acceleration: false

        // --- KEYBOARD CONTROLS ---
        // When the Up arrow is pressed, turn acceleration ON
        // added 'braking' and switched to the stricter 'Keys.onPressed'
        property bool acceleration: false
        property bool braking: false

        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Up) {
                acceleration = true
                event.accepted = true // Strict override: Stops the Dial from intercepting
            } else if (event.key === Qt.Key_Down) {
                braking = true
                event.accepted = true
            }
        }

        Keys.onReleased: (event) => {
            if (event.key === Qt.Key_Up) {
                acceleration = false
                event.accepted = true
            } else if (event.key === Qt.Key_Down) {
                braking = false
                event.accepted = true
            }
        }

        // --- SMOOTHING ANIMATION ---
        // Whenever the 'value' property changes, smoothly animate the transition
        // rather than snapping instantly to the new number.
        Behavior on value {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad // Starts and ends the animation smoothly
            }
        }

        // --- 1. CUSTOM BACKGROUND (TICKS & NUMBERS) ---
        // Overrides the default visual background of the Dial
        background: Item {
            id: dialBackground
            width: speedometer.width
            height: speedometer.height

            // Repeater duplicates its inner components based on the 'model' number.
            // Math: We need to go from 0 to 180. If we want a tick every 2 units,
            // 180 / 2 = 90. Plus 1 for the zero tick = 91 total ticks.
            Repeater {
                model: 91
                Item {
                    id: tickMark
                    width: dialBackground.width
                    height: dialBackground.height

                    // Math: We want the dial to sweep across 270 visual degrees.
                    // 270 degrees / 90 gaps = 3 degrees per gap.
                    // We start at -135 degrees (bottom left) to keep it symmetrical.
                    rotation: -135 + (index * 3)

                    // The actual white line for the tick mark
                    Rectangle {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        // Every 5th tick (0, 10, 20...) gets a thicker and longer line
                        width: (index % 5 === 0) ? 4 : 2
                        height: (index % 5 === 0) ? 14 : 8
                        color: "white"
                        antialiasing: true // Smooths jagged pixel edges
                    }

                    // The text labels (0, 10, 20, 30...)
                    Text {
                        // Only show the text on the major ticks (every 10 units of speed)
                        visible: index % 5 === 0

                        // Multiply index by 2 to get the actual speed value (0, 2, 4...)
                        text: index * 2
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true

                        // Position the text slightly below the tick marks
                        anchors.top: parent.top
                        anchors.topMargin: 25
                        anchors.horizontalCenter: parent.horizontalCenter

                        // CRITICAL: Because the parent 'Item' is rotated, the text would
                        // normally be drawn upside down at the bottom of the dial.
                        // By applying the exact negative rotation, the text stays upright.
                        rotation: -tickMark.rotation
                    }
                }
            }
        }

        // --- 2. CUSTOM HANDLE (NEEDLE & PIVOT) ---
        // Overrides the default visual "knob" of the Dial
        handle: Item {
            id: dialHandle
            // Center the handle perfectly inside the background area
            x: speedometer.background.x + speedometer.background.width / 2 - width / 2
            y: speedometer.background.y + speedometer.background.height / 2 - height / 2
            width: 20
            height: speedometer.height

            // The Dial component magically calculates 'speedometer.angle' for us
            // based on the 'value' property. We just apply it to the rotation.
            rotation: speedometer.angle

            // The Red Needle
            Rectangle {
                id: needle
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: -15 // Pull it down slightly to hide behind the center cap
                anchors.horizontalCenter: parent.horizontalCenter
                height: speedometer.height * 0.45 // Takes up 45% of the dial's total height
                width: 6
                color: "#e74c3c" // A sporty red hex color
                antialiasing: true
                radius: 3 // Rounds the corners of the needle
            }

            // The Grey Center Pivot Cap
            Rectangle {
                anchors.centerIn: parent
                width: 32
                height: 32
                radius: 16 // Radius = half of width makes a perfect circle
                color: "#7f8c8d"
                border.color: "#333333"
                border.width: 2
            }
        }

        // --- 3. PHYSICS & TIMING ENGINE ---
        // This timer acts as our "game loop", firing every 30 milliseconds
        Timer {
            interval: 16 // ~60 FPS for instant visual feedback
            running: true
            repeat: true
            onTriggered: {
                if (speedometer.acceleration && speedometer.value < speedometer.to) {
                    speedometer.value += 1.2 // Faster acceleration
                } else if (speedometer.braking && speedometer.value > speedometer.from) {
                    speedometer.value -= 2.5 // Hard braking
                } else if (!speedometer.acceleration && speedometer.value > speedometer.from) {
                    speedometer.value -= 0.3 // Smooth coasting
                }

                // Safety catch to ensure we don't accidentally go below 0 or above 180
                if (speedometer.value < 0) speedometer.value = 0;
                else if (speedometer.value > 180) speedometer.value = 180;
            }
        }

        // --- 4. DIGITAL SPEED READOUT ---
        // This overlays the large white numbers at the bottom center of the dial
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50 // Pushes it up slightly from the bottom edge

            // Math.round() removes the decimals. Without it, the text would
            // rapidly flicker between numbers like "61.5" and "63.0"
            text: Math.round(speedometer.value)
            color: "white"
            font.pixelSize: 42
            font.bold: true

            // The "km/h" label text
            Text {
                anchors.top: parent.bottom // Anchors to the bottom of the large number
                anchors.horizontalCenter: parent.horizontalCenter
                text: "km/h"
                color: "#7f8c8d"
                font.pixelSize: 16
            }
        }

        // Ensure the Dial listens for keyboard events immediately upon startup
        Component.onCompleted: forceActiveFocus()
    }
}
