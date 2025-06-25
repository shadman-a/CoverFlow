import SwiftUI
import Combine
import MusicKit

@MainActor
class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []

    func requestAuthorization() async {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            await loadLibraryAlbums()
        default:
            await loadCatalogAlbums()
        }
    }

    private func loadLibraryAlbums() async {
        do {
            let request = MusicLibraryRequest<Album>()
            let response = try await request.response()
            if response.items.isEmpty {
                await loadCatalogAlbums()
            } else {
                albums = Array(response.items)
            }
        } catch {
            await loadCatalogAlbums()
        }
    }

    private func loadCatalogAlbums() async {
        do {
            var search = MusicCatalogSearchRequest(term: "Top Albums", types: [Album.self])
            search.limit = 30
            let result = try await search.response()
            albums = Array(result.albums)
        } catch {
            print("Failed to load catalog albums: \(error)")
        }
    }
}
