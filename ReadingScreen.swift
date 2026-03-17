import SwiftUI

struct ReadingScreen: View {
    @ObservedObject var bookManager: BookManager
    @StateObject private var lightManager = AmbientLightManager()
    @StateObject private var speechManager = SpeechRecognitionManager()
    
    @State private var showBrightnessControl = false
    @State private var showVoiceIndicator = false
    @State private var selectedText = ""
    @State private var showSentenceCaptureSheet = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Adaptive background based on light levels
            let bgColor = lightManager.isDarkMode ?
                Color(hex: "#0F2438") : Color(hex: "#F5FBFF")
            
            bgColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Library")
                        }
                        .foregroundColor(lightManager.isDarkMode ? 
                            Color(hex: "#B8D8E8") : Color(hex: "#4A90E2"))
                        .font(.system(size: 16, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 2) {
                        Text(bookManager.currentBook?.title ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(lightManager.isDarkMode ? 
                                Color.white : Color(hex: "#1B4965"))
                        
                        let location = bookManager.getCurrentLocation()
                        Text("\(location.chapterTitle) • Page \(location.pageInChapter)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(lightManager.isDarkMode ? 
                                Color(hex: "#B8D8E8") : Color(hex: "#4A90E2"))
                    }
                    
                    Spacer()
                    
                    Button(action: { showBrightnessControl.toggle() }) {
                        Image(systemName: lightManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(lightManager.isDarkMode ? 
                                Color(hex: "#FFD700") : Color(hex: "#FF9500"))
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(lightManager.isDarkMode ? 
                    Color(hex: "#1B4965") : Color.white.opacity(0.7))
                .backdrop(blur: 10)
                
                // Main Reading Area
                ScrollView {
                    VStack(spacing: 24) {
                        Text(bookManager.getCurrentPageText())
                            .font(.system(size: 18, weight: .regular, design: .default))
                            .lineSpacing(8)
                            .foregroundColor(lightManager.isDarkMode ? 
                                Color(hex: "#E8F0F8") : Color(hex: "#1B4965"))
                            .textSelection(.enabled)
                            .padding(24)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
                }
                .onTapGesture { location in
                    handlePageTap(location: location)
                }
                .opacity(0.98 + (lightManager.brightness - 0.5) * 0.04)
                
                // Brightness Slider (if shown)
                if showBrightnessControl {
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "sun.max")
                                .foregroundColor(Color(hex: "#FF9500"))
                            
                            Slider(value: $lightManager.brightness, in: 0...1)
                                .onChange(of: lightManager.brightness) { _, newValue in
                                    UIScreen.main.brightness = newValue
                                }
                            
                            Image(systemName: "moon.fill")
                                .foregroundColor(Color(hex: "#FFD700"))
                        }
                        
                        HStack(spacing: 8) {
                            Text("Auto-brightness is ON")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(lightManager.isDarkMode ? 
                                    Color(hex: "#B8D8E8") : Color(hex: "#4A90E2"))
                            
                            Spacer()
                            
                            Text("Sensor: \(Int(lightManager.brightness * 100))%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(hex: "#00A8CC"))
                        }
                    }
                    .padding(16)
                    .background(lightManager.isDarkMode ? 
                        Color(hex: "#1B4965") : Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // Navigation Controls
                HStack(spacing: 16) {
                    // Previous Page
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            bookManager.previousPage()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .background(Color(hex: "#4A90E2"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(bookManager.currentBook?.currentPage ?? 0 == 0)
                    
                    Spacer()
                    
                    // Voice Command Button
                    VStack(spacing: 4) {
                        Button(action: {
                            if speechManager.isListening {
                                speechManager.stopListening()
                            } else {
                                speechManager.startListening { command in
                                    handleVoiceCommand(command)
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(speechManager.isListening ? 
                                        Color(hex: "#FF6B6B") : Color(hex: "#00A8CC"))
                                
                                Image(systemName: speechManager.isListening ? "mic.fill" : "mic")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 56, height: 56)
                        }
                        
                        if showVoiceIndicator {
                            Text(speechManager.recognizedText)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(Color(hex: "#4A90E2"))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    Spacer()
                    
                    // Next Page
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            bookManager.nextPage()
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .background(Color(hex: "#4A90E2"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(bookManager.currentBook?.currentPage ?? 0 >= (bookManager.currentBook?.totalPages ?? 1) - 1)
                }
                .padding(16)
                .background(lightManager.isDarkMode ? 
                    Color(hex: "#1B4965") : Color.white.opacity(0.7))
                .backdrop(blur: 10)
                
                // Bottom Action Bar
                HStack(spacing: 12) {
                    Button(action: { showSentenceCaptureSheet.toggle() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "highlighter")
                                .font(.system(size: 14))
                            Text("Capture")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(hex: "#4A90E2"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: FavoritesGalleryView(bookManager: bookManager)) {
                        HStack(spacing: 6) {
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 14))
                            Text("Favorites")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(hex: "#00A8CC"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(16)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSentenceCaptureSheet) {
            SentenceCaptureSheet(bookManager: bookManager, isPresented: $showSentenceCaptureSheet)
        }
        .onChange(of: speechManager.isListening) { _, newValue in
            showVoiceIndicator = newValue
        }
    }
    
    private func handlePageTap(location: CGPoint) {
        let screenWidth = UIScreen.main.bounds.width
        let tapZoneWidth = screenWidth * 0.2
        
        if location.x < tapZoneWidth {
            // Left side - previous page
            withAnimation(.easeInOut(duration: 0.3)) {
                bookManager.previousPage()
            }
        } else if location.x > screenWidth - tapZoneWidth {
            // Right side - next page
            withAnimation(.easeInOut(duration: 0.3)) {
                bookManager.nextPage()
            }
        }
    }
    
    private func handleVoiceCommand(_ command: VoiceCommand?) {
        guard let command = command else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            switch command {
            case .nextPage:
                bookManager.nextPage()
            case .previousPage:
                bookManager.previousPage()
            case .goToChapter(let chapterNum):
                // Navigate to chapter (implementation depends on book structure)
                print("[Harbor] Going to chapter \(chapterNum)")
            }
        }
    }
}

// MARK: - Sentence Capture Sheet

struct SentenceCaptureSheet: View {
    @ObservedObject var bookManager: BookManager
    @Binding var isPresented: Bool
    
    @State private var selectedSentence = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5FBFF")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Capture Favorite Sentence")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#1B4965"))
                        
                        Spacer()
                        
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(hex: "#4A90E2"))
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .border(width: 1, edges: [.bottom], color: Color(hex: "#E0E8F0"))
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            // Display full text
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Current Page")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#4A90E2"))
                                    .textCase(.uppercase)
                                
                                Text(bookManager.getCurrentPageText())
                                    .font(.system(size: 16, weight: .regular))
                                    .lineSpacing(6)
                                    .foregroundColor(Color(hex: "#1B4965"))
                                    .padding(12)
                                    .background(Color(hex: "#F0F8FF"))
                                    .cornerRadius(10)
                                    .textSelection(.enabled)
                            }
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            // Sentence input
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your Favorite Sentence")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#4A90E2"))
                                    .textCase(.uppercase)
                                
                                TextEditor(text: $selectedSentence)
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(minHeight: 100)
                                    .padding(12)
                                    .background(Color.white)
                                    .border(width: 1, edges: [.all], color: Color(hex: "#4A90E2").opacity(0.3))
                                    .cornerRadius(10)
                            }
                            
                            // Info
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#4A90E2"))
                                    
                                    Text("This sentence will be saved to your favorites with page reference")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(Color(hex: "#4A90E2"))
                                }
                                .padding(12)
                                .background(Color(hex: "#E6F2FF"))
                                .cornerRadius(8)
                            }
                        }
                        .padding(16)
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(hex: "#E0E8F0"))
                                .foregroundColor(Color(hex: "#4A90E2"))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            if !selectedSentence.trimmingCharacters(in: .whitespaces).isEmpty {
                                bookManager.addFavorite(selectedSentence)
                                isPresented = false
                            } else {
                                showAlert = true
                            }
                        }) {
                            Text("Save to Favorites")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(hex: "#4A90E2"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(16)
                }
            }
            .alert("Required", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text("Please enter a sentence to save")
            }
        }
    }
}

// MARK: - Border Modifier

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(
            EdgeBorder(width: width, edges: edges, color: color)
        )
    }
}

struct EdgeBorder: View {
    let width: CGFloat
    let edges: [Edge]
    let color: Color
    
    var body: some View {
        ZStack {
            if edges.contains(.top) {
                VStack {
                    Rectangle()
                        .fill(color)
                        .frame(height: width)
                    Spacer()
                }
            }
            if edges.contains(.bottom) {
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(color)
                        .frame(height: width)
                }
            }
            if edges.contains(.leading) {
                HStack {
                    Rectangle()
                        .fill(color)
                        .frame(width: width)
                    Spacer()
                }
            }
            if edges.contains(.trailing) {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(color)
                        .frame(width: width)
                }
            }
        }
    }
}

// MARK: - Backdrop Modifier

extension View {
    func backdrop(blur: Double) -> some View {
        modifier(BackdropBlur(blur: blur))
    }
}

struct BackdropBlur: ViewModifier {
    let blur: Double
    
    func body(content: Content) -> some View {
        content
    }
}

#Preview {
    NavigationStack {
        ReadingScreen(bookManager: BookManager())
    }
}
