import Foundation

enum TypingMode {
    case t9Predictive // Satu sentuhan per tombol, prediksi kata otomatis
    case multiTap     // Tekan berulang (classic Nokia 3310 style)
    case numbers      // Angka langsung
}

enum CapitalizationState {
    case lowercase
    case capitalized
    case uppercase
}

class T9Engine {
    static let shared = T9Engine()
    
    // Mapping Karakter ke Angka T9
    private let charToDigit: [Character: Character] = [
        "a": "2", "b": "2", "c": "2",
        "d": "3", "e": "3", "f": "3",
        "g": "4", "h": "4", "i": "4",
        "j": "5", "k": "5", "l": "5",
        "m": "6", "n": "6", "o": "6",
        "p": "7", "q": "7", "r": "7", "s": "7",
        "t": "8", "u": "8", "v": "8",
        "w": "9", "x": "9", "y": "9", "z": "9"
    ]
    
    // Mapping Angka ke Daftar Huruf (Multi-Tap)
    let digitToLetters: [String: [String]] = [
        "1": [".", ",", "?", "!", "'", "-", "@", "1"],
        "2": ["a", "b", "c", "2"],
        "3": ["d", "e", "f", "3"],
        "4": ["g", "h", "i", "4"],
        "5": ["j", "k", "l", "5"],
        "6": ["m", "n", "o", "6"],
        "7": ["p", "q", "r", "s", "7"],
        "8": ["t", "u", "v", "8"],
        "9": ["w", "x", "y", "z", "9"],
        "0": [" ", "0"]
    ]
    
    // Dictionary Cache: [DigitSequence: [Words]]
    private var digitWordMap: [String: [String]] = [:]
    
    // State Saat Ini
    var currentDigits: String = ""
    var currentMode: TypingMode = .t9Predictive
    var capState: CapitalizationState = .capitalized
    var currentPredictions: [String] = []
    
    // Multi-tap State (Responsif ala T9 GO Keyboard)
    private var lastTappedKey: String?
    private var multiTapIndex: Int = 0
    private var multiTapTimer: Timer?
    private let multiTapTimeout: TimeInterval = 0.4 // Timeout cepat & responsif (400ms)
    
    var onMultiTapInsert: ((String) -> Void)?
    var onMultiTapReplace: ((String) -> Void)?
    var onMultiTapCommit: (() -> Void)?
    
    var hasActiveMultiTap: Bool {
        return lastTappedKey != nil
    }
    
    var currentMultiTapChar: String? {
        guard let key = lastTappedKey, let chars = digitToLetters[key] else { return nil }
        return applyCapitalization(chars[multiTapIndex])
    }
    
    init() {
        buildDictionaryIndex()
    }
    
    private func buildDictionaryIndex() {
        for word in DictionaryData.words {
            let lower = word.lowercased()
            var digits = ""
            for char in lower {
                if let d = charToDigit[char] {
                    digits.append(d)
                }
            }
            if !digits.isEmpty {
                if digitWordMap[digits] == nil {
                    digitWordMap[digits] = []
                }
                digitWordMap[digits]?.append(lower)
            }
        }
    }
    
    // MARK: - T9 Predictive Methods
    
    /// Menambahkan input digit ke urutan saat ini (misal menekan tombol 4 -> "4")
    func addDigit(_ digit: String) -> [String] {
        currentDigits.append(digit)
        return getPredictions()
    }
    
    /// Menghapus satu digit terakhir (Backspace)
    func removeLastDigit() -> [String] {
        if !currentDigits.isEmpty {
            currentDigits.removeLast()
        }
        return getPredictions()
    }
    
    /// Reset urutan kata saat ini (misal setelah spasi atau memilih saran)
    func resetSequence() {
        currentDigits = ""
        currentPredictions = []
    }
    
    /// Mendapatkan daftar prediksi kata berdasarkan currentDigits
    func getPredictions() -> [String] {
        guard !currentDigits.isEmpty else {
            currentPredictions = []
            return []
        }
        
        var results: [String] = []
        
        // 1. Exact match dari kamus
        if let exactWords = digitWordMap[currentDigits] {
            results.append(contentsOf: exactWords)
        }
        
        // 2. Prefix match (kata yang berawalan dari sequence ini)
        for (digits, words) in digitWordMap {
            if digits != currentDigits && digits.hasPrefix(currentDigits) {
                results.append(contentsOf: words)
                if results.count >= 15 { break }
            }
        }
        
        // 3. Fallback jika kata tidak ditemukan di kamus: buat permutasi sederhana
        if results.isEmpty {
            let fallback = generateFallbackWord(digits: currentDigits)
            results.append(fallback)
        }
        
        // Terapkan Capitalization
        let capitalizedResults = results.map { applyCapitalization($0) }
        currentPredictions = capitalizedResults
        return capitalizedResults
    }
    
    private func generateFallbackWord(digits: String) -> String {
        var word = ""
        for d in digits {
            if let letters = digitToLetters[String(d)], let first = letters.first {
                word.append(first)
            }
        }
        return word
    }
    
    func applyCapitalization(_ word: String) -> String {
        switch capState {
        case .lowercase:
            return word.lowercased()
        case .capitalized:
            guard let first = word.first else { return word }
            return String(first).uppercased() + word.dropFirst().lowercased()
        case .uppercase:
            return word.uppercased()
        }
    }
    
    func toggleShift() {
        switch capState {
        case .lowercase:
            capState = .capitalized
        case .capitalized:
            capState = .uppercase
        case .uppercase:
            capState = .lowercase
        }
    }
    
    // MARK: - Multi-Tap Mode Methods (GO Keyboard Style)
    
    func handleMultiTap(key: String) {
        multiTapTimer?.invalidate()
        
        guard let chars = digitToLetters[key], !chars.isEmpty else { return }
        
        if lastTappedKey == key {
            multiTapIndex = (multiTapIndex + 1) % chars.count
            let currentChar = applyCapitalization(chars[multiTapIndex])
            onMultiTapReplace?(currentChar)
        } else {
            // Commit karakter sebelumnya sebelum berpindah tombol
            commitPendingMultiTap()
            lastTappedKey = key
            multiTapIndex = 0
            let currentChar = applyCapitalization(chars[multiTapIndex])
            onMultiTapInsert?(currentChar)
        }
        
        // Timer responsif (400ms) untuk auto-commit
        multiTapTimer = Timer.scheduledTimer(withTimeInterval: multiTapTimeout, repeats: false) { [weak self] _ in
            self?.commitPendingMultiTap()
        }
    }
    
    func commitPendingMultiTap() {
        multiTapTimer?.invalidate()
        multiTapTimer = nil
        guard lastTappedKey != nil else { return }
        lastTappedKey = nil
        multiTapIndex = 0
        onMultiTapCommit?()
    }
    
    func cancelMultiTap() {
        multiTapTimer?.invalidate()
        multiTapTimer = nil
        lastTappedKey = nil
        multiTapIndex = 0
    }
}
