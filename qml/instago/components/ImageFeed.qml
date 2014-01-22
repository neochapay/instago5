// *************************************************** //
// Image Feed Component
//
// The image feed component is used by the application
// pages. It displays a number of given images in a
// user feed list.
// The list is flickable and clips.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0
import QtMobility.feedback 1.1

import "../pages"
import "../global/globals.js" as Globals
import "../models/likes.js" as Likes

Rectangle {
    id: imageFeed;

    // signal to clear the gallery contents
    signal clearFeed()
    onClearFeed: {
        feedListModel.clear();
    }

    // signal to add a new item
    // item is given as array:
    // "url":IMAGE_URL;
    // "index":IMAGE_ID
    signal addToFeed( variant items )
    onAddToFeed: {
        feedListModel.append(items);
    }

    // jump to the top of the gallery
    signal jumpToTop()
    onJumpToTop: {
        feedList.positionViewAtBeginning();
    }

    // feed requires update for some reason
    signal feedRequiresUpdate()

    // general list properties
    property alias numberOfItems: feedListModel.count;

    // signal if item was clicked
    signal itemClicked( string imageId );

    // signal if gallery is scrolled to the end
    signal feedBottomReached();

    // property that holds the id of the next image
    // this is given by Instagram for easy pagination
    property string paginationNextMaxId: "";

    // general style definition
    color: "transparent"


    // this is the main container component
    // it contains the actual gallery items
    Component {
        id: feedDelegate

        // this is an individual feed item
        Item {
            id: feedItem
            width: feedList.width
            height: 640

            // actual image component
            // this does all the ui stuff for the image and metadata
            ImageDetails {
                id: imageData

                // anchors.fill: parent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                originalImage: d_originalImage
                linkToInstagram: d_linkToInstagram
                imageId: d_imageId;
                username: d_username;
                profilePicture: d_profilePicture;
                location: d_location;
                locationId: d_locationId;
                elapsedtime: d_elapsedtime;
                userId: d_userId;
                likes: d_likes + " people liked this";
                comments: d_comments + " comments";
                caption: d_caption;
                userHasLiked: d_userhasliked;

                onDetailImageDoubleClicked: {
                    notification.text = "Added photo to your favourites";
                    notification.show();

                    Likes.likeImage(imageId, false);
                }

                onDetailImageLongPress: {
                    hapticFeedback.running = true;

                    menu.origin = imageId;
                    menu.additionaldata = {
                        "caption":caption,
                        "linkToInstagram":linkToInstagram
                    };

                    // activate additional menu items according to the state
                    if (userHasLiked)
                    {
                        menu.unlikeVisible = true;
                        menu.likeVisible = false;
                    }
                    else
                    {
                        menu.unlikeVisible = false;
                        menu.likeVisible = true;
                    }

                    menu.open();
                }

                onCaptionChanged: {
                    // this is magic: since metadataImageCaption.height gives me garbage I calculate the height by multiplying the number of lines with the line height
                    var numberOfLines = 0;

                    // clear style information
                    var rawCaption = caption.replace(Globals.instagoDefaultRichTextStyle, "");
                    rawCaption = rawCaption.replace(Globals.instagoRichTextClosure, "");

                    // check how many lines the user manually added with line breaks
                    // note that all \n have been replaced with <br /> in Helpermethods.replaceLineBreaks()
                    var captionLines = new Array();
                    captionLines = rawCaption.split("<br />");

                    // regex to remove html tags (links, mostly)
                    var regex = /(<([^>]+)>)/ig;

                    // walk through each line and check how long they are and if they wrap around
                    for (var lineIndex in captionLines)
                    {
                        var rawLine = captionLines[lineIndex].replace(regex, "");
                        numberOfLines += Math.floor( (rawLine.length / 45) + 1 );
                        // console.log(rawLine + " = " + numberOfLines);
                    }

                    // transform the number of lines into the actual height
                    var captionheight = numberOfLines * 25;

                    // the new height of the caption item is added to the calculated by the ImageDetails component
                    var newheight = itemheight + captionheight + 80;

                    // that number is fed to the current feed item container as height
                    feedItem.height = newheight;
                }
            }
        }
    }


    // this is just an id
    // the model is defined in the array
    ListModel {
        id: feedListModel
    }


    // the actual grid view
    // this contains the individual items and shows them as a list
    ListView {
        id: feedList

        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        focus: true

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // check if list is at the bottom end
        onMovementEnded: {
            if(atYEnd) {
                feedBottomReached();
            }
        }

        // define model and delegate
        model: feedListModel
        delegate: feedDelegate
    }


    // standard context menu
    NotificationImageMenu {
        id: menu

        // reload list when user did a selection
        onStatusChanged: {
            // console.log("clicked " + status + " and requires update: " + requiresUpdate);

            if ( (status === 3) && (requiresUpdate) )
            {
                feedRequiresUpdate();
                requiresUpdate = false;
            }
        }
    }


    // standard haptics effect for haptic feedback
    HapticsEffect {
        id: hapticFeedback

        attackIntensity: 0.0
        attackTime: 250
        intensity: 1.0
        duration: 100
        fadeTime: 250
        fadeIntensity: 0.0
    }
}
