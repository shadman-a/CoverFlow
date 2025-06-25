import SwiftUI
import MusicKit

struct CoverFlowView: View {
    @StateObject private var viewModel = AlbumViewModel()
    private let itemSize: CGFloat = 220

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    ForEach(viewModel.albums) { album in
                        CoverFlowItem(album: album, itemSize: itemSize, containerWidth: proxy.size.width)
                    }
                }
                .padding(.horizontal, (proxy.size.width - itemSize) / 2)
            }
            .content.offset(x: 0)
        }
        .background(Color.black.ignoresSafeArea())
        .task {
            await viewModel.requestAuthorization()
        }
    }
}

struct CoverFlowItem: View {
    let album: Album
    let itemSize: CGFloat
    let containerWidth: CGFloat
    var body: some View {
        GeometryReader { geo in
            let mid = geo.frame(in: .global).midX
            let screenMid = containerWidth / 2
            let relative = mid - screenMid
            let rotation = Angle(degrees: Double(relative / containerWidth) * 50)
            let scale = max(0.6, 1 - abs(relative) / containerWidth)

            AsyncImage(url: album.artwork?.url(width: Int(itemSize * 2), height: Int(itemSize * 2))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: itemSize, height: itemSize)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .glassCard()
            .rotation3DEffect(rotation, axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)
            .zIndex(Double(scale))
        }
        .frame(width: itemSize, height: itemSize)
    }
}

#Preview {
    CoverFlowView()
}
