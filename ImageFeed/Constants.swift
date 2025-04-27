import Foundation

enum Constants {
    static let accessKey = "bF7_EnmHXgwe52MoCfb5bL0VvpYkqCekmh6RwoIyKcA"
    static let secretKey = "BIgaQ2RZPAo10WPaFMj2ZBj9KCsBwJgOxaVIqXvAmuk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUR = {
        guard let baseURL = URL(string: "https://api.unsplash.com") else {
            assertionFailure("Invalid base URL")
            return
        }
    }
}
