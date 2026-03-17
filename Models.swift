import Foundation

// MARK: - Data Models

struct Book: Identifiable, Codable {
    let id: String
    let title: String
    let author: String
    let coverColor: String // Hex color
    let chapters: [Chapter]
    var currentPage: Int = 0
    var totalPages: Int {
        chapters.reduce(0) { $0 + $1.pages.count }
    }
    
    var progress: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(totalPages)
    }
}

struct Chapter: Identifiable, Codable {
    let id: String
    let title: String
    let pages: [String]
}

struct FavoriteSentence: Identifiable, Codable {
    let id: String
    let text: String
    let bookTitle: String
    let chapterTitle: String
    let pageNumber: Int
    let timestamp: Date
}

// MARK: - Sample Books

let sampleBooks: [Book] = [
    Book(
        id: "book-1",
        title: "The Lighthouse Keeper",
        author: "Sarah Mitchell",
        coverColor: "#4A90E2",
        chapters: [
            Chapter(
                id: "ch-1-1",
                title: "Chapter 1: The Arrival",
                pages: [
                    "The fog rolled in thick and heavy, carrying with it the salt of countless storms. Marcus stood at the bow of the small vessel, watching as the lighthouse gradually emerged from the mist like a sentinel waiting at the world's edge.\n\nTwenty years he'd been away. Twenty years since he last saw the golden light sweeping across these waters, and now, finally, he was coming home.\n\nThe lighthouse keeper's position had opened up just as his letter arrived—as if the universe had been waiting for this exact moment. His hands trembled slightly as the boat cut through the grey waters, drawing closer to the rocky shore below the tower.",
                    "The keeper's cottage was smaller than he remembered. The white paint had weathered to a soft grey, and the windows seemed to look down at him like tired eyes. Inside, everything remained as it was—the logbooks stacked on shelves, the oil cans lined up with military precision, the great lens waiting in its iron frame at the top of the tower.\n\nHe climbed the spiral stairs slowly, letting his feet remember the rhythm they once knew. With each step, a memory surfaced: climbing these stairs as a boy, his father's calloused hand on his shoulder, showing him the mechanism that kept ships safe through the night.\n\nAt the top, the light was dark. Tomorrow, he would ignite it.",
                    "The first night was the hardest. Marcus lay in his old bed, listening to the sound of waves against the rocks below. He had heard this lullaby a thousand times in his dreams, always pulling him back to this place.\n\nWhen midnight came, he rose and dressed in the old keeper's uniform he found hanging in the closet. It fit him still, though his shoulders had grown broader with age. He climbed the stairs one final time and set about lighting the great lamp.\n\nThe match struck with a sound like a promise being kept. The light flared to life, and soon the familiar beam was sweeping across the black water, turning and turning, a constant companion to all who sailed these dangerous waters. Marcus watched from the gallery, tears streaming down his weathered face, and knew he was finally home."
                ]
            ),
            Chapter(
                id: "ch-1-2",
                title: "Chapter 2: The Storm",
                pages: [
                    "Three weeks into the season, the storms began. Marcus had forgotten how violent they could be—the way the wind howled through the tower like a living thing, testing every joint and stone. The sea became a churning, grey-green beast, and the lighthouse beam seemed almost fragile against such raw power.\n\nBut the light held. Hour after hour, it swept across the water, a constant guardian. Ships would pass in the distance, their lights visible only for moments before the darkness swallowed them again.\n\nMarcus remained at his post, checking the lamp, cleaning the lens, ensuring that the light never faltered. This was his purpose now—to be the beacon in the darkness, the fixed point that told lost sailors they were not alone.",
                    "One night, a ship appeared on the edge of the storm, struggling against waves that should have crushed it. Marcus watched through the telescope, his heart in his throat. The vessel was breaking apart, its radio crackling with desperate mayday calls.\n\nHe increased the brightness of the light, something strictly forbidden by the regulations. But regulations were written by men who had never seen a ship break apart on rocks below their lighthouse. The beam cut through the storm with new intensity, and the ship's captain, seeing this extraordinary brightness, adjusted course just enough.\n\nBy dawn, the ship had limped into the harbor, battered but intact. The captain later came to the lighthouse to thank him, and Marcus simply nodded, understanding the weight of what he had done—and why it had been right."
                ]
            )
        ]
    ),
    Book(
        id: "book-2",
        title: "Beneath the Waves",
        author: "Elena Vasquez",
        coverColor: "#2B6CB0",
        chapters: [
            Chapter(
                id: "ch-2-1",
                title: "Chapter 1: The Descent",
                pages: [
                    "The submarine descended smoothly into the abyss, and Dr. Chen pressed her face against the small porthole, unable to look away. At this depth, the ocean became an alien world—no light from the surface had ever reached here, and the pressure would crush an unprotected human instantly.\n\nBut they were protected. The titanium hull of the Mariana held them safe as it sank deeper into the darkness, carrying with it the dreams and fears of a woman who had spent her entire life preparing for this moment.\n\n\"Pressure holding steady,\" her companion called from the controls. \"We're approaching the target depth.\"\n\nDr. Chen nodded, her breath fogging the glass. Somewhere out there, in this darkness, might be the answer to a question humanity had asked for centuries: Are we alone?"
                ]
            )
        ]
    ),
    Book(
        id: "book-3",
        title: "The Captain's Log",
        author: "James Morrison",
        coverColor: "#1B4965",
        chapters: [
            Chapter(
                id: "ch-3-1",
                title: "Introduction",
                pages: [
                    "This log chronicles the voyage of the HMS Voyager across the unknown waters of a world that exists only in dreams and possibilities. I, Captain James Morrison, have set pen to paper to record these strange and wondrous events for posterity, and for those who come after.\n\nMay future sailors find comfort in knowing that others have walked these waters before them, that the horizon, though distant, is always within reach for those brave enough to seek it.\n\nThe journey begins not with a single wave, but with a single wave's memory—the whispered tales of the sea passed down through generations."
                ]
            )
        ]
    ),
    Book(
        id: "book-4",
        title: "Tides of Change",
        author: "Marie Delacroix",
        coverColor: "#00A8CC",
        chapters: [
            Chapter(
                id: "ch-4-1",
                title: "Prologue: The Return",
                pages: [
                    "She came back to the village as the winter tide was turning, bringing with her the salt smell of distant oceans and the weight of impossible decisions. The town had not changed much—the same weathered boats, the same stone houses, the same people who remembered her as the girl who left because she couldn't stay.\n\nBut the sea had changed her. It had made her stronger, and in that strength, lonelier. For to sail is to understand that no shore is truly yours, and every horizon holds the promise of departure."
                ]
            )
        ]
    )
]
