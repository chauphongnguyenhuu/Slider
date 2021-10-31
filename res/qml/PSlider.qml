import QtQuick 2.0
import QtQml 2.12

Item {
    id: root

    property int value: 0
    property int min: 0
    property int max: 10

    signal released()

    Rectangle {
        id: sliderBarBackground
        anchors {
            left: root.left
            verticalCenter: root.verticalCenter
        }
        width: root.width
        height: 5
        color: "grey"
    }

    Rectangle {
        id: sliderBarForeground
        anchors {
            left: sliderBarBackground.left
            verticalCenter: sliderBarBackground.verticalCenter
        }
        width: sliderHandle.x
        height: 5
        color: "red"
    }

    Rectangle {
        id: sliderHandle
        anchors.verticalCenter: sliderBarBackground.verticalCenter
        width: 20
        height: 20
        color: "red"

        Behavior on x {
            enabled: internal.enableSnapAnimation
            animation: NumberAnimation {
                duration: 334
                easing.type: Easing.InCubic
            }
        }

        Binding on x {
            when: !sliderTouchArea.pressed
            value: convertValueToLeftX(root.value, sliderHandle)
        }
    }

    MouseArea {
        id: sliderTouchArea
        anchors.fill: root
        preventStealing: true

        onPressed: {
            console.log("[PSlider.qml][sliderTouchArea] `onPressed()`")
            internal.enableSnapAnimation = false
            setHandleCenterX(mouseX)
        }

        onMouseXChanged: {
            setHandleCenterX(mouseX)
        }

        onReleased: {
            console.log("[PSlider.qml][sliderTouchArea] `onReleased()`")
            internal.enableSnapAnimation = true
            setHandleCenterX(mouseX)
            root.released()
        }
    }

    Binding on value {
        when: sliderTouchArea.pressed
        value: valueAt(getCenterX(sliderHandle))
    }

    QtObject {
        id: internal

        property real minRange: sliderHandle.width / 2
        property real maxRange: root.width - sliderHandle.width / 2
        property bool enableSnapAnimation: true
        property real debugValue: 0.0
    }

    function clamp(value, min, max) {
        if (value < min)
            return min
        if (value > max)
            return max

        return value
    }

    function getCenterX(item) {
        return item.x + item.width / 2
    }

    function setCenterX(item, x) {
        item.x = x - item.width / 2
    }

    function setHandleCenterX(mouseX) {
        var x = clamp(mouseX, internal.minRange, internal.maxRange)
        setCenterX(sliderHandle, x)
    }

    function valueAt(x) {
        internal.debugValue = (x - internal.minRange) * (root.max - root.min) / (internal.maxRange - internal.minRange) + root.min
        return Math.round((x - internal.minRange) * (root.max - root.min) / (internal.maxRange - internal.minRange) + root.min)
    }

    function convertValueToCenterX(value) {
        return (value - root.min) * (internal.maxRange - internal.minRange) / (root.max - root.min) + internal.minRange
    }

    function convertValueToLeftX(value, item) {
        return convertValueToCenterX(value) - item.width / 2
    }

    // DEBUG--------------------------------------------------------

    Text {
        anchors {
            centerIn: parent
            verticalCenterOffset: -100
        }
        text: root.value
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        anchors {
            centerIn: parent
            horizontalCenterOffset: 100
            verticalCenterOffset: -100
        }
        text: internal.debugValue.toFixed(2)
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
    }

    Row {
        anchors {
            left: sliderBarBackground.left
            top: sliderBarBackground.bottom
            leftMargin: internal.minRange
            topMargin: 30
        }
        spacing: 0
        Repeater {
            model: root.max - root.min
            delegate: debugComponent
        }
    }

    Component {
        id: debugComponent
        Rectangle {
            width: (internal.maxRange - internal.minRange + 1) / (root.max - root.min)
            height: 10
            color: "orange"
            border.color: "black"
        }
    }
}
