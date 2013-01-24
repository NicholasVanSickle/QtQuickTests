import QtQuick 2.0

Rectangle {
    width: 640
    height: 480
    color: "white"
    id: window

    Component {
        id: delegate
        Column {
            id: wrapper
            Text {
                id: nameText
                text: name
                font.pointSize: 16
                color: wrapper.PathView.isCurrentItem ? "red" : "black"
            }
        }
    }

    Text { //thought about anchoring this to the path for a neat effect, but that's not allowed
        id: startLabel
        text: "Press space to start " + path.model.get(path.currentIndex).name
        font.pointSize: 16
        color: "black"
        x: 50
        y: 50
    }

    PathView {
        id: path
        anchors.centerIn: parent
        model:  ListModel {
            ListElement {
                name: "Pong"
            }
            ListElement {
                name: "EasingTest"
            }
            ListElement {
                name: "StateTest"
            }
        }
        delegate: delegate
        path: Path {
            startX: 0; startY: -50
            PathQuad { x: 0; y: 25; controlX: 150; controlY: 50 }
            PathQuad { x: 0; y: -50; controlX: -150; controlY: 50 }
        }
        focus: true
        Keys.onLeftPressed: decrementCurrentIndex()
        Keys.onRightPressed: incrementCurrentIndex()
        Keys.onSpacePressed: {
            if (runArea.children.length === 1) {
                var name = model.get(currentIndex).name
                var app = Qt.createQmlObject(name + "{ width: window.width; height: window.height }", runArea)

                //this is the preferred way of doing this, but there's no way (?)
                //of creating a property binding after instantiation
                /*
                var component = Qt.createComponent(name + ".qml")
                var app = component.createObject(runArea)*/
            }
        }
        Keys.onEscapePressed: {
            if (runArea.children.length === 2) {
                runArea.children[1].destroy()
            }
        }
    }

    Item {
        anchors.fill: parent
        id: runArea

        Text {
            x: 50
            y: 5
            font.pointSize: 16
            text: "Press ESC to close"
            color: "gray"
            z: 1
            visible: parent.children.length > 1
        }
    }
}
