// *************************************************** //
// Popularphotos Script
//
// This script is used to load, format and show the
// popular image feed.
// It's used by the PopularPhotosPage.
// *************************************************** //


// include other scripts used here
Qt.include("../global/instagramkeys.js");
Qt.include("../classes/authenticationhandler.js");
Qt.include("../classes/helpermethods.js");
Qt.include("../classes/networkhandler.js");


// load the popular image stream from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadImages()
{
    // console.log("Loading popular photos");

    // clear feed list
    imageGallery.clearGallery();

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
                        if (index <= 14)
                        {
                            // get image object
                            imageCache = getImageDataFromObject(jsonObject.data[index]);
                            // cacheImage(imageCache);

                            // add image object to gallery list
                            imageGallery.addToGallery({
                                                        "url":imageCache["thumbnail"],
                                                        "index":imageCache["imageid"]
                                                    });

                            // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                        }
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    imageGallery.visible = true;

                    // console.log("Done loading popular photos");
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

    var url = instagramkeys.instagramAPIUrl + "/v1/media/popular?client_id=" + instagramkeys.instagramClientId;

    req.open("GET", url, true);
    req.send();
}
