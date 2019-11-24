import Foundation

struct User: Codable {
    let id: Int
    let name: String
}

struct UserAlbum: Codable {
    var userId: Int
    let id: Int
}

struct UserPhoto: Codable {
    let albumId: Int
    let title: String
    let url: URL
}
