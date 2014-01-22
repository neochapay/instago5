// *************************************************** //
// Locations Script
//
// This script handles the location based data for a
// given image.
// Note that only authenticated users can request
// location based data.
// It's used by the ImageDetailPage and UserFeedPage.
// *************************************************** //


// include other scripts used here
Qt.include("../classes/authenticationhandler.js");
Qt.include("../classes/helpermethods.js");
Qt.include("../classes/networkhandler.js");


// this is the global storage for the pagination id
var lastPaginationId = "";

// this is the global storage for the venue name and position
var locationHeadline = "";
var locationLatitude = "";
var locationLongitude = "";


// get location position based on the stored data
// note that this will only return valid data if getLocationData has been successfully called first
function recenterLocationMap()
{
    locationCenter.position.coordinate.latitude = locationLatitude;
    locationCenter.position.coordinate.longitude = locationLongitude;
    locationMap.center.latitude = locationLatitude;
    locationMap.center.longitude = locationLongitude;
}


// get location based data for a given location id
// data will be used to fill the location detail page
function getLocationData(locationId, paginationId)
{
    // console.log("Getting location data for id: " + locationId + " and pagination id: " + paginationId);

    // check if the current pagination id is the same as the last one
    // this is the case if all images habe been loaded and there are no more
    if ( (paginationId !== 0) && (paginationId === lastPaginationId) )
    {
        // console.log("Last pagination id matches this one: " + paginationId + " - returning");
        return;
    }

    // check if this is a new call or loading more images
    if (paginationId === 0)
    {
        errorMessage.visible = false;
        loadingIndicator.running = true;
        loadingIndicator.visible = true;
    }
    else
    {
        notification.useTimer = false;
        notification.text = "Loading more images..";
        notification.show();
    }

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    if (paginationId === 0)
                    {
                        locationGallery.clearGallery();
                    }

                    var imageCache = new Array();

                    for ( var index in jsonObject.data )
                    {
                        // get image object
                        imageCache = getImageDataFromObject(jsonObject.data[index]);

                        // add image object to gallery list
                        locationGallery.addToGallery({
                                                         "url":imageCache["thumbnail"],
                                                         "index":imageCache["imageid"]
                                                     });

                        locationLatitude = imageCache["locationLatitude"];
                        locationLongitude = imageCache["locationLongitude"];
                        locationHeadline = imageCache["location"];

                        // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                    }

                    // check if the page has a following page in the pagination list
                    // if so then remember it in the gallery component
                    if (jsonObject.pagination.next_max_id != null)
                    {
                        locationGallery.paginationNextMaxId = jsonObject.pagination.next_max_id;
                    }


                    if (paginationId === 0)
                    {
                        locationCenter.position.coordinate.latitude = locationLatitude;
                        locationCenter.position.coordinate.longitude = locationLongitude;
                        locationMap.center = locationCenter.position.coordinate;
                        locationName.text = locationHeadline;

                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                        locationMetadata.visible = true;
                        locationMetadata.height = locationName.height + 230;
                        locationGallery.visible = true;
                    }
                    else
                    {
                        // loading additional images
                        notification.hide();
                        notification.useTimer = true;
                    }

                    // console.log("Done loading location data");
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
    var url = instagramkeys.instagramAPIUrl + "/v1/locations/" + locationId + "/media/recent?access_token=" + instagramUserdata["access_token"];
    if (paginationId !== 0)
    {
        url += "&max_id=" + paginationId;
        lastPaginationId = paginationId;
    }

    req.open("GET", url, true);
    req.send();
}
