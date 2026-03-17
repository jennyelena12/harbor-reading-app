import SwiftUI

struct HomeView: View {
    @StateObject private var bookManager = BookManager()
    @State private var selectedBook: Book?
    @State private var showReadingView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                HarborColors.lightWave
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Harbor")
                            .font(.system(size: 32, weight: .bold, design: .default))
                            .foregroundColor(HarborColors.darkHarbor)
                        
                        Text("Begin Your Journey")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(HarborColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Book Selection
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(bookManager.books) { book in
                                BookCard(
                                    book: book,
                                    action: {
                                        selectedBook = book
                                        showReadingView = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .navigationDestination(isPresented: $showReadingView) {
                if let book = selectedBook {
                    ReadingView(book: book)
                }
            }
        }
    }
}

struct BookCard: View {
    let book: Book
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    // Book Icon
                    Image(systemName: book.cover)
                        .font(.system(size: 40))
                        .foregroundColor(HarborColors.harborBlue)
                        .frame(width: 60, height: 60)
                        .background(HarborColors.harborBlue.opacity(0.1))
                        .cornerRadius(12)
                    
                    // Book Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(HarborColors.textPrimary)
                            .lineLimit(2)
                        
                        Text(book.author)
                            .font(.system(size: 13, weight: .regular, design: .default))
                            .foregroundColor(HarborColors.textSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Progress Badge
                    VStack(spacing: 2) {
                        Text("\(Int(book.readingProgress * 100))%")
                            .font(.system(size: 12, weight: .bold, design: .default))
                            .foregroundColor(HarborColors.accentTeal)
                        
                        Text("Read")
                            .font(.system(size: 10, weight: .regular, design: .default))
                            .foregroundColor(HarborColors.textSecondary)
                    }
                }
                
                // Progress Bar with Ocean Theme
                VStack(spacing: 4) {
                    ZStack(alignment: .leading) {
                        // Background bar
                        RoundedRectangle(cornerRadius: 4)
                            .fill(HarborColors.softGray)
                        
                        // Progress fill with wave effect
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        HarborColors.harborBlue,
                                        HarborColors.accentTeal
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(2, CGFloat(book.readingProgress) * (UIScreen.main.bounds.width - 32)))
                    }
                    .frame(height: 6)
                    
                    HStack {
                        Text("Chapter \(book.currentChapterIndex + 1) of \(book.chapters.count)")
                            .font(.system(size: 11, weight: .regular, design: .default))
                            .foregroundColor(HarborColors.textSecondary)
                        
                        Spacer()
                        
                        Text("Page \(book.currentPageIndex + 1)")
                            .font(.system(size: 11, weight: .regular, design: .default))
                            .foregroundColor(HarborColors.textSecondary)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: HarborColors.darkHarbor.opacity(0.08), radius: 6, x: 0, y: 2)
        }
    }
}

#Preview {
    HomeView()
}
