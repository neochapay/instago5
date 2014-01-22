// *************************************************** //
// Imagedetail Script
//
// This script is used to load, format and show image
// related data.
// Its used by the ImageDetailPage.
// *************************************************** //


// include other scripts used here
Qt.include("../global/instagramkeys.js");
Qt.include("../classes/authenticationhandler.js");
Qt.include("../classes/helpermethods.js");
Qt.include("../classes/networkhandler.js");


// load an image with a given Instagram media id
// the image data will be used to fill the ImageDetailPage
// note that the image data is different for an authenticated
// user vs an unknown one
function loadImage(imageId)
{
    // console.log("Loading image " + imageId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    // get image object
                    var imageCache = new Array();
                    imageCache = getImageDataFromObject(jsonObject.data);

                    // apply image object to page components
                    imageData.originalImage = imageCache["originalimage"];
                    imageData.imageId = imageCache["imageid"];
                    imageData.username = imageCache["username"];
                    imageData.profilePicture = imageCache["profilepicture"];
                    imageData.userId = imageCache["userid"];
                    imageData.comments = imageCache["comments"] + " comments";
                    imageData.likes = imageCache["likes"] + " people liked this";
                    imageData.linkToInstagram = imageCache["linktoinstagram"];
                    imageData.caption = imageCache["caption"];
                    imageData.originalCaption = imageCache["originalCaption"];
                    imageData.location = imageCache["location"];
                    imageData.locationId = imageCache["locationId"];
                    imageData.elapsedtime = imageCache["elapsedtime"];

                    // if they don't have an Instagram page, the share button needs to be deactivated
                    if (imageCache["linktoinstagram"] === "")
                    {
                        iconShare.visible = false;
                        iconShareDeactivated.visible = true;
                    }

                    // check if the user is authenticated
                    // if so, show the like buttons
                    if (auth.isAuthenticated())
                    {
                        // check if user has already liked the image and set icons accordingly
                        if (imageCache["userhasliked"])
                        {
                            iconLiked.visible = true;
                        }
                        else
                        {
                            iconUnliked.visible = true;
                        }
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    contentFlickableContainer.visible = true;

                    // console.log("Done loading image");
                }
                else
                {
                    // either the request is not done yet or an error occured
                    // check for both and act accordingly
                    if ( (network.requestIsFinished) && (network.errorData['code'] != null) )
                    {
                        // console.log("error found: " + network.errorData['error_message']);

                        // hide messages and notifications
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;

                        // show the stored error
                        errorMessage.showErrorMessage({
                                                          "d_code":network.errorData['code'],
                                                          "d_error_type":network.errorData['error_type'],
                                                          "d_error_message":network.errorData['error_message']
                                                      });

                        // clear error message objects again
                        network.clearErrors();
                    }
                }
            }

    // only authenticated users have user_has_liked nodes in their response data
    // thus the request should be done with the access token whenever possible
    var url = "";
    if (auth.isAuthenticated())
    {
        var instagramUserdata = auth.getStoredInstagramData();
        url = instagramkeys.instagramAPIUrl + "/v1/media/" + imageId + "/?access_token=" + instagramUserdata["access_token"];
    }
    else
    {
        url = instagramkeys.instagramAPIUrl + "/v1/media/" + imageId + "/?client_id=" + instagramkeys.instagramClientId;
    }

    req.open("GET", url, true);
    req.send();
}
