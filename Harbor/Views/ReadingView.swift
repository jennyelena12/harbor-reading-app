import SwiftUI

struct ReadingView: View {
    @State var book: Book
    @StateObject private var lightManager = AmbientLightManager()
    @StateObject private var speechManager = SpeechManager()
    @State private var showFavoritesModal = false
    @State private var showChapterSelector = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Adaptive background based on ambient light
            (lightManager.isDarkMode ? 
                Color(red: 0.08, green: 0.10, blue: 0.14) : 
                HarborColors.lightWave)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Books")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(HarborColors.harborBlue)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text(book.title)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(lightManager.isDarkMode ? .white : HarborColors.textPrimary)
                        
                        Text("Chapter \(book.currentChapterIndex + 1)")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(HarborColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: { showFavoritesModal = true }) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14))
                            .foregroundColor(HarborColors.accentTeal)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(lightManager.isDarkMode ? 
                    Color(red: 0.12, green: 0.14, blue: 0.18) : 
                    Color.white)
                
                // Reading Content
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            // Chapter Title
                            VStack(spacing: 12) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(HarborColors.harborBlue.opacity(0.6))
                                
                                Text(book.currentChapter?.title ?? "")
                                    .font(.system(size: 18, weight: .semibold, design: .default))
                                    .foregroundColor(lightManager.isDarkMode ? .white : HarborColors.textPrimary)
                                
                                Divider()
                                    .foregroundColor(HarborColors.harborBlue.opacity(0.2))
                            }
                            .padding(.bottom, 12)
                            
                            // Page Content
                            if let pageContent = book.currentPage {
                                SelectableText(text: pageContent, isDarkMode: lightManager.isDarkMode)
                                    .onLongPressGesture {
                                        speechManager.triggerHaptic()
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                    }
                    
                    Spacer(minLength: 0)
                    
                    // Navigation & Controls
                    VStack(spacing: 12) {
                        // Page indicator with progress
                        HStack {
                            Text("Page \(book.currentPageIndex + 1) of \(book.totalPages)")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(HarborColors.textSecondary)
                            
                            Spacer()
                            
                            ProgressView(value: book.readingProgress)
                                .frame(maxWidth: 120)
                        }
                        .padding(.horizontal, 16)
                        
                        // Navigation Buttons
                        HStack(spacing: 12) {
                            // Previous
                            Button(action: previousPage) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                    Text("Previous")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(book.currentPageIndex == 0 && book.currentChapterIndex == 0 ? 
                                    HarborColors.softGray : 
                                    HarborColors.harborBlue.opacity(0.1))
                                .foregroundColor(book.currentPageIndex == 0 && book.currentChapterIndex == 0 ? 
                                    HarborColors.textSecondary : 
                                    HarborColors.harborBlue)
                                .cornerRadius(10)
                                .font(.system(size: 13, weight: .semibold))
                            }
                            .disabled(book.currentPageIndex == 0 && book.currentChapterIndex == 0)
                            
                            // Voice Command Button
                            Button(action: {
                                if speechManager.isListening {
                                    speechManager.stopListening()
                                } else {
                                    speechManager.startListening()
                                }
                            }) {
                                Image(systemName: speechManager.isListening ? "waveform.circle.fill" : "mic.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(speechManager.isListening ? HarborColors.accentTeal : HarborColors.textSecondary)
                            }
                            .frame(width: 50, height: 50)
                            .background(lightManager.isDarkMode ? 
                                Color(red: 0.12, green: 0.14, blue: 0.18) : 
                                HarborColors.softGray)
                            .cornerRadius(12)
                            
                            // Next
                            Button(action: nextPage) {
                                HStack(spacing: 8) {
                                    Text("Next")
                                    Image(systemName: "chevron.right")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(book.currentPageIndex == (book.currentChapter?.pages.count ?? 1) - 1 && 
                                    book.currentChapterIndex == book.chapters.count - 1 ? 
                                    HarborColors.softGray : 
                                    HarborColors.harborBlue.opacity(0.1))
                                .foregroundColor(book.currentPageIndex == (book.currentChapter?.pages.count ?? 1) - 1 && 
                                    book.currentChapterIndex == book.chapters.count - 1 ? 
                                    HarborColors.textSecondary : 
                                    HarborColors.harborBlue)
                                .cornerRadius(10)
                                .font(.system(size: 13, weight: .semibold))
                            }
                            .disabled(book.currentPageIndex == (book.currentChapter?.pages.count ?? 1) - 1 && 
                                book.currentChapterIndex == book.chapters.count - 1)
                        }
                        .padding(.horizontal, 16)
                        
                        // Voice command feedback
                        if !speechManager.recognizedText.isEmpty {
                            Text("Heard: \(speechManager.recognizedText)")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(HarborColors.accentTeal)
                                .padding(.horizontal, 16)
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(lightManager.isDarkMode ? 
                        Color(red: 0.12, green: 0.14, blue: 0.18) : 
                        Color.white)
                }
            }
            
            // Floating chapter selector button
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: { showChapterSelector = true }) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(HarborColors.harborBlue)
                            .clipShape(Circle())
                    }
                    .padding(16)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showFavoritesModal) {
            FavoriteCaptureView(
                book: book,
                pageContent: book.currentPage ?? "",
                isPresented: $showFavoritesModal
            )
        }
        .sheet(isPresented: $showChapterSelector) {
            ChapterSelectorView(
                book: $book,
                isPresented: $showChapterSelector
            )
        }
        .onChange(of: speechManager.lastCommand) { _, newCommand in
            handleVoiceCommand(newCommand)
        }
        .onReceive(speechManager.$isListening) { isListening in
            if isListening {
                speechManager.triggerHaptic()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func nextPage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            book.nextPage()
        }
        speechManager.triggerHaptic()
    }
    
    private func previousPage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            book.previousPage()
        }
        speechManager.triggerHaptic()
    }
    
    private func handleVoiceCommand(_ command: VoiceCommand) {
        switch command {
        case .nextPage:
            nextPage()
        case .previousPage:
            previousPage()
        case .goToChapter(let index):
            withAnimation(.easeInOut(duration: 0.3)) {
                book.goToChapter(index)
            }
            speechManager.triggerHaptic()
        case .none:
            break
        }
    }
}

struct SelectableText: View {
    let text: String
    let isDarkMode: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .regular, design: .default))
            .lineSpacing(1.6)
            .foregroundColor(isDarkMode ? Color(red: 0.9, green: 0.9, blue: 0.92) : HarborColors.textPrimary)
            .textSelection(.enabled)
    }
}

#Preview {
    ReadingView(book: Book(
        title: "The Captain's Journey",
        author: "Sarah Waters",
        cover: "sailboat.fill",
        chapters: [
            Chapter(title: "The Calling", pages: ["Sample page text..."])
        ]
    ))
}
