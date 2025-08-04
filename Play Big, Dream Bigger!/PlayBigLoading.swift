import SwiftUI

// MARK: - Protocols for extensibility

protocol PlayBigProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol PlayBigBackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Enhanced loading structure

struct PlayBigLoadingOverlay<Background: View>: View, PlayBigProgressDisplayable {
    let progress: Double
    let backgroundView: Background
    
    var progressPercentage: Int { Int(progress * 100) }
    
    init(progress: Double, @ViewBuilder background: () -> Background) {
        self.progress = progress
        self.backgroundView = background()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundView
                content(in: geo)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func content(in geometry: GeometryProxy) -> some View {
        let isLandscape = geometry.size.width > geometry.size.height
        
        return Group {
            if isLandscape {
                horizontalLayout(in: geometry)
            } else {
                verticalLayout(in: geometry)
            }
        }
    }
    
    private func verticalLayout(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated logo/title
            VStack(spacing: 20) {
                Text("PLAY BIG")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(playBigHex: "#1BD8FD"), Color(playBigHex: "#0FC9FA")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(playBigHex: "#1BD8FD").opacity(0.5), radius: 10, x: 0, y: 5)
                    .scaleEffect(1.0 + 0.1 * sin(Date().timeIntervalSince1970 * 2))
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: progress)
                
                Text("DREAM BIGGER")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(3)
            }
            
            progressSection(width: geometry.size.width * 0.7)
            
            Spacer()
        }
    }
    
    private func horizontalLayout(in geometry: GeometryProxy) -> some View {
        HStack(spacing: 60) {
            Spacer()
            
            VStack(spacing: 30) {
                Text("PLAY BIG")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(playBigHex: "#1BD8FD"), Color(playBigHex: "#0FC9FA")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(playBigHex: "#1BD8FD").opacity(0.5), radius: 8, x: 0, y: 4)
                    .scaleEffect(1.0 + 0.05 * sin(Date().timeIntervalSince1970 * 2))
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: progress)
                
                Text("DREAM BIGGER")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(2)
            }
            
            progressSection(width: geometry.size.width * 0.3)
            
            Spacer()
        }
    }
    
    private func progressSection(width: CGFloat) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("LOADING")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .tracking(2)
                
                Text("\(progressPercentage)%")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(playBigHex: "#F3D614"), Color(playBigHex: "#FFD700")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: Color(playBigHex: "#F3D614").opacity(0.3), radius: 5, x: 0, y: 2)
            }
            
            PlayBigProgressBar(value: progress)
                .frame(width: width, height: 12)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
    }
}

// MARK: - Background views

extension PlayBigLoadingOverlay where Background == PlayBigBackground {
    init(progress: Double) {
        self.init(progress: progress) { PlayBigBackground() }
    }
}

struct PlayBigBackground: View, PlayBigBackgroundProviding {
    func makeBackground() -> some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    Color(playBigHex: "#0A0A0A"),
                    Color(playBigHex: "#1A1A2E"),
                    Color(playBigHex: "#16213E")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated particles
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color(playBigHex: "#1BD8FD").opacity(0.1))
                    .frame(width: CGFloat.random(in: 2...6))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...8))
                        .repeatForever(autoreverses: true),
                        value: index
                    )
            }
        }
    }
    
    var body: some View {
        makeBackground()
    }
}

// MARK: - Animated progress bar

struct PlayBigProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            progressContainer(in: geometry)
        }
    }
    
    private func progressContainer(in geometry: GeometryProxy) -> some View {
        ZStack(alignment: .leading) {
            backgroundTrack(height: geometry.size.height)
            progressTrack(in: geometry)
        }
    }
    
    private func backgroundTrack(height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: height)
    }
    
    private func progressTrack(in geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: geometry.size.height / 2)
            .fill(
                LinearGradient(
                    colors: [
                        Color(playBigHex: "#1BD8FD"),
                        Color(playBigHex: "#0FC9FA"),
                        Color(playBigHex: "#F3D614")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: CGFloat(value) * geometry.size.width, height: geometry.size.height)
            .animation(.easeInOut(duration: 0.3), value: value)
            .overlay(
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Preview

#Preview("Vertical") {
    PlayBigLoadingOverlay(progress: 0.2)
}

#Preview("Horizontal") {
    PlayBigLoadingOverlay(progress: 0.2)
        .previewInterfaceOrientation(.landscapeRight)
}

