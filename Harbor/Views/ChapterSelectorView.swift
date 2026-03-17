import SwiftUI

struct ChapterSelectorView: View {
    @Binding var book: Book
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Chapters")
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
                .padding(.vertical, 16)
                .background(Color.white)
                
                // Chapter List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(0..<book.chapters.count, id: \.self) { index in
                            ChapterRowView(
                                chapter: book.chapters[index],
                                index: index,
                                isSelected: index == book.currentChapterIndex,
                                action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        book.goToChapter(index)
                                        isPresented = false
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(HarborColors.lightWave)
            }
        }
    }
}

struct ChapterRowView: View {
    let chapter: Chapter
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("Chapter \(index + 1)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(isSelected ? HarborColors.accentTeal : HarborColors.textSecondary)
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(HarborColors.accentTeal)
                        }
                    }
                    
                    Text(chapter.title)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(HarborColors.textPrimary)
                        .lineLimit(2)
                    
                    Text("\(chapter.pages.count) pages")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(HarborColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(HarborColors.textSecondary)
            }
            .padding(12)
            .background(isSelected ? 
                HarborColors.accentTeal.opacity(0.1) : 
                Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? HarborColors.accentTeal.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ChapterSelectorView(
        book: .constant(Book(
            title: "Test Book",
            author: "Author",
            cover: "book",
            chapters: [
                Chapter(title: "Chapter One", pages: ["Page 1", "Page 2"]),
                Chapter(title: "Chapter Two", pages: ["Page 1", "Page 2"])
            ]
        )),
        isPresented: .constant(true)
    )
}
