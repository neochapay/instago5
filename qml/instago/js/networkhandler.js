// *************************************************** //
// Networkhandler Script
//
// This script handles most of the work needed to
// convert the http response into a usable object.
// This also includes the clean handling of errors
// or problems that can occur.
// Note that it's a class that needs to be defined first:
// network = new NetworkHandler();
// *************************************************** //

// mark javascript file as library
.pragma library

// singleton instance of class
var network = new NetworkHandler();

// class function that gets the prototype methods
function NetworkHandler()
{
    // array to store error data in
    this.errorData = new Array();

    // flag to indicate that loading is finished
    this.requestIsFinished = false;
}


// this method handles http responses for a XMLHttpRequest
// note that it's meant to be called on every onreadystatechange()
// the responseText is analysed for errors and evaluated into a json object, which is returned
NetworkHandler.prototype.handleHttpResult = function(XMLHttpRequestObject)
        {
            // console.log("Handling HTTP Result for ready state: " + XMLHttpRequestObject.readyState);

            // check the server response for errors
            // this is done during loading as the XMLHttpRequest object deletes errors once it's DONE
            // see here for details: https://bugreports.qt-project.org/browse/QTBUG-21706
            if (XMLHttpRequestObject.readyState === XMLHttpRequest.LOADING)
            {
                this.checkResponseForErrors(XMLHttpRequestObject.responseText);
                return;
            }

            // check if the server response is actually finished
            if (XMLHttpRequestObject.readyState === XMLHttpRequest.DONE)
            {
                this.requestIsFinished = true;
                // console.debug("status: " + XMLHttpRequestObject.status + " content: " + XMLHttpRequestObject.responseText);

                // check if the status is not 200 (= an error has occured)
                // this might either be already caught during loading or be something new
                if (XMLHttpRequestObject.status != 200)
                {
                    if (!this.errorData['code']) { this.checkResponseForErrors(XMLHttpRequestObject.responseText); }
                    return;
                }

                var jsonObject = eval('(' + XMLHttpRequestObject.responseText + ')');
                if (jsonObject.error == null)
                {
                    return jsonObject;
                }

                return;
            }
        }


// This script analyses the traffic from Instagram for possible errors
// Note that this scripts does the analysing but does not act upon found errors
NetworkHandler.prototype.checkResponseForErrors = function(httpResponseText)
        {
            // console.log("Check HTTP response for errors");

            // check for general network error
            // in this case the httpResponseText would be empty
            // in that case fill the error data object with a generic error description
            if (httpResponseText === "")
            {
                // console.log("Empty response, adding generic error");

                this.errorData["error_type"] = "GenericNetworkError";
                this.errorData["code"] = "0";
                this.errorData["error_message"] = "A generic network error occured";
                return;
            }

            // every response from the Instagram API server contains a "meta" node
            // every meta node containss a node "code" that has the http response code as content
            // thus if the response does not contain the status code 200 it's an error
            // (may be a different error code or empty)
            if ( (httpResponseText.indexOf('"code":200') === -1) && (httpResponseText.indexOf('"code":') > 1) )
            {
                // console.log("Response does not have response 200 verification by Instagram");

                // eval the response text to check the content
                var jsonObject = eval('(' + httpResponseText + ')');
                if (jsonObject.error == null)
                {
                    // console.log("JSON evaluation successful");

                    // the error was handled and described by Instagram
                    // fill the error data object with the Instagram error description
                    this.errorData["error_type"] = jsonObject.meta.error_type;
                    this.errorData["code"] = jsonObject.meta.code;
                    this.errorData["error_message"] = jsonObject.meta.error_message;

                    if (this.errorData["error_type"] === "OAuthAccessTokenException")
                    {
                        pageStack.push(Qt.resolvedUrl("ForcedLogoutPage.qml"));
                        return;
                    }
                }
                else
                {
                    console.log("JSON evaluation not successful, adding generic error");

                    // the error was not handled by Instagram
                    // fill the error data object with a generic error description
                    this.errorData["error_type"] = "GenericNetworkError";
                    this.errorData["code"] = "0";
                    this.errorData["error_message"] = "A generic network error occured";
                }
            }
        };


// this method clears any error messages that are currently stored in the object
// this is called after the error messages have been processed and shown
NetworkHandler.prototype.clearErrors = function()
        {
            this.errorData = new Array();
        }
