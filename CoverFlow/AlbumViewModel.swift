import SwiftUI
import Combine

@MainActor
class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []

    func loadSampleAlbums() {
        let seeds = 1...20
        albums = seeds.compactMap { i in
            URL(string: "https://picsum.photos/seed/\(i)/600")
        }.map { url in
            Album(artworkURL: url)
        }
    }
}
