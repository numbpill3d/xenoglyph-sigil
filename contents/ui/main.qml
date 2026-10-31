/*
 * Xenoglyph Sigil — a turning sigil with a blinking red eye, and the time
 * written as Daedric words. Hover and the script resolves into Latin.
 */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    readonly property color ink: "#141016"
    readonly property color ichor: "#d3122b"
    property date now: new Date()
    readonly property var ones: ["", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN",
        "ELEVEN", "TWELVE", "THIRTEEN", "FOURTEEN", "FIFTEEN", "SIXTEEN", "SEVENTEEN", "EIGHTEEN", "NINETEEN"]
    readonly property var tens: ["", "", "TWENTY", "THIRTY", "FORTY", "FIFTY"]
    function word(n) {
        if (n < 20) return ones[n]
        return tens[Math.floor(n / 10)] + (n % 10 ? " " + ones[n % 10] : "")
    }
    readonly property string phrase: {
        const h = now.getHours(), m = now.getMinutes()
        const hw = h === 0 ? "NULL" : word(h)
        return m === 0 ? hw + " HOLLOW" : hw + "  " + (m < 10 ? "OH " : "") + word(m)
    }
    toolTipMainText: phrase.toLowerCase()
    toolTipSubText: Qt.formatDate(now, "dddd d MMMM")

    Timer { interval: 1000; running: true; repeat: true; onTriggered: root.now = new Date() }
    FontLoader { id: daedric; source: Qt.resolvedUrl("../art/OMWAyembedt.otf") }

    fullRepresentation: MouseArea {
        id: area
        hoverEnabled: true
        readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
        readonly property real thick: vertical ? width : height
        Layout.preferredWidth: vertical ? -1 : row.implicitWidth + 6
        Layout.preferredHeight: vertical ? sig.height + 4 : -1
        Layout.minimumWidth: vertical ? -1 : sig.width

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 6
            Item {
                id: sig
                width: Math.max(16, area.thick * 0.98); height: width
                anchors.verticalCenter: parent.verticalCenter
                component L: Image {
                    anchors.fill: parent
                    sourceSize: Qt.size(Math.ceil(sig.width * 2), Math.ceil(sig.width * 2))
                    smooth: true; antialiasing: true
                }
                L { source: "../art/ring-blades.svg"
                    RotationAnimator on rotation { from: 0; to: 360; duration: 40000; loops: Animation.Infinite; running: true } }
                L { source: "../art/ring-ichor.svg"; scale: 1.15
                    RotationAnimator on rotation { from: 360; to: 0; duration: 14000; loops: Animation.Infinite; running: true } }
                L { source: "../art/core.svg"; scale: 1.25 }
                Item {
                    anchors.fill: parent; scale: 1.25
                    transform: Scale { id: lid; origin.x: sig.width / 2; origin.y: sig.height / 2 }
                    L { source: "../art/lens.svg" }
                    L { source: "../art/pupil.svg" }
                    SequentialAnimation {
                        running: true; loops: Animation.Infinite
                        PauseAnimation { duration: 6100 }
                        NumberAnimation { target: lid; property: "yScale"; to: 0.05; duration: 80 }
                        NumberAnimation { target: lid; property: "yScale"; to: 1; duration: 170 }
                    }
                }
            }
            Text {
                visible: !area.vertical
                anchors.verticalCenter: parent.verticalCenter
                text: area.containsMouse ? root.phrase.toLowerCase() : root.phrase
                font.family: area.containsMouse ? "DepartureMono Nerd Font" : daedric.name
                font.pixelSize: area.containsMouse ? 11 : Math.max(10, area.thick * 0.5)
                color: area.containsMouse ? root.ichor : root.ink
                Behavior on color { ColorAnimation { duration: 220 } }
            }
        }
    }
}
