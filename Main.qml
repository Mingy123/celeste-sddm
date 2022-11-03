import QtQuick 2.9
import QtMultimedia 5.15
import "components"

Item {
    id: root
    width: 1920; height: 1080
    property Item selitem: login_button
    property Item selcard
    property int card: 0
    Component.onCompleted: {
        background.play()
        wind.play(); bgm.play()
        bufferSFX()
        login_button.focus = true

        // set the lastUser
        for (var i = 0; i < userModel.count; i++) {
            if (users.itemAt(i).username == userModel.lastUser) {
                card = i
                break
            }
        }

        var screen = screenModel.geometry(screenModel.primary)
        if (screen.width / screen.height > 9/16)
            scale.xScale = screen.width / 1920
        else
            scale.xScale = screen.height / 1080
    }

    transform: Scale {
        id: scale
        yScale: xScale
    }



    function changeFocus(item) {
        move.play()
        selitem.deselectAnimation()
        item.selectAnimation()
        item.focus = true
        selitem = item
    }

    Timer {
        id: timer
        repeat: true
        interval: 100
        running: true
        onTriggered: {
            root.selitem.selectColor =
                String(root.selitem.selectColor) == "#ffff8b" ?
                "#9aff84" : "#ffff8b"
        }
    }

    FontLoader {source: "assets/celeste.otf"}
    Video {
        id: background
        loops: MediaPlayer.Infinite
        anchors.fill: parent
        source: "assets/background.mp4"
    } Audio {
        id: bgm
        source: "assets/bgm.wav"
        loops: Audio.Infinite
    } Audio {
        id: wind
        source: "assets/wind.wav"
        loops: Audio.Infinite
    } Audio {
        id: secret
        source: "assets/wow_so_secret.wav"
        loops: Audio.Infinite
    }

    function bufferSFX() {
        move.play()
        whooshIn.play()
        whooshOut.play()
        back.play()
        login.play()
        invalid.play()
        select.play()
        success.play()
    } SFX {
        id: move
        source: "assets/sfx/move.wav"
    } SFX {
        id: whooshIn
        source: "assets/sfx/whooshIn.wav"
    } SFX {
        id: whooshOut
        source: "assets/sfx/whooshOut.wav"
    } SFX {
        id: back
        source: "assets/sfx/back.wav"
    } SFX {
        id: invalid
        source: "assets/sfx/invalid.wav"
    } SFX {
        id: select
        source: "assets/sfx/select.wav"
    } SFX {
        id: login
        source: "assets/sfx/login.wav"
    } SFX {
        id: success
        source: "assets/sfx/success.wav"
    }

    Column {
        x: root.width * 0.1
        y: root.height * 0.15
        id: login_button
        // putting them together for animation
        spacing: root.height * 0.01
        property color selectColor: "#ffff8b"
        Component.onCompleted: {
            y_bob.value = y
            icon_out.from = x
            icon_out.to = -x -width
            icon_in.to = x
            icon_in.from = -x -width
        }
        
        function selectAnimation() { y_bob.start() }
        function deselectAnimation() { y_bob.stop() }
        ShakeAnimation on y {
            id: y_bob
            length: 200
            shake: root.height * 0.01
        }

        SequentialAnimation on x {
            running: false
            id: icon_in
            property real from; property real to
            PauseAnimation { duration: 100 }
            NumberAnimation {
                duration: 200
                from: icon_in.from
                to: icon_in.to
                easing.type: Easing.OutQuad
            }
        } SequentialAnimation on x {
            running: false
            id: icon_out
            property real from; property real to
            NumberAnimation {
                duration: 200
                from: icon_out.from
                to: icon_out.to
                easing.type: Easing.InQuad
            } PauseAnimation { duration: 100 }
        }

        Image {
            id: login_icon
            source: "assets/mountain.png"
            // create the fucking impossible animation
            SequentialAnimation on rotation {
                id: icon_shake
                running: false
                property int length: 400
                RotationAnimation {
                    from: 10; to: -7
                    duration: icon_shake.length * 0.4
                    easing.type: Easing.InOutQuad
                } RotationAnimation {
                    from: -7; to: 4.5
                    duration: icon_shake.length * 0.25
                    easing.type: Easing.InOutQuad }
                RotationAnimation {
                    from: 4.5; to: -2
                    duration: icon_shake.length * 0.25
                    easing.type: Easing.InOutQuad
                } RotationAnimation {
                    from: -2; to: 0
                    duration: icon_shake.length * 0.1
                    easing.type: Easing.InOutQuad
                } PauseAnimation { duration: 100 }
            }

            SequentialAnimation on y {
                id: icon_bob
                running: false
                property int length: 400
                property real value: 0
                property real amp: -40
                NumberAnimation {
                    from: icon_bob.value + icon_bob.amp; to: icon_bob.value
                    duration: icon_bob.length * 0.5
                    easing.type: Easing.InQuad
                } NumberAnimation {
                    from: icon_bob.value; to: icon_bob.amp * 0.4 + icon_bob.value
                    duration: icon_bob.length * 0.30
                    easing.type: Easing.OutQuad
                } NumberAnimation {
                    from: icon_bob.value + icon_bob.amp * 0.4; to: icon_bob.value
                    duration: icon_bob.length * 0.20
                }
            }
        }


        Text {
            text: "LOGIN"
            color: parent.focus ? parent.selectColor : "white"
            font { pointSize: 48; family: "Renogare" }
            style: Text.Outline
            styleColor: "black"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Keys.onPressed: (event) => {
            if (event.isAutoRepeat) return;
            switch (event.key) {
                case Qt.Key_Return: case Qt.Key_Enter: case Qt.Key_C:
                case Qt.Key_Right: case Qt.Key_D: case Qt.Key_L:
                    show_login()
                    break
                case Qt.Key_Up: case Qt.Key_W: case Qt.Key_K:
                    root.changeFocus(sleep_button)
                    break
                case Qt.Key_Down: case Qt.Key_S: case Qt.Key_J:
                    root.changeFocus(shutdown_button)
                    break
            }
        }
    }

    Column {
        id: intro_vbox
        x: root.width * 0.095
        y: root.height * 0.46
        spacing: root.height * 0.025

        Component.onCompleted: {
            vbox_out.from = x
            vbox_out.to = -x -width
            vbox_in.to = x
            vbox_in.from = -x -width
        }

        SequentialAnimation on x {
            running: false
            id: vbox_in
            property real from; property real to
            PauseAnimation { duration: 100 }
            NumberAnimation {
                duration: 200
                from: vbox_in.from
                to: vbox_in.to
                easing.type: Easing.OutQuad
            }
        }
        NumberAnimation on x { running: false; id: vbox_out; duration: 200; easing.type: Easing.InQuad }

        IconLabel {
            id: shutdown_button
            text: "Shutdown"
            onUp: changeFocus(login_button)
            onDown: changeFocus(reboot_button)
            image: "assets/shutdown.png"

            onEnter: {
                if (!sddm.canPowerOff) {
                    invalid.stop(); invalid.play()
                } else {
                    select.play()
                    sddm.powerOff()
                }
            }
        }

        IconLabel {
            id: reboot_button
            text: "Reboot"
            onUp: changeFocus(shutdown_button)
            onDown: changeFocus(sleep_button)
            image: "assets/reboot.png"

            onEnter: {
                if (!sddm.canReboot) {
                    invalid.stop(); invalid.play()
                } else {
                    select.play()
                    sddm.reboot()
                }
            }
        }

        IconLabel {
            id: sleep_button
            text: "Sleep"
            onUp: changeFocus(reboot_button)
            onDown: changeFocus(login_button)
            image: "assets/sleep.png"

            onEnter: {
                if (!sddm.canSuspend) {
                    invalid.stop(); invalid.play()
                } else {
                    select.play()
                    sddm.suspend()
                }
            }
        }
    }



    property bool animating: false
    function show_login() {
        if (animating) return
        login.stop(); login.play()
        animating = true
        icon_shake.start()
    }

    // deprecated in newer versions
    Connections {
        target: icon_shake
        onStarted: {
            icon_bob.start()
            vbox_out.start()
        } onFinished: {
            icon_out.start()
        }
    } Connections {
        target: icon_out
        onFinished: {
            whooshIn.play()
            selcard = users.itemAt(card)
            selcard.right_in()
            selcard.focus = true
            animating = false
        }
    } Connections {
        target: sddm
        onLoginSucceeded: success.play()
        onLoginFailed: {
            selcard.deselect()
        }
    }

    function cards_animating() {
        for (var i = 0; i < userModel.count; i++) {
            if (users.itemAt(i).animating) return true
        } return false
    }

    function exit_login() {
        if (animating) return
        if (cards_animating()) return
        whooshOut.play()
        back.play()
        selcard.right_out()
        vbox_in.start()
        icon_in.start()
        selcard.x = -selcard.width
        selitem.focus = true
    }

    function card_next() {
        if (++card >= userModel.count) card = 0
        selcard.left_out()
        selcard = users.itemAt(card)
        selcard.right_in()
        selcard.focus = true
    } function card_prev() {
        if (--card < 0) card = userModel.count-1
        selcard.right_out()
        selcard = users.itemAt(card)
        selcard.left_in()
        selcard.focus = true
    }

    Repeater {
        id: users
        model: userModel
        delegate: Card {
            username: model.name
            icon: model.icon
            anchors.verticalCenter: parent.verticalCenter
            // i need to hide this for now
            x: -width
            onPrev: card_prev()
            onNext: card_next()
            onExit: exit_login()
            onHide: selcard.x = -selcard.width

            onLogin: sddm.login(username, password, sessionModel.lastIndex)
        }
    }

    // to hide the mouse
    MouseArea {
        anchors.fill: parent
        enabled: false
        cursorShape: Qt.BlankCursor
    }
}
