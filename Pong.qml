import QtQuick 2.0

Rectangle {
    width: 640
    height: 480
    color: "black"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: paddle1.y = Math.max(0,Math.min(mouseY, parent.height - paddle1.height))
    }

    Text {
        property int score: 0
        text: score
        font.family: "Helvetica"
        font.pointSize: 16
        color: "white"
        x: parent.width / 4
        y: 25
        id: score1
    }

    Text {
        property int score: 0
        text: score
        font.family: "Helvetica"
        font.pointSize: 16
        color: "white"
        x: parent.width * 3 / 4
        y: 25
        id: score2
    }

    Item {
        id: collidables
        height: parent.height
        width: parent.width

        Rectangle {
            x: 0
            y: parent.height / 2 - height / 2
            height: 75
            width: 15
            color: "white"
            id: paddle1
        }

        Rectangle {
            x: parent.width - width
            y: parent.height / 2 - height / 2
            height: 75
            width: 15
            color: "white"
            id: paddle2
            property real speed: 5
        }
    }

    Image {
        x: parent.width / 2 - width / 2
        y: 0
        height: parent.height
        width: 2
        source: "dotted-line.png"
        smooth: false
        fillMode: Image.TileVertically
    }

    Rectangle {
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: 10
        height: 10
        color: "white"
        id: ball
        property real vx: 10
        property real vy: 0
    }

    Timer {
        interval: 5
        running: true
        repeat: true
        onTriggered: {
            var p2target = ball.y + ball.height / 2 - paddle2.height / 2;
            var p2offset = p2target - paddle2.y;
            if (Math.abs(p2offset) > paddle2.speed)
                p2offset = paddle2.speed * p2offset / Math.abs(p2offset);
            paddle2.y = Math.max(0, Math.min(parent.height - paddle2.height, paddle2.y + p2offset));

            var nx = ball.x + ball.vx;
            var ny = ball.y + ball.vy;
            if (nx < 0 || nx + ball.width > parent.width) {
                ball.x = parent.width / 2 - ball.width / 2;
                ball.y = parent.height / 2 - ball.height / 2;
                ball.vy = 0;
                if (nx < 0) {
                    score2.score++;
                    ball.vx = 10;
                } else {
                    score1.score++;
                    ball.vx = -10;
                }

                return;
            }

            if (ny < 0 || ny + ball.height > parent.height) {
                ball.vy = -ball.vy;
                return;
            }

            for(var i=0;i<collidables.children.length;i++) {
                var paddle = collidables.children[i];
                if (ball.vx > 0 && paddle.x < parent.width / 2 || ball.vx > 0 && paddle.x < parent.width / 2)
                    continue;
                if (nx + ball.width > paddle.x && nx < paddle.x + paddle.width &&
                        ny + ball.height > paddle.y && ny < paddle.y + paddle.height) {
                    var velocity = 10//Math.sqrt(ball.vx * ball.vx + ball.vy * ball.vy);
                    var offset = Math.PI * Math.max(Math.min(ny-paddle.y, paddle.height),0) / paddle.height;
                    var rx = Math.max(Math.sin(offset), 0.3);
                    ball.vx = rx * velocity;
                    ball.vy = (1-rx) * velocity;
                    if (nx > parent.width / 2)
                        ball.vx = -ball.vx;
                    return;
                }
            }

            ball.x = nx;
            ball.y = ny;
        }
    }
}
