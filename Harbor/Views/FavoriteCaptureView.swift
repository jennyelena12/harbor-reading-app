import SwiftUI

struct FavoriteCaptureView: View {
    let book: Book
    let pageContent: String
    @Binding var isPresented: Bool
    @StateObject private var favoritesManager = FavoritesManager()
    @State private var selectedText = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Capture Favorite")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(HarborColors.darkHarbor)
                    
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(HarborColors.textSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Tab Navigation
                HStack(spacing: 0) {
                    Button(action: {}) {
                        Text("Copy Favorite")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(HarborColors.harborBlue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(HarborColors.harborBlue.opacity(0.1))
                    
                    Button(action: {}) {
                        Text("Your Favorites")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(HarborColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .background(HarborColors.softGray)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                // Current Page Content
                VStack(alignment: .leading, spacing: 12) {
                    Text("This Page")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(HarborColors.textSecondary)
                    
                    SelectableText(text: pageContent, isDarkMode: false)
                        .padding(12)
                        .background(HarborColors.lightWave)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // Input Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Highlight to Save")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(HarborColors.textSecondary)
                    
                    TextEditor(text: $selectedText)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(minHeight: 100)
                        .border(HarborColors.harborBlue.opacity(0.2), width: 1)
                    
                    HStack {
                        Text("\(selectedText.count) characters")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(HarborColors.textSecondary)
                        
                        Spacer()
                        
                        if !selectedText.isEmpty {
                            Button(action: saveFavorite) {
                                HStack(spacing: 6) {
                                    Image(systemName: "heart.fill")
                                    Text("Save")
                                }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(HarborColors.accentTeal)
                                .cornerRadius(6)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Recent Favorites
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Favorites")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(HarborColors.darkHarbor)
                    
                    if favoritesManager.favorites.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "heart.slash.fill")
                                .font(.system(size: 28))
                                .foregroundColor(HarborColors.textSecondary.opacity(0.5))
                            
                            Text("No favorites yet")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(HarborColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 8) {
                                ForEach(favoritesManager.favorites.sorted { $0.timestamp > $1.timestamp }.prefix(5)) { favorite in
                                    FavoriteItemRow(favorite: favorite, onDelete: {
                                        favoritesManager.removeFavorite(favorite.id)
                                    })
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(HarborColors.lightWave.ignoresSafeArea())
            .alert("Favorite Saved", isPresented: $showAlert) {
                Button("Done", role: .cancel) {
                    selectedText = ""
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveFavorite() {
        guard !selectedText.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter some text"
            showAlert = true
            return
        }
        
        let favorite = FavoriteSentence(
            text: selectedText,
            bookTitle: book.title,
            chapterTitle: book.currentChapter?.title ?? "Unknown",
            pageNumber: book.currentPageIndex + 1
        )
        
        favoritesManager.addFavorite(favorite)
        alertMessage = "Saved: \"\(selectedText.prefix(30))...\""
        showAlert = true
        selectedText = ""
    }
}

struct FavoriteItemRow: View {
    let favorite: FavoriteSentence
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(favorite.text)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(HarborColors.textPrimary)
                        .lineLimit(2)
                    
                    Text("\(favorite.bookTitle) • Chapter: \(favorite.chapterTitle)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(HarborColors.textSecondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(HarborColors.textSecondary.opacity(0.6))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    FavoriteCaptureView(
        book: Book(
            title: "The Captain's Journey",
            author: "Sarah Waters",
            cover: "sailboat.fill",
            chapters: [Chapter(title: "The Calling", pages: ["Sample page..."])]
        ),
        pageContent: "This is a sample page with beautiful content that the reader might want to save.",
        isPresented: .constant(true)
    )
}
