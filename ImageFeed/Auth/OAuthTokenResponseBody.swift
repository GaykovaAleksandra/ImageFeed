import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int?
    let refreshToken: String?
}
