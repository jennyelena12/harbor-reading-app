import Foundation

struct Book: Identifiable, Codable {
    let id: UUID
    let title: String
    let author: String
    let cover: String // SF Symbol name
    let chapters: [Chapter]
    var currentChapterIndex: Int = 0
    var currentPageIndex: Int = 0
    var readingProgress: Double = 0.0
    
    init(id: UUID = UUID(), title: String, author: String, cover: String, chapters: [Chapter]) {
        self.id = id
        self.title = title
        self.author = author
        self.cover = cover
        self.chapters = chapters
    }
    
    var totalPages: Int {
        chapters.reduce(0) { $0 + $1.pages.count }
    }
    
    var currentPage: String? {
        guard currentChapterIndex < chapters.count,
              currentPageIndex < chapters[currentChapterIndex].pages.count else {
            return nil
        }
        return chapters[currentChapterIndex].pages[currentPageIndex]
    }
    
    var currentChapter: Chapter? {
        guard currentChapterIndex < chapters.count else { return nil }
        return chapters[currentChapterIndex]
    }
    
    mutating func nextPage() {
        if currentPageIndex < (currentChapter?.pages.count ?? 0) - 1 {
            currentPageIndex += 1
        } else if currentChapterIndex < chapters.count - 1 {
            currentChapterIndex += 1
            currentPageIndex = 0
        }
        updateProgress()
    }
    
    mutating func previousPage() {
        if currentPageIndex > 0 {
            currentPageIndex -= 1
        } else if currentChapterIndex > 0 {
            currentChapterIndex -= 1
            currentPageIndex = (currentChapter?.pages.count ?? 1) - 1
        }
        updateProgress()
    }
    
    mutating func goToChapter(_ index: Int) {
        if index >= 0 && index < chapters.count {
            currentChapterIndex = index
            currentPageIndex = 0
            updateProgress()
        }
    }
    
    private mutating func updateProgress() {
        let totalPagesRead = chapters[0..<currentChapterIndex].reduce(0) { $0 + $1.pages.count } + currentPageIndex
        readingProgress = Double(totalPagesRead) / Double(totalPages)
    }
}

struct Chapter: Identifiable, Codable {
    let id: UUID
    let title: String
    let pages: [String]
    
    init(id: UUID = UUID(), title: String, pages: [String]) {
        self.id = id
        self.title = title
        self.pages = pages
    }
}

struct FavoriteSentence: Identifiable, Codable {
    let id: UUID
    let text: String
    let bookTitle: String
    let chapterTitle: String
    let pageNumber: Int
    let timestamp: Date
    
    init(id: UUID = UUID(), text: String, bookTitle: String, chapterTitle: String, pageNumber: Int, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.bookTitle = bookTitle
        self.chapterTitle = chapterTitle
        self.pageNumber = pageNumber
        self.timestamp = timestamp
    }
}
