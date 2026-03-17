import SwiftUI

struct HomeScreen: View {
    @StateObject private var bookManager = BookManager()
    @State private var selectedBook: Book?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#F0F8FF"),
                        Color(hex: "#E6F2FF")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Harbor")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "#1B4965"))
                        Text("Continue your journey across the literary seas")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "#4A90E2"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Current Book with Ocean Progress
                            if let current = bookManager.currentBook {
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        // Book Cover
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color(hex: current.coverColor))
                                                
                                                VStack(spacing: 8) {
                                                    Text(current.title)
                                                        .font(.system(size: 16, weight: .bold))
                                                        .foregroundColor(.white)
                                                        .lineLimit(3)
                                                        .multilineTextAlignment(.center)
                                                    
                                                    Spacer()
                                                    
                                                    Text(current.author)
                                                        .font(.system(size: 12, weight: .regular))
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                                .padding(12)
                                            }
                                            .frame(height: 200)
                                        }
                                        .frame(width: 120)
                                        
                                        // Progress Info
                                        VStack(alignment: .leading, spacing: 12) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Reading Progress")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(Color(hex: "#4A90E2"))
                                                    .textCase(.uppercase)
                                                
                                                HStack(spacing: 8) {
                                                    Text("\(current.currentPage + 1)")
                                                        .font(.system(size: 24, weight: .bold))
                                                        .foregroundColor(Color(hex: "#1B4965"))
                                                    
                                                    Text("of \(current.totalPages)")
                                                        .font(.system(size: 14, weight: .regular))
                                                        .foregroundColor(Color(hex: "#4A90E2"))
                                                }
                                            }
                                            
                                            // Progress Bar
                                            VStack(spacing: 8) {
                                                GeometryReader { geometry in
                                                    ZStack(alignment: .leading) {
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(Color(hex: "#E0E8F0"))
                                                        
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(
                                                                LinearGradient(
                                                                    gradient: Gradient(colors: [
                                                                        Color(hex: "#4A90E2"),
                                                                        Color(hex: "#00A8CC")
                                                                    ]),
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing
                                                                )
                                                            )
                                                            .frame(width: geometry.size.width * current.progress)
                                                    }
                                                }
                                                .frame(height: 6)
                                                
                                                Text("\(Int(current.progress * 100))% complete")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundColor(Color(hex: "#4A90E2"))
                                            }
                                            
                                            Spacer()
                                            
                                            NavigationLink(destination: ReadingScreen(bookManager: bookManager)) {
                                                HStack {
                                                    Text("Continue Reading")
                                                        .font(.system(size: 14, weight: .semibold))
                                                    Image(systemName: "arrow.right")
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .background(Color(hex: "#4A90E2"))
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                            }
                                        }
                                    }
                                    
                                    // Ocean Wave Progress Visualization
                                    OceanProgressView(progress: current.progress)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color(hex: "#1B4965").opacity(0.1), radius: 8)
                                .padding(.horizontal, 16)
                            }
                            
                            // Other Books
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your Library")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1B4965"))
                                    .padding(.horizontal, 16)
                                
                                VStack(spacing: 12) {
                                    ForEach(bookManager.books) { book in
                                        if book.id != bookManager.currentBook?.id {
                                            BookRowView(
                                                book: book,
                                                action: {
                                                    bookManager.selectBook(book)
                                                }
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            
                            // Favorites Shortcut
                            NavigationLink(destination: FavoritesGalleryView(bookManager: bookManager)) {
                                HStack(spacing: 12) {
                                    Image(systemName: "bookmark.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(hex: "#4A90E2"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Favorite Sentences")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(hex: "#1B4965"))
                                        Text("\(bookManager.favorites.count) saved")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color(hex: "#4A90E2"))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(hex: "#4A90E2"))
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color(hex: "#1B4965").opacity(0.05), radius: 4)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .environmentObject(bookManager)
    }
}

// MARK: - Ocean Progress View

struct OceanProgressView: View {
    let progress: Double
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Your Journey")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "#4A90E2"))
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#F0F8FF"))
                
                // Water
                VStack {
                    Spacer()
                    
                    ZStack {
                        // Base water color
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "#4A90E2").opacity(0.3),
                                        Color(hex: "#00A8CC").opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Wave 1
                        WaveShape(offset: waveOffset, amplitude: 4)
                            .fill(Color(hex: "#4A90E2").opacity(0.4))
                        
                        // Wave 2
                        WaveShape(offset: waveOffset + 10, amplitude: 3)
                            .fill(Color(hex: "#00A8CC").opacity(0.3))
                    }
                    .frame(height: CGFloat(80 * progress))
                }
                
                // Ship indicator
                VStack {
                    Spacer()
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "sailboat.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#1B4965"))
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(hex: "#1B4965"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .cornerRadius(6)
                        
                        Spacer()
                    }
                    .padding(12)
                }
            }
            .frame(height: 120)
        }
        .onAppear {
            startWaveAnimation()
        }
    }
    
    private func startWaveAnimation() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            waveOffset = 40
        }
    }
}

// MARK: - Wave Shape

struct WaveShape: Shape {
    let offset: CGFloat
    let amplitude: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.7))
        
        for x in stride(from: 0, through: width, by: 1) {
            let y = height * 0.7 + sin((x + offset) / 10) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Book Row View

struct BookRowView: View {
    let book: Book
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Small book cover
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: book.coverColor))
                    
                    Text(String(book.title.prefix(1)))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 64)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#1B4965"))
                    
                    Text(book.author)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "#4A90E2"))
                    
                    Text("\(Int(book.progress * 100))% complete")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color(hex: "#2B6CB0"))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "#4A90E2"))
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

import Foundation

#Preview {
    HomeScreen()
}
