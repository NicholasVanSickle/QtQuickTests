import QtQuick 2.0

Rectangle {
    width: 640
    height: 480
    color: "white"

    Row {
        spacing: 2
        x: parent.width / 2 - width / 2
        anchors.verticalCenter: parent.verticalCenter
        Rectangle { color: "red"; width: 30; height: 50 }
        Rectangle { color: "blue"; width: 30; height: 30 }
        id: row

        Behavior on x {
            PropertyAnimation { duration: 200; easing.type: Easing.Linear }
        }
    }

    MouseArea {
        anchors.fill: row
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                var component = Qt.createComponent("FancyRectangle.qml")
                var nextRect = component.createObject(row)
                nextRect.color = colorSelector.targetColor
                nextRect.width = 30
                nextRect.height = Math.random() * 50 + 20
                if (row.width + 30 > parent.width) {
                    row.children[0].destroy()
                }
            } else {
                if (row.children.length > 1)
                    row.children[row.children.length - 1].destroy()
            }
        }
    }

    Rectangle {
        anchors.bottom: row.top
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        property string targetColor: colors[0] //without this, we'd get the eased current color
        color: targetColor
        width: 50
        height: 50
        property int colorIndex: 0
        property variant colors: ["red", "green", "purple", "yellow", "blue"]
        id: colorSelector

        Behavior on color { PropertyAnimation { duration: 300; easing.type: Easing.InOutQuad } }

        MouseArea { anchors.fill: parent; onClicked: {
                parent.colorIndex = (parent.colorIndex + 1) % parent.colors.length;
                parent.targetColor = parent.colors[parent.colorIndex];
            } }
    }

    Rectangle {
        width: 100; height: 100
        color: "black"
        id: animated

        SequentialAnimation on x {
            loops: Animation.Infinite
            PropertyAnimation {
                to: width - animated.width - 100
                easing.type: Easing.InOutElastic
                duration: 2000
                id: animatedProp
            }
            PropertyAnimation {
                to: 100
                easing: animatedProp.easing
                duration: animatedProp.duration
            }
        }
    }
}
