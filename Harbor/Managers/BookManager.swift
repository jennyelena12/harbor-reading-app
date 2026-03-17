import Foundation

class BookManager: ObservableObject {
    @Published var books: [Book] = []
    
    init() {
        loadSampleBooks()
    }
    
    private func loadSampleBooks() {
        let book1 = createBook1()
        let book2 = createBook2()
        let book3 = createBook3()
        
        self.books = [book1, book2, book3]
    }
    
    private func createBook1() -> Book {
        let chapter1Pages = [
            "The sea has always called to those brave enough to listen. On a misty morning in September, Captain Eleanor stood at the helm of her vessel, watching the waves dance beneath the bow. She had sailed these waters for thirty years, but today felt different—charged with possibility.\n\nThe crew moved about their duties with practiced ease, securing ropes and checking sails. Eleanor breathed in the salt air, letting it fill her lungs. This journey would be her greatest yet.",
            "The map sprawled across the captain's table showed uncharted waters ahead. Eleanor traced her weathered finger along the coastline, following the path that legend spoke of. Her first mate, Thomas, entered without knocking—a privilege earned through decades of service.\n\n'The crew is ready,' he said simply.\n\nEleanor looked up, her eyes reflecting the lamplight. 'Then we sail at dawn.'",
            "The first day brought calm seas and clear skies. Eleanor walked the deck, greeting each crew member by name. She knew their families, their dreams, their fears. This was what it meant to be a captain—to carry the hopes of forty souls across endless water.",
            "Night fell like a curtain of velvet. The stars emerged, thousands of them, guiding the way forward. Eleanor stood alone at the bow, watching the phosphorescent wake trail behind them. Tomorrow would bring challenges, but tonight, there was only peace."
        ]
        
        let chapter1 = Chapter(title: "The Calling", pages: chapter1Pages)
        
        let chapter2Pages = [
            "The second week brought unexpected storms. The sky turned the color of bruised iron, and waves rose like mountains of glass. Eleanor ordered the sails trimmed, her commands cutting through the chaos. Every sailor on deck moved with absolute trust.\n\nWhen the worst passed, young James approached her at the wheel. 'Captain, how do you stay so calm?' he asked.\n\nEleanor smiled. 'Fear is useful. Panic is not.'",
            "The storm subsided as quickly as it came, leaving behind a strange, beautiful calm. The sun broke through the clouds in golden rays. Eleanor gathered the crew on deck to assess the damage. Nothing that couldn't be repaired.",
            "That night, she wrote in her journal by candlelight. Each expedition changed her, added layers to her understanding of the sea. The ocean was neither kind nor cruel—it simply was, vast and indifferent. Learning to respect it without fearing it—that was the real art of sailing."
        ]
        
        let chapter2 = Chapter(title: "The Test", pages: chapter2Pages)
        
        let chapter3Pages = [
            "Three weeks into their journey, they spotted land. The crew's spirits soared. Eleanor studied the coastline through her spyglass. It matched the old maps, but there was something more—a hidden cove she hadn't expected.\n\n'Anchor here,' she commanded. 'We explore at first light.'",
            "The cove held wonders. Mineral formations in impossible colors, water so clear you could see fifty feet down. Eleanor led a small party ashore, and they collected samples. Evidence. Proof that legends sometimes held truth.",
            "As they rowed back to the ship, Eleanor reflected on the journey so far. They had faced storms, uncertainty, and the unknown. And they were still here, still sailing, still discovering. This was why she captained ships—not for fortune or fame, but for moments like these, when possibility became reality."
        ]
        
        let chapter3 = Chapter(title: "Discovery", pages: chapter3Pages)
        
        return Book(title: "The Captain's Journey", author: "Sarah Waters", cover: "sailboat.fill", chapters: [chapter1, chapter2, chapter3])
    }
    
    private func createBook2() -> Book {
        let chapter1Pages = [
            "Lighthouse keepers are peculiar people. They choose solitude, isolation, and the ceaseless company of light. Marina had been the keeper of Beacon Point for five years, and she couldn't imagine doing anything else.\n\nEvery evening, she climbed the 287 steps to the lamp room and performed the same ritual. Check the fuel, clean the glass, wind the mechanism. Simple tasks, repeated with devotion.",
            "The lighthouse stood on a rocky outcrop, separated from the mainland by a quarter mile of treacherous water. In storms, waves crashed fifty feet up the tower. In calm, the sea became glass. Marina had learned to read the moods of the ocean as clearly as others read books.",
            "Tonight was her birthday. Forty-three years old, standing in a beam of light that had burned every night for over a century. She poured herself a glass of wine and sat by the window, watching ships pass in the distance. Some blinked back in greeting, following navigation protocols. Marina knew them all."
        ]
        
        let chapter2 = Chapter(title: "The Keeper's Life", pages: chapter1Pages)
        
        let chapter3Pages = [
            "A storm was coming. Marina could smell it in the air, see it in the way the seagulls flew. She secured everything, doubled-checked the fuel reserves, and tested the backup system. The light must always shine. That was the covenant.",
            "When the storm hit, it was spectacular. Wind howled like something alive. Rain came horizontally, pelting the windows. The light continued its steady rotation, cutting through the darkness, guiding lost things home.",
            "In the eye of the storm, Marina climbed to the lamp room. Below, the sea thrashed. Above, stars appeared briefly between clouds. She realized then what others might see as loneliness, she experienced as clarity. Out here, everything was essential. Nothing was wasted."
        ]
        
        let chapter3 = Chapter(title: "The Storm", pages: chapter3Pages)
        
        return Book(title: "Beacon Point", author: "Michael Chen", cover: "light.beacon.min", chapters: [chapter2, chapter3])
    }
    
    private func createBook3() -> Book {
        let chapter1Pages = [
            "The old woman's garden grew only at night. By day, it looked abandoned—overgrown, wild, returning to nature. But when darkness fell, something remarkable happened. Flowers bloomed that no botanist could classify. Fruit appeared that tasted of memory and dream.\n\nNo one knew how old Iris was. Ninety? A hundred and thirty? She had stopped counting decades ago, preferring to measure time by seasons and seasons by the blooming of flowers.",
            "Children in the village told stories about the garden. They said that if you ate the fruit there, you could remember things that hadn't happened yet. Or perhaps things that had happened in other lives. Iris didn't deny the stories. She simply smiled and invited people to visit.",
            "On a spring evening, a young artist appeared at her gate. She was desperate, creatively blocked, unable to paint anything of worth. Iris gave her tea and a place in the garden to sleep.\n\n'Wait,' the old woman said. 'Until the flowers bloom. Then you'll see.'"
        ]
        
        let chapter1 = Chapter(title: "The Garden", pages: chapter1Pages)
        
        let chapter2Pages = [
            "The artist woke to find herself surrounded by impossible beauty. Flowers of indigo and silver, plants that seemed to glow from within. She spent the entire night sketching, her hands moving as if guided by something beyond conscious thought.\n\nWhen dawn came, the garden returned to its overgrown appearance. But the sketches remained—proof of magic, or of something equally real but harder to name.",
            "Iris found her on the garden bench, surrounded by drawings. Without speaking, the old woman sat beside her and waited.\n\n'How?' the artist asked finally.\n\n'The garden doesn't create anything,' Iris replied. 'It reveals what was always there. In you, in the world, in the spaces between things. Sometimes we need darkness to see what shines.'"
        ]
        
        let chapter2 = Chapter(title: "The Revelation", pages: chapter2Pages)
        
        return Book(title: "Iris's Garden", author: "Elena Moretti", cover: "leaf.circle.fill", chapters: [chapter1, chapter2])
    }
    
    func updateBook(_ book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = book
        }
    }
}
