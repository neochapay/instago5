// *************************************************** //
// Notification Area Component
//
// The notification component shows a simple
// notification rectangle with text.
// It's similar to the QML InfoBanner component but
// has more control over color and animation.
// *************************************************** //

import QtQuick 2.0

import "../pages"
import "../global/globals.js" as Globals

Rectangle {
    id: notificationArea

    // actual notification text
    property alias text: notificationText.text

    // fade time for fade in and out
    property int fadetime: 100

    // colors and background of the notification area
    property alias textcolor: notificationText.color
    property alias backgroundcolor: notificationArea.color
    property alias backgroundimage: notificationImage.source

    // time the notification is shown in ms
    property alias visibilitytime: notificationTimer.interval
    property bool useTimer: true

    // signal to show the notification
    signal show();
    onShow: {
        // console.log("Showing notification");
        notificationInAnimation.start();
        notificationInOpacity.start()
        notificationArea.visible = true;
        if (useTimer === true) { notificationTimer.running = true; }
    }

    // signal to hide the notification
    signal hide();
    onHide: {
        // console.log("Hiding notification");
        notificationOutAnimation.start();
        notificationOutOpacity.start()
        notificationTimer.running = false;
    }

    // general properties
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5

    height: 70

    color: "black"

    visible: false
    z: 100

    border.color: "transparent"
    radius: 10


    // background image
    Image {
        id: notificationImage
        source:  ""

        anchors.fill: parent
    }


    // notification text
    Text {
        id: notificationText
        text: ""

        anchors {
            left: parent.left;
            leftMargin: 10;
            right: parent.right;
            rightMargin: 10;
            verticalCenter: parent.verticalCenter;
        }

        font.family: "Nokia Pure Text"
        font.pixelSize: 25
        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        color: "white"
    }


    // slide in animation
    PropertyAnimation {
        id: notificationInAnimation;
        target: notificationArea;
        property: "height";
        from: 0;
        to: 80;
        duration: notificationArea.fadetime
    }


    // fade in animation
    NumberAnimation {
        id: notificationInOpacity
        target: notificationArea
        properties: "opacity"
        from: 0
        to: 0.9
        duration: notificationArea.fadetime
    }


    // slide out animation
    PropertyAnimation {
        id: notificationOutAnimation;
        target: notificationArea;
        property: "height";
        from: 80;
        to: 0;
        duration: notificationArea.fadetime
    }


    // fade out animation
    NumberAnimation {
        id: notificationOutOpacity
        target: notificationArea
        properties: "opacity"
        from: 0.9
        to: 0
        duration: notificationArea.fadetime

        /*onCompleted: {
            notificationArea.visible = false;
        }*/
    }


    // notification timer
    Timer {
        id: notificationTimer
        interval: 1000
        running: false
        repeat:  false

        onTriggered: {
            notificationOutAnimation.start();
            notificationOutOpacity.start();
        }
    }
}

