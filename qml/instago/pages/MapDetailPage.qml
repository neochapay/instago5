// *************************************************** //
// Location Detail Page
//
// The location detail page shows generic information
// about a given location as well as images associated
// with this location id.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0
import QtMobility.location 1.2

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication
import "../models/locations.js" as Location

Page {
    // use the detail view toolbar
    tools: locationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // the array containing the image information
    // the property will be filled by the calling page
    property variant imageMetadata: "";

    // check if the user is already logged in
    Component.onCompleted: {
        // fill the location data for the given location
        locationCenter.position.coordinate.latitude = imageMetadata.latitude;
        Location.locationLatitude = imageMetadata.latitude;
        locationCenter.position.coordinate.longitude = imageMetadata.longitude;
        Location.locationLongitude = imageMetadata.longitude;
        locationMap.center = locationCenter.position.coordinate;
        pageHeader.text = imageMetadata.name;
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Location"

        onHeaderBarClicked: {
            Location.recenterLocationMap();
        }
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }

    // general container for the map components
    Rectangle {
        id: locationMapContainer

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        // the position of the location
        // this is used by the map as center
        PositionSource {
            id: locationCenter
        }


        // the actual map module
        // note that location shown in the center of the map  is defined by the position source
        Map {
            id: locationMap

            anchors.fill: parent

            plugin : Plugin {name : "nokia"}
            connectivityMode: Map.HybridMode

            zoomLevel: 15
            center: locationCenter.position.coordinate

            onZoomLevelChanged: {
                // console.log("zl: " + zoomLevel);
                var newPositionRadius = Math.pow(2, (18 - zoomLevel));
                newPositionRadius *= 5;
                locationMapVenuePosition.radius = newPositionRadius;
            }


            // marker for the current location on the map
            MapCircle {
                id: locationMapVenuePosition

                color: Globals.instagoHighlightedTextColor
                border.color: Globals.instagoMeegoDimmedIconColor
                border.width: 2

                radius: 40.0
                center: locationCenter.position.coordinate
                z: 2
            }
        }


        // this is the pincharea to zoom the map
        PinchArea {
            id: locationMapPinchManipulation

            property double locationMapLastZoom

            anchors.fill: parent

            function calcZoomDelta(zoom, percent)
            {
                // console.log("z: " + zoom + " p: " + percent + " c: " + (Math.log(percent)/Math.log(1.5)));
                return zoom + Math.log(percent)/Math.log(1.5)
            }

            onPinchStarted: {
                locationMapLastZoom = locationMap.zoomLevel
            }

            onPinchUpdated: {
                locationMap.zoomLevel = calcZoomDelta(locationMapLastZoom, pinch.scale);
            }

            onPinchFinished: {
                locationMap.zoomLevel = calcZoomDelta(locationMapLastZoom, pinch.scale);
            }
        }


        // this is the mousearea to pan the map around
        MouseArea {
            id: locationMapPanManipulation

            anchors.fill : parent

            property int locationMapLastX: -1
            property int locationMapLastY: -1

            onPressed: {
                locationMapLastX = mouseX
                locationMapLastY = mouseY
            }

            onPositionChanged: {
                var locationMapNewX = mouseX - locationMapLastX
                var locationMapNewY = mouseY - locationMapLastY

                locationMap.pan(-locationMapNewX, -locationMapNewY)

                locationMapLastX = mouseX
                locationMapLastY = mouseY
            }
        }
    }

    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  false
        visible: false
    }


    // error indicator that is shown when a network error occured
    ErrorMessage {
        id: errorMessage

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            errorMessage.visible = false;
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            Location.getLocationData(locationId, 0);
        }
    }


    // page specific toolbar
    ToolBarLayout {
        id: locationToolbar

        // jump back
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
