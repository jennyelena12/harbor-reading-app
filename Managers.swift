import SwiftUI
import Speech
import AVFoundation
import CoreMotion

// MARK: - Ambient Light Manager

@MainActor
class AmbientLightManager: NSObject, ObservableObject {
    @Published var brightness: Double = 0.5
    @Published var isDarkMode: Bool = false
    
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let motionManager = CMMotionManager()
    private var lastUpdate = Date()
    
    override init() {
        super.init()
        setupAmbientLightDetection()
        startMotionUpdates()
    }
    
    private func setupAmbientLightDetection() {
        captureSession = AVCaptureSession()
        guard let session = captureSession else { return }
        
        session.sessionPreset = .high
        
        guard let device = AVCaptureDevice.default(for: .video) else {
            fallbackBrightness()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            videoOutput = AVCaptureVideoDataOutput()
            videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "lightQueue"))
            
            if let output = videoOutput, session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            DispatchQueue.background.async { [weak self] in
                session.startRunning()
            }
        } catch {
            print("[Harbor] Camera setup failed, using fallback brightness")
            fallbackBrightness()
        }
    }
    
    private func startMotionUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 1.0
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] data, _ in
            // Use accelerometer to detect if device is held at comfortable reading angle
            // This helps refine brightness adjustments
            self?.adjustBrightnessForPosture(data)
        }
    }
    
    private func adjustBrightnessForPosture(_ data: CMAccelerometerData?) {
        // Subtle adjustment based on device orientation
        guard let data = data else { return }
        
        let zAccel = data.acceleration.z
        // If device is more horizontal (reading position), slight brightness adjustment
        if zAccel < -0.5 {
            // Device is tilted for reading, optionally increase brightness slightly
            self.brightness = min(self.brightness + 0.05, 1.0)
        }
    }
    
    private func fallbackBrightness() {
        // Fallback: use system brightness as reference
        brightness = Double(UIScreen.main.brightness)
    }
    
    deinit {
        if let session = captureSession {
            DispatchQueue.background.async {
                session.stopRunning()
            }
        }
        motionManager.stopAccelerometerUpdates()
    }
}

// MARK: - Ambient Light Capture Delegate

extension AmbientLightManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Rate limit updates to once per second
        guard Date().timeIntervalSince(lastUpdate) > 1.0 else { return }
        lastUpdate = Date()
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly) }
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer) else { return }
        
        let buffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        
        var totalBrightness: UInt64 = 0
        let sampleSize = min(100, width * height)
        
        for i in 0..<sampleSize {
            let offset = (i * bytesPerRow) % (width * height * 4)
            let r = UInt64(buffer[offset])
            let g = UInt64(buffer[offset + 1])
            let b = UInt64(buffer[offset + 2])
            totalBrightness += (r + g + b) / 3
        }
        
        let averageBrightness = Double(totalBrightness / UInt64(sampleSize)) / 255.0
        
        DispatchQueue.main.async { [weak self] in
            // Smooth the brightness value with exponential moving average
            self?.brightness = (self?.brightness ?? 0.5) * 0.7 + averageBrightness * 0.3
            
            // Determine if dark mode based on low light
            self?.isDarkMode = averageBrightness < 0.3
        }
    }
}

// MARK: - Speech Recognition Manager

@MainActor
class SpeechRecognitionManager: NSObject, ObservableObject {
    @Published var isListening = false
    @Published var recognizedText = ""
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    override init() {
        super.init()
        requestMicrophoneAccess()
    }
    
    private func requestMicrophoneAccess() {
        AVAudioApplication.requestRecordPermission { granted in
            if !granted {
                print("[Harbor] Microphone access denied")
            }
        }
        
        SFSpeechRecognizer.requestAuthorization { _ in }
    }
    
    func startListening(completion: @escaping (VoiceCommand?) -> Void) {
        guard !isListening else { return }
        
        isListening = true
        recognizedText = "Listening..."
        
        do {
            try setupAudioSession()
            try startRecognition(completion: completion)
        } catch {
            print("[Harbor] Speech recognition error: \(error)")
            isListening = false
        }
    }
    
    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    private func startRecognition(completion: @escaping (VoiceCommand?) -> Void) throws {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false
            
            if let result = result {
                self?.recognizedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
                
                if isFinal {
                    let command = self?.parseVoiceCommand(result.bestTranscription.formattedString)
                    completion(command)
                    self?.stopListening()
                }
            }
            
            if error != nil || isFinal {
                self?.audioEngine.stop()
                self?.audioEngine.inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)!
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isListening = false
        recognizedText = ""
    }
    
    private func parseVoiceCommand(_ text: String) -> VoiceCommand? {
        let lowercased = text.lowercased()
        
        if lowercased.contains("next") || lowercased.contains("forward") {
            return .nextPage
        } else if lowercased.contains("previous") || lowercased.contains("back") {
            return .previousPage
        } else if lowercased.contains("chapter") {
            // Extract chapter number: "go to chapter 5" -> 5
            let components = lowercased.components(separatedBy: " ")
            if let chapterIndex = components.firstIndex(of: "chapter"),
               components.indices.contains(chapterIndex + 1),
               let number = Int(components[chapterIndex + 1]) {
                return .goToChapter(number)
            }
        }
        
        return nil
    }
}

enum VoiceCommand {
    case nextPage
    case previousPage
    case goToChapter(Int)
}

// MARK: - Book Manager

@MainActor
class BookManager: ObservableObject {
    @Published var books = sampleBooks
    @Published var currentBook: Book?
    @Published var favorites: [FavoriteSentence] = []
    
    private let favoritesKey = "harbor_favorites"
    
    init() {
        currentBook = books.first
        loadFavorites()
    }
    
    func selectBook(_ book: Book) {
        currentBook = book
    }
    
    func updateCurrentPage(_ page: Int) {
        if var book = currentBook {
            book.currentPage = min(max(page, 0), book.totalPages - 1)
            currentBook = book
            if let index = books.firstIndex(where: { $0.id == book.id }) {
                books[index] = book
            }
        }
    }
    
    func nextPage() {
        if let book = currentBook {
            updateCurrentPage(book.currentPage + 1)
        }
    }
    
    func previousPage() {
        if let book = currentBook {
            updateCurrentPage(book.currentPage - 1)
        }
    }
    
    func getCurrentPageText() -> String {
        guard let book = currentBook, book.currentPage < book.totalPages else { return "" }
        
        var pageCount = 0
        for chapter in book.chapters {
            for page in chapter.pages {
                if pageCount == book.currentPage {
                    return page
                }
                pageCount += 1
            }
        }
        return ""
    }
    
    func getCurrentLocation() -> (chapterTitle: String, pageInChapter: Int) {
        guard let book = currentBook else { return ("", 0) }
        
        var pageCount = 0
        for chapter in book.chapters {
            for (index, _) in chapter.pages.enumerated() {
                if pageCount == book.currentPage {
                    return (chapter.title, index + 1)
                }
                pageCount += 1
            }
        }
        return ("", 0)
    }
    
    func addFavorite(_ text: String) {
        let location = getCurrentLocation()
        let favorite = FavoriteSentence(
            id: UUID().uuidString,
            text: text,
            bookTitle: currentBook?.title ?? "Unknown",
            chapterTitle: location.chapterTitle,
            pageNumber: location.pageInChapter,
            timestamp: Date()
        )
        favorites.append(favorite)
        saveFavorites()
    }
    
    func removeFavorite(_ id: String) {
        favorites.removeAll { $0.id == id }
        saveFavorites()
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([FavoriteSentence].self, from: data) {
            favorites = decoded
        }
    }
}

// MARK: - Helper Extension

extension DispatchQueue {
    static let background = DispatchQueue(label: "com.harbor.background", qos: .background)
}
