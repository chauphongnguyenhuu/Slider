import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml 2.12

Window {
    width: 640
    height: 480
    title: qsTr("Hello World")
    visible: true

    property bool enableWarning: true
    property int warningOffset: 5

    PSlider {
        id: slider
        anchors.centerIn: parent
        width: 400
        height: 50
        min: 1
        max: 11
        value: enableWarning ? warningOffset : slider.min
        enabled: enableWarning

        onReleased: {
            console.log("[Main.qml][slider] `onReleased()`")
            if (enableWarning) {
                warningOffset = slider.value
            }
        }
    }

    Rectangle {
        id: decrease
        anchors {
            right: slider.left
            verticalCenter: slider.verticalCenter
            rightMargin: 10
        }
        width: 40
        height: 40
        color: "orange"

        Text {
            text: "-"
            anchors.centerIn: parent
            font.pixelSize: 20
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            onPressAndHold: {
                warningOffset = slider.min
                console.log("[Main.qml][decrease] `onPressAndHold()` warningOffset = " + warningOffset)
            }

            onReleased: {
                if (enableWarning && warningOffset > slider.min)
                    warningOffset--

                console.log("[Main.qml][decrease] `onReleased()` warningOffset = " + warningOffset)
            }
        }
    }

    Rectangle {
        id: increase
        anchors {
            left: slider.right
            verticalCenter: slider.verticalCenter
            leftMargin: 10
        }
        width: 40
        height: 40
        color: "orange"

        Text {
            text: "+"
            anchors.centerIn: parent
            font.pixelSize: 20
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            onPressAndHold: {
                warningOffset = slider.max
                console.log("[Main.qml][increase] `onPressAndHold()` warningOffset = " + warningOffset)
            }

            onReleased: {
                if (enableWarning && warningOffset < slider.max)
                    warningOffset++

                console.log("[Main.qml][increase] `onReleased()` warningOffset = " + warningOffset)
            }
        }
    }

    // DEBUG------------------------------------

    Rectangle {
        anchors.fill: slider
        color: "transparent"
        border.color: "red"
    }

    Text {
        anchors {
            centerIn: slider
            horizontalCenterOffset: -100
            verticalCenterOffset: -100
        }
        text: warningOffset
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        color: "red"
    }

    Rectangle {
        x: 10
        y: 10
        width: 50
        height: 50
        color: "yellow"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                enableWarning = !enableWarning
                console.log("[Main.qml][debug_enable_warning] `onClicked()` " + enableWarning)
            }
        }
    }
}
