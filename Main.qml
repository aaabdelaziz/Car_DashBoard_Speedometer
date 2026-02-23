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

        Component.onCompleted: forceActiveFocus()
    }

}
