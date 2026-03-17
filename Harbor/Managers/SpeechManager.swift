import Foundation
import Speech
import AVFoundation

enum VoiceCommand {
    case nextPage
    case previousPage
    case goToChapter(Int)
    case none
}

class SpeechManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    @Published var isListening = false
    @Published var recognizedText = ""
    @Published var lastCommand: VoiceCommand = .none
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var audioSession: AVAudioSession {
        AVAudioSession.sharedInstance()
    }
    
    override init() {
        super.init()
        setupSpeechRecognition()
    }
    
    private func setupSpeechRecognition() {
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("[v0] Speech recognition authorized")
                case .denied, .restricted, .notDetermined:
                    print("[v0] Speech recognition not authorized")
                @unknown default:
                    break
                }
            }
        }
    }
    
    func startListening() {
        guard !isListening else { return }
        guard let recognizer = speechRecognizer, recognizer.isAvailable else { return }
        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                var isFinal = false
                
                if let result = result {
                    let recognizedText = result.bestTranscription.formattedString
                    DispatchQueue.main.async {
                        self?.recognizedText = recognizedText
                    }
                    
                    isFinal = result.isFinal
                    
                    if isFinal {
                        self?.processVoiceCommand(recognizedText)
                    }
                }
                
                if error != nil || isFinal {
                    DispatchQueue.main.async {
                        self?.isListening = false
                    }
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)!
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            DispatchQueue.main.async {
                self.isListening = true
            }
        } catch {
            print("[v0] Error starting speech recognition: \(error)")
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
        
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
    
    private func processVoiceCommand(_ text: String) {
        let lowerText = text.lowercased()
        
        var command: VoiceCommand = .none
        
        // Check for next page commands
        if lowerText.contains("next") || lowerText.contains("forward") {
            command = .nextPage
        }
        // Check for previous page commands
        else if lowerText.contains("previous") || lowerText.contains("back") || lowerText.contains("last") {
            command = .previousPage
        }
        // Check for chapter commands (e.g., "go to chapter 3")
        else if lowerText.contains("chapter") {
            if let numberString = extractNumber(from: text),
               let chapterNumber = Int(numberString) {
                command = .goToChapter(chapterNumber - 1) // Convert to 0-indexed
            }
        }
        
        DispatchQueue.main.async {
            self.lastCommand = command
            // Reset command after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.lastCommand = .none
            }
        }
    }
    
    private func extractNumber(from text: String) -> String? {
        let pattern = "\\d+"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            if let match = regex.firstMatch(in: text, range: range) {
                if let range = Range(match.range, in: text) {
                    return String(text[range])
                }
            }
        }
        return nil
    }
    
    func triggerHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}
