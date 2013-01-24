import QtQuick 2.0

Rectangle {
    width: 640
    height: 480
    color: "white"
    id: win

    Rectangle {
        id: stateTest
        width: 25
        height: 25
        x: 400
        y: 200
        color: "black"

        states: [
            State {
                name: "state1"
                AnchorChanges { target: stateTest; anchors.top: win.top; anchors.bottom: win.bottom }
            }
        ]

        transitions: [
            Transition { AnchorAnimation { duration: 2000 } }

        ]

        MouseArea {
            anchors.fill: parent
            onClicked: parent.state = "state1"
        }
    }
}
