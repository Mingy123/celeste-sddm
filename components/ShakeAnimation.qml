import QtQuick 2.9

SequentialAnimation {
    property int length: 200
    property double value
    property double shake

    running: false

    NumberAnimation {
        from: value; to: value+shake
        duration: length * 0.15
    }
    NumberAnimation {
        from: value+shake; to: value-shake
        duration: length * 0.5
    }
    NumberAnimation {
        from: value-shake; to: value
        duration: length * 0.35
    }
}
