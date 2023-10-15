import Foundation

internal struct Constants {

    internal static let API_KEY = "someAPIKey"
    internal static let API_SECRET = "someAPISecret"

    internal static let RESPONSE_200_OK = Util.createResponse()
    internal static let RESPONSE_400_BAD_REQUEST = Util.createResponse(statusCode: 400)
    internal static let RESPONSE_403_FORBIDDEN = Util.createResponse(statusCode: 403)

}
