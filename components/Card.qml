import QtQuick 2.9
import QtMultimedia 5.15

Image {
    id: root
    source: "../assets/card.png"
    property url icon
    property string username: "username"
    property string password: ""
    property real leftX: -width
    property real rightX: parent.width
    property real middleX: (parent.width-width)/2
    property int aDuration: 150
    property bool lock: false

    signal next(); signal prev()
    signal login(); signal exit()
    signal hide() // when user scrolls too quickly

    Component.onCompleted: {
        scroll.play()
    }

    Item {
        width: overlay.width * 0.75
        height: overlay.height * 0.75
        Image {
            anchors.fill: parent
            source: root.icon
            fillMode: Image.PreserveAspectCrop
        } anchors {
            horizontalCenter: overlay.horizontalCenter
            verticalCenter: overlay.verticalCenter
        }
    } Image {
        id: overlay
        x: 35
        anchors.verticalCenter: root.verticalCenter
        source: "../assets/iconOverlay.png"
    }

    Text {
        text: selected ? username : ""
        color: "#5c3e52"
        font {
            pointSize: 20
            family: "Renogare"
        } anchors {
            bottom: overlay.bottom
            bottomMargin: root.height * 0.01
            horizontalCenter: overlay.horizontalCenter
        }
    }

    Rectangle {
        x: 0.635 * root.width - width / 2
        width: root.width * 0.4
        anchors.verticalCenter: root.verticalCenter

        Rectangle {
            id: cursor
            width: parent.width * 0.02
            height: main.height
            color: "#5c3e52"
            anchors.centerIn: parent
            Timer {
                repeat: true
                running: true
                interval: 200
                onTriggered: {
                    if (selected && password.length == 0) cursor.visible = !cursor.visible
                    else cursor.visible = false
                }
            }
        }

        Text {
            id: main
            color: "#5c3e52"
            font {
                pointSize: 34
                family: "Renogare"
            } anchors.centerIn: parent
            width: parent.width
            fontSizeMode: Text.HorizontalFit
            text: root.username

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        AnimatedImage {
            id: run_animation
            scale: 0.5
            anchors.centerIn: cursor
            source: "../assets/run.gif"
            visible: lock
        }
    }

    property bool selected: false
    property bool animating: false

    function select() {
        selected = true
        password = ""
        main.text = Qt.binding(function() {
            if (password.length > 15) return "\u25cf".repeat(15) + "..."
            return "\u25cf".repeat(password.length)
        })
    }

    function deleteChar() {
        if (password == "") return
        password = password.substring(0, password.length-1)
    }

    function deselect() {
        password = ""
        selected = false
        main.text = username
    }

    Keys.onPressed: (kev) => {
        kev.accepted = true
        if (lock) return
        if (selected && kev.key == Qt.Key_Backspace) deleteChar()
        if (kev.isAutoRepeat) return

        // printable character
        if (selected && kev.key >= 0x20 && kev.key < 0x7c) {
            password += kev.text
            cursor.visible = false
        }

        if (selected) {
            switch (kev.key) {
                case Qt.Key_Escape: case Qt.Key_Left:
                    deselect()
                    break
                case Qt.Key_Return: case Qt.Key_Enter: case Qt.Key_Right:
                    lock = true
                    login()
            }
        } else {
            switch (kev.key) {
                case Qt.Key_Escape: case Qt.Key_X:
                    exit()
                    break
                case Qt.Key_Return: case Qt.Key_Enter: case Qt.Key_C:
                    select()
                    break
                case Qt.Key_Left: case Qt.Key_A: case Qt.Key_H:
                case Qt.Key_Up: case Qt.Key_W: case Qt.Key_K:
                    prev()
                    break
                case Qt.Key_Down: case Qt.Key_S: case Qt.Key_J:
                case Qt.Key_Right: case Qt.Key_D: case Qt.Key_L:
                    next()
                    break
            }
        }
    }

    function left_in() { scroll.play(); left_in_animation.start() }
    function left_out() { left_out_animation.start() }
    function right_in() { scroll.play(); right_in_animation.start() }
    function right_out() { right_out_animation.start() }

    NumberAnimation on x {
        running: false
        id: left_in_animation
        from: leftX; to: middleX
        duration: aDuration
        easing.type: Easing.OutQuad
        onStarted: animating = true
        onStopped: {
            animating = false
            if (!focus) hide()
        }
    } NumberAnimation on x {
        running: false
        id: left_out_animation
        from: middleX; to: leftX
        duration: aDuration
        easing.type: Easing.InQuad
    } NumberAnimation on x {
        running: false
        id: right_in_animation
        from: rightX; to: middleX
        duration: aDuration
        easing.type: Easing.OutQuad
        onStarted: animating = true
        onStopped: {
            animating = false
            if (!focus) hide()
        }
    } NumberAnimation on x {
        running: false
        id: right_out_animation
        from: middleX; to: rightX
        duration: aDuration
        easing.type: Easing.InQuad
    }

    SFX {
        id: scroll
        source: "../assets/sfx/scroll.wav"
    }
}
