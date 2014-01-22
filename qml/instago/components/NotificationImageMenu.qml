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
import "../models/likes.js" as Likes

ContextMenu {
    id: imageContextMenu

    // data passed from the pages to the menu and vice versa
    property string origin: ""
    property variant additionaldata: ""
    property bool requiresUpdate: false

    // make visibility of menu items accessible from pages
    property alias likeVisible: menuitemLikeImage.visible
    property alias unlikeVisible: menuitemUnlikeImage.visible

    // this contains the individual menu items
    MenuLayout {

        // jump to image detail page
        MenuItem {
            id: menuitemImageDetail

            text: "Show details"
            visible: true

            onClicked:
            {
                pageStack.push(Qt.resolvedUrl("../pages/ImageDetailPage.qml"), {imageId: origin});
            }
        }


        // like image
        MenuItem {
            id: menuitemLikeImage

            text: "Add to favorites"
            visible: false

            onClicked: {
                notification.text = "Added photo to your favourites";
                notification.show();

                requiresUpdate = true;

                Likes.likeImage(origin, false);
            }
        }


        // remove image from likes
        MenuItem {
            id: menuitemUnlikeImage

            text: "Remove from favorites"
            visible: false

            onClicked: {
                notification.text = "Removed photo from your favourites"
                notification.show();

                requiresUpdate = true;

                Likes.unlikeImage(origin, false);
            }


            // this is the network helper component that makes the network helper methods available
            NetworkHelper {
                id: networkHelper
            }
        }


        // share image
        MenuItem {
            id: menuitemShareImage

            text: "Share image"
            visible: true

            onClicked: {
                // call the share dialog
                // note that this will not work in the simulator
                menuShareHelper.shareURL("Instago Link", additionaldata.caption, additionaldata.linkToInstagram);
            }


            // this is the share helper component that makes the share dialog available
            ShareHelper {
                id: menuShareHelper
            }
        }
    }
}
