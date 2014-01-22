// *************************************************** //
// Notification Menu Component
//
// The notification menu component shows a number of items
// in a sliding out context menu.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import QtShareHelper 1.0
import QtNetworkHelper 1.0

import "../pages"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication

ContextMenu {
    id: locationContextMenu

    // data passed from the pages to the menu and vice versa
    property string origin: ""
    property variant additionaldata: ""
    property bool requiresUpdate: false

    // make visibility of menu items accessible from pages
    // property alias shareVisible: menuitemShareImage.visible

    // this contains the individual menu items
    MenuLayout {

        // jump to map detail page
        MenuItem {
            id: menuitemMapDetail

            text: "Show large map"
            visible: true

            onClicked:
            {
                pageStack.push(Qt.resolvedUrl("../pages/MapDetailPage.qml"), {imageMetadata: additionaldata});
            }
        }


        // open in maps
        MenuItem {
            id: menuitemOpenInMaps

            text: "Open in Nokia Maps"
            visible: true

            onClicked: {
                // call the Maps application
                // note that this will not work in the simulator
                Qt.openUrlExternally("geo:" + additionaldata.latitude + "," +  + additionaldata.longitude);
            }
        }
    }
}
