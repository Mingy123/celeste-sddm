import QtMultimedia 5.15

// wrapper class for sfx items
// use play() to buffer it
Audio {
    id: audio
    muted: true
    playbackRate: 10
    onStopped: {
        playbackRate = 1
        muted = false
    }
}
