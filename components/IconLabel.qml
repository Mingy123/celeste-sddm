import QtQuick 2.9

Row {
    property color selectColor: "#ffff8b"
    property string text: "placeholder"
    property real startX: -1; property real startY
    property real endX; property real shakeY: rootWidth * 0.003
    property real rootWidth: 1920
    property url image

    spacing: rootWidth * 0.01

    function selectAnimation() {
        if (startX == -1) initval()
        moveleft.complete()
        moveright.start()
        y_bob.start()
    } function deselectAnimation() {
        if (startX == -1) initval()
        moveright.complete()
        y_bob.complete()
        moveleft.start()
    }

    function initval() {
        startX = x; startY = y
        endX = x + rootWidth * 0.02
    }

    NumberAnimation on x {
        running: false
        id: moveright
        from: startX; to: endX
        duration: 200
        easing.type: Easing.InOutCubic
    } NumberAnimation on x {
        running: false
        id: moveleft
        from: endX; to: startX
        duration: 150
    }

    ShakeAnimation on y {
        id: y_bob
        value: startY
        shake: shakeY
        length: 200
    }

    Image {
        source: image
        height: text.height
        width: sourceSize.width / (sourceSize.height / height)
        // your height = image height / (image width / your width)
    }

    Text {
        id: text
        text: parent.text
        color: parent.focus ? parent.selectColor : "white"
        font { pointSize: 36; family: "Renogare" }
        style: Text.Outline
        styleColor: "black"
    }

    signal up()
    signal down()
    signal left()
    signal right()
    signal enter()
    signal back()

    Keys.onPressed: (event) => {
        event.accepted = true
        if (event.isAutoRepeat) return;
        switch (event.key) {
            case Qt.Key_Escape: case Qt.Key_X:
                back()
                break
            case Qt.Key_Return: case Qt.Key_Enter: case Qt.Key_C:
                enter()
                break
            case Qt.Key_Left: case Qt.Key_A: case Qt.Key_H:
                left()
                break
            case Qt.Key_Right: case Qt.Key_D: case Qt.Key_L:
                right()
                break
            case Qt.Key_Up: case Qt.Key_W: case Qt.Key_K:
                up()
                break
            case Qt.Key_Down: case Qt.Key_S: case Qt.Key_J:
                down()
                break
        }
    }
}
