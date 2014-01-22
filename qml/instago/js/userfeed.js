// *************************************************** //
// Userfeed Script
//
// This script is used to load, format and show the
// user related feed.
// It's used by the UserFeedPage.
// *************************************************** //


// include other scripts used here
Qt.include("authenticationhandler.js");
Qt.include("helpermethods.js");
Qt.include("networkhandler.js");


// load the popular image stream from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadUserFeed()
{
    // console.log("Loading user feed");

    // clear feed list
    userImageFeed.clearFeed();

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    var imageCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        // get image object
                        imageCache = getImageDataFromObject(jsonObject.data[index]);

                        // add image object to feed list
                        userImageFeed.addToFeed({
                                                 "d_originalImage":imageCache["originalimage"],
                                                 "d_caption":imageCache["caption"],
                                                 "d_username":imageCache["username"],
                                                 "d_location":imageCache["location"],
                                                 "d_locationId":imageCache["locationId"],
                                                 "d_elapsedtime":imageCache["elapsedtime"],
                                                 "d_userhasliked":imageCache["userhasliked"],
                                                 "d_likes":imageCache["likes"],
                                                 "d_linkToInstagram":imageCache["linktoinstagram"],
                                                 "d_comments":imageCache["comments"],
                                                 "d_imageId":imageCache["imageid"],
                                                 "d_userId":imageCache["userid"],
                                                 "d_profilePicture":imageCache["profilepicture"]
                                             });

                        // console.log("Appended list with ID: " + imageCache["imageId"] + " in index: " + index);
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    userImageFeed.visible = true;

                    // console.log("Done loading user feed");
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

    var instagramUserdata = auth.getStoredInstagramData();
    var url = instagramkeys.instagramAPIUrl + "/v1/users/self/feed?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}
