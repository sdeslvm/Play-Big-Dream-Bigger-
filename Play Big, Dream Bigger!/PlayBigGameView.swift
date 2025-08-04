import SwiftUI
import Foundation

struct PlayBigEntryScreen: View {
    @StateObject private var loader: PlayBigWebLoader

    init(loader: PlayBigWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            PlayBigWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                PlayBigProgressIndicator(value: percent)
            case .failure(let err):
                PlayBigErrorIndicator(err: err) // err теперь String
            case .noConnection:
                PlayBigOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct PlayBigProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            PlayBigLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct PlayBigErrorIndicator: View {
    let err: String // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct PlayBigOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
