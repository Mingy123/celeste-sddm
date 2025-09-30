import QtMultimedia

// wrapper class for sfx items
// use play() to buffer it
MediaPlayer {
    id: audio
    audioOutput: AudioOutput {}
}
