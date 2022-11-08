# Celeste theme for SDDM

SDDM theme trying to replicate Celeste

![preview1](preview1.png)
![preview2](preview2.png)

There is a lite branch with a less intensive version, e.g. less animations and sfx

### Usage

You can navigate with WASD/HJKL/UpDownLeftRight buttons; Enter/C and Escape/X for "forward" and "backward" respectively.

On selecting a card (with username on it), you can input password. Press Enter to login.

### Dependencies (credits: 3ximus)

It is necessary to have the Phonon GStreamer backend for qt5, GStreamer ffmpeg Plugin and GStreamer Plugins Good
- Arch linux : `pacman -S gst-libav phonon-qt5-gstreamer gst-plugins-good qt5-quickcontrols qt5-graphicaleffects qt5-multimedia`
- Gentoo : these settings allowed me to make the theme work

    * `media-libs/gst-plugins-good`
    * `USE="alsa gstreamer qml widgets" dev-qt/qtmultimedia`
    * `USE="widgets" dev-qt/qtquickcontrols`
    * `dev-qt/qtgraphicaleffects`
    * `USE="gstreamer" media-libs/phonon`
    * `media-plugins/gst-plugins-openh264` (optional for video)
    * `media-plugins/gst-plugins-libde265` (optional for video)

 - Kubuntu: `apt install gstreamer1.0-libav phonon4qt5-backend-gstreamer gstreamer1.0-plugins-good qml-module-qtquick-controls qml-module-qtgraphicaleffects qml-module-qtmultimedia qt5-default`
 - Lubuntu 22.04: `sudo apt-get install gstreamer1.0-libav qml-module-qtmultimedia libqt5multimedia5-plugins`
 - Fedora 36 LXQt spin: `sudo dnf install git qt5-qtgraphicaleffects qt5-qtquickcontrols gstreamer1-libav`. Make sure setup [RPM Fusion Repo](https://rpmfusion.org/Configuration) first to get gstreamer1-libav package.

Havent tried other distros...

### Installation
Clone the repository:
`git clone https://github.com/Mingy123/celeste-sddm`

Extract background.mp4:
```
cd celeste-sddm/assets
7z x out.zip.001
cd ../..
```

Copy into `/usr/share/sddm/themes/`:
`cp -r celeste-sddm /usr/share/sddm/themes`

Edit /etc/sddm.conf:
`Current=celeste-sddm`

*Note that super user privileges are needed.*

The theme can be tested by running `sddm-greeter --test-mode --theme <path-to-this-repository>`
