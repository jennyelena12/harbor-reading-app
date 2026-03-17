import SwiftUI

struct FavoritesGalleryView: View {
    @ObservedObject var bookManager: BookManager
    @State private var searchText = ""
    @State private var selectedFavorite: FavoriteSentence?
    @State private var sortBy: SortOption = .date
    @State private var showShareMenu = false
    
    @Environment(\.dismiss) var dismiss
    
    enum SortOption {
        case date
        case book
        case length
    }
    
    var filteredFavorites: [FavoriteSentence] {
        var filtered = bookManager.favorites
        
        if !searchText.isEmpty {
            filtered = filtered.filter { favorite in
                favorite.text.lowercased().contains(searchText.lowercased()) ||
                favorite.bookTitle.lowercased().contains(searchText.lowercased())
            }
        }
        
        switch sortBy {
        case .date:
            return filtered.sorted { $0.timestamp > $1.timestamp }
        case .book:
            return filtered.sorted { $0.bookTitle < $1.bookTitle }
        case .length:
            return filtered.sorted { $0.text.count > $1.text.count }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#F5FBFF"),
                    Color(hex: "#E6F2FF")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(Color(hex: "#4A90E2"))
                        .font(.system(size: 16, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 2) {
                        Text("Favorite Sentences")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#1B4965"))
                        
                        Text("\(bookManager.favorites.count) saved")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(hex: "#4A90E2"))
                    }
                    
                    Spacer()
                    
                    Menu {
                        Picker("Sort by", selection: $sortBy) {
                            Text("Most Recent").tag(SortOption.date)
                            Text("By Book").tag(SortOption.book)
                            Text("Longest First").tag(SortOption.length)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(Color(hex: "#4A90E2"))
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.7))
                .backdrop()
                
                // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(hex: "#4A90E2"))
                    
                    TextField("Search sentences...", text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                        .textFieldStyle(.roundedBorder)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(hex: "#4A90E2"))
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .padding(16)
                
                // Favorites List or Empty State
                if bookManager.favorites.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "bookmark.slash")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "#4A90E2").opacity(0.3))
                        
                        VStack(spacing: 8) {
                            Text("No Favorite Sentences Yet")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "#1B4965"))
                            
                            Text("Capture sentences while reading to build your collection")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "#4A90E2"))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                } else if filteredFavorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "#4A90E2").opacity(0.3))
                        
                        Text("No matches found")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#1B4965"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredFavorites) { favorite in
                                FavoriteCardView(
                                    favorite: favorite,
                                    onDelete: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            bookManager.removeFavorite(favorite.id)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Favorite Card View

struct FavoriteCardView: View {
    let favorite: FavoriteSentence
    let onDelete: () -> Void
    
    @State private var showDeleteConfirm = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Quote
            VStack(alignment: .leading, spacing: 0) {
                Text("\"")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "#4A90E2").opacity(0.5))
                    .offset(y: -10)
                
                Text(favorite.text)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .lineSpacing(4)
                    .foregroundColor(Color(hex: "#1B4965"))
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Book and page info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#4A90E2"))
                    
                    Text(favorite.bookTitle)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#1B4965"))
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#00A8CC"))
                    
                    Text("\(favorite.chapterTitle) • Page \(favorite.pageNumber)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "#4A90E2"))
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#2B6CB0"))
                    
                    Text(favorite.timestamp.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "#2B6CB0"))
                }
            }
            
            HStack(spacing: 8) {
                Button(action: {
                    UIPasteboard.general.string = favorite.text
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 12))
                        Text("Copy")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#E6F2FF"))
                    .foregroundColor(Color(hex: "#4A90E2"))
                    .cornerRadius(6)
                }
                
                Button(action: { showDeleteConfirm = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                        Text("Delete")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#FFE6E6"))
                    .foregroundColor(Color(hex: "#FF6B6B"))
                    .cornerRadius(6)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color(hex: "#1B4965").opacity(0.08), radius: 6)
        .alert("Delete Favorite?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    onDelete()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone")
        }
    }
}

// MARK: - Backdrop Modifier

extension View {
    func backdrop() -> some View {
        modifier(BackdropBlurModifier())
    }
}

struct BackdropBlurModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

#Preview {
    NavigationStack {
        FavoritesGalleryView(bookManager: BookManager())
    }
}
