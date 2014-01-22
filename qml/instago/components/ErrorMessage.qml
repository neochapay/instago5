// *************************************************** //
// Error Message Component
//
// Generic error message component that is used when
// something went wrong, mostly regarded to loading
// Instagram data.
// A notification rectangle with text is shown.
// This is most likely the case when the network went
// away.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1

import "../pages"
import "../global/globals.js" as Globals

Rectangle  {
    id: errorMessage

    // error message text
    property alias headline: errorMessageHeadline.text
    property alias text: errorMessageText.text

    // shows an error message based on the given data
    // instagramResponse is the raw response from the Instagram server
    // this might be empty
    signal showErrorMessage( variant errordata );

    // logic for the showErrorMessage signal
    // this extracts the Instagram error response (if there is any)
    // and adds it to the error message texts
    onShowErrorMessage: {
        // make sure only one error message is shown
        // if one is already active, don't show another one
        if (!errorMessage.visible)
        {
            errorMessageText.text = "Please check your network connection and tap to try again.";

            if (errordata['d_error_message'].length > 0)
            {
                errorMessageText.text += "<br /><br />Instagram says: <i>" + errordata['d_error_message'] + "</i>";
            }

            errorMessage.visible = true;
        }
    }

    // signal to indicate tap on message
    signal errorMessageClicked();

    // no background color
    color: "transparent"


    // error message headline
    Text {
        id : errorMessageHeadline

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: errorMessageText.top
            bottomMargin: 20
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.WordWrap
        color: Globals.instagoDefaultTextColor

        text: "Can't load data from Instagram";
    }


    // actual error message text
    Text {
        id : errorMessageText

        anchors {
            centerIn: parent
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text"
        font.pixelSize: 20
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        color: Globals.instagoDefaultTextColor

        text: "";
    }


    // the error text is a tap area that calls the reload function
    MouseArea {
        anchors.fill: parent

        onClicked:
        {
            errorMessageClicked();
        }
    }
}
