import QtQuick 2.0

Rectangle {
    height: 0
    width: 0

    Behavior on height {
        PropertyAnimation { duration: 500; easing.type: Easing.InQuad }
    }

    Behavior on width {
        PropertyAnimation { duration: 200; easing.type: Easing.InQuad }
    }
}
