import UIKit

class KeyboardViewController: UIInputViewController, SuggestionBarDelegate {
    
    // Engine & State
    private let engine = T9Engine.shared
    private var isSymbolMode: Bool = false
    
    // UI Elements
    private let mainContainerView = UIView()
    private let suggestionBar = SuggestionBarView()
    private let keypadStackView = UIStackView()
    
    private var nextKeyboardButton: UIButton?
    private var heightConstraint: NSLayoutConstraint?
    
    // Cache tombol untuk update teks/mode
    private var keyButtons: [T9KeyButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEngineCallbacks()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Tinggi optimal untuk iPhone 14 Plus (layar 6.7 inch)
        let isLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        let targetHeight: CGFloat = isLandscape ? 220 : 285
        
        if heightConstraint == nil {
            heightConstraint = view.heightAnchor.constraint(equalToConstant: targetHeight)
            heightConstraint?.priority = UILayoutPriority(999)
            heightConstraint?.isActive = true
        } else {
            heightConstraint?.constant = targetHeight
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTheme()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 1. Suggestion Bar (Paling Atas)
        suggestionBar.delegate = self
        view.addSubview(suggestionBar)
        
        // 2. Main Keypad Container
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainContainerView)
        
        NSLayoutConstraint.activate([
            suggestionBar.topAnchor.constraint(equalTo: view.topAnchor),
            suggestionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainContainerView.topAnchor.constraint(equalTo: suggestionBar.bottomAnchor, constant: 6),
            mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            mainContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6)
        ])
        
        buildKeypadGrid()
        updateTheme()
    }
    
    // MARK: - 3x4 Grid + Action Keys (Persis Type Nine)
    private func buildKeypadGrid() {
        keypadStackView.axis = .vertical
        keypadStackView.distribution = .fillEqually
        keypadStackView.spacing = 6
        keypadStackView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(keypadStackView)
        
        NSLayoutConstraint.activate([
            keypadStackView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            keypadStackView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            keypadStackView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            keypadStackView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor)
        ])
        
        // Row 1: [1: .,?!] [2: ABC] [3: DEF] [⌫ Backspace]
        let row1 = createRowStackView()
        row1.addArrangedSubview(createKey("1", letters: ".,?!", isFunc: false))
        row1.addArrangedSubview(createKey("2", letters: "abc", isFunc: false))
        row1.addArrangedSubview(createKey("3", letters: "def", isFunc: false))
        let backspaceBtn = createActionKey("⌫", action: #selector(backspaceTouchDown))
        backspaceBtn.addTarget(self, action: #selector(backspaceTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        row1.addArrangedSubview(backspaceBtn)
        keypadStackView.addArrangedSubview(row1)
        
        // Row 2: [4: GHI] [5: JKL] [6: MNO] [🌐 Next Keyboard / Globe]
        let row2 = createRowStackView()
        row2.addArrangedSubview(createKey("4", letters: "ghi", isFunc: false))
        row2.addArrangedSubview(createKey("5", letters: "jkl", isFunc: false))
        row2.addArrangedSubview(createKey("6", letters: "mno", isFunc: false))
        row2.addArrangedSubview(createGlobeKey())
        keypadStackView.addArrangedSubview(row2)
        
        // Row 3: [7: PQRS] [8: TUV] [9: WXYZ] [↵ Return / Send]
        let row3 = createRowStackView()
        row3.addArrangedSubview(createKey("7", letters: "pqrs", isFunc: false))
        row3.addArrangedSubview(createKey("8", letters: "tuv", isFunc: false))
        row3.addArrangedSubview(createKey("9", letters: "wxyz", isFunc: false))
        row3.addArrangedSubview(createActionKey("↵", action: #selector(handleReturn)))
        keypadStackView.addArrangedSubview(row3)
        
        // Row 4: [T9/ABC Mode] [0: Spasi] [⇧ Shift] [123 / Simbol]
        let row4 = createRowStackView()
        row4.addArrangedSubview(createActionKey("T9", action: #selector(toggleTypingMode)))
        row4.addArrangedSubview(createKey("0", letters: "spasi", isFunc: false, customAction: #selector(handleSpace)))
        row4.addArrangedSubview(createActionKey("⇧", action: #selector(handleShift)))
        row4.addArrangedSubview(createActionKey("123", action: #selector(toggleSymbolMode)))
        keypadStackView.addArrangedSubview(row4)
    }
    
    private func createRowStackView() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 6
        return row
    }
    
    private func createKey(_ number: String, letters: String, isFunc: Bool, customAction: Selector? = nil) -> T9KeyButton {
        let btn = T9KeyButton(number: number, letters: letters, isFunc: isFunc)
        if let custom = customAction {
            btn.addTarget(self, action: custom, for: .touchDown)
        } else {
            btn.addTarget(self, action: #selector(numberKeyTapped(_:)), for: .touchDown)
        }
        keyButtons.append(btn)
        return btn
    }
    
    private func createActionKey(_ title: String, action: Selector) -> T9KeyButton {
        let btn = T9KeyButton(number: title, letters: "", isFunc: true)
        btn.addTarget(self, action: action, for: .touchDown)
        keyButtons.append(btn)
        return btn
    }
    
    private func createGlobeKey() -> UIButton {
        let btn = T9KeyButton(number: "🌐", letters: "", isFunc: true)
        btn.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.nextKeyboardButton = btn
        keyButtons.append(btn)
        return btn
    }
    
    // MARK: - Engine Callbacks (GO Keyboard Inline Multi-Tap)
    private func setupEngineCallbacks() {
        engine.onMultiTapInsert = { [weak self] char in
            self?.textDocumentProxy.insertText(char)
            self?.suggestionBar.setSuggestions([char])
        }
        
        engine.onMultiTapReplace = { [weak self] char in
            self?.textDocumentProxy.deleteBackward()
            self?.textDocumentProxy.insertText(char)
            self?.suggestionBar.setSuggestions([char])
        }
        
        engine.onMultiTapCommit = { [weak self] in
            self?.suggestionBar.setSuggestions([])
        }
    }
    
    // MARK: - Key Actions
    
    @objc private func numberKeyTapped(_ sender: T9KeyButton) {
        let digit = sender.keyValue
        
        if isSymbolMode {
            textDocumentProxy.insertText(digit)
            return
        }
        
        if engine.currentMode == .t9Predictive {
            let suggestions = engine.addDigit(digit)
            suggestionBar.setSuggestions(suggestions)
        } else {
            engine.handleMultiTap(key: digit)
        }
    }
    
    @objc private func handleSpace() {
        if isSymbolMode {
            textDocumentProxy.insertText("0")
            return
        }
        
        if engine.currentMode == .t9Predictive {
            if !engine.currentDigits.isEmpty {
                let predictions = engine.currentPredictions.isEmpty ? engine.getPredictions() : engine.currentPredictions
                if let bestWord = predictions.first {
                    textDocumentProxy.insertText(bestWord + " ")
                } else {
                    textDocumentProxy.insertText(" ")
                }
                engine.resetSequence()
                suggestionBar.setSuggestions([])
            } else {
                textDocumentProxy.insertText(" ")
            }
        } else {
            engine.commitPendingMultiTap()
            textDocumentProxy.insertText(" ")
        }
    }
    
    private var backspaceTimer: Timer?
    
    @objc private func backspaceTouchDown() {
        handleBackspace()
        backspaceTimer?.invalidate()
        backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { [weak self] _ in
            self?.backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] _ in
                self?.handleBackspace()
            }
        }
    }
    
    @objc private func backspaceTouchUp() {
        backspaceTimer?.invalidate()
        backspaceTimer = nil
    }
    
    @objc private func handleBackspace() {
        if engine.currentMode == .t9Predictive && !engine.currentDigits.isEmpty {
            let updated = engine.removeLastDigit()
            suggestionBar.setSuggestions(updated)
        } else {
            if engine.hasActiveMultiTap {
                engine.cancelMultiTap()
                suggestionBar.setSuggestions([])
            }
            textDocumentProxy.deleteBackward()
        }
    }
    
    @objc private func handleReturn() {
        if engine.currentMode == .t9Predictive && !engine.currentDigits.isEmpty {
            let predictions = engine.currentPredictions.isEmpty ? engine.getPredictions() : engine.currentPredictions
            if let first = predictions.first {
                textDocumentProxy.insertText(first)
            }
            engine.resetSequence()
            suggestionBar.setSuggestions([])
        } else if engine.hasActiveMultiTap {
            engine.commitPendingMultiTap()
        }
        textDocumentProxy.insertText("\n")
    }
    
    @objc private func handleShift() {
        engine.toggleShift()
        if engine.currentMode == .t9Predictive {
            let updated = engine.getPredictions()
            suggestionBar.setSuggestions(updated)
        } else if engine.hasActiveMultiTap, let newChar = engine.currentMultiTapChar {
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(newChar)
            suggestionBar.setSuggestions([newChar])
        }
    }
    
    @objc private func toggleTypingMode(_ sender: T9KeyButton) {
        if engine.currentMode == .t9Predictive {
            engine.currentMode = .multiTap
            sender.numberLabel.text = "ABC"
        } else {
            engine.currentMode = .t9Predictive
            sender.numberLabel.text = "T9"
        }
        engine.resetSequence()
        engine.commitPendingMultiTap()
        suggestionBar.setSuggestions([])
    }
    
    @objc private func toggleSymbolMode(_ sender: T9KeyButton) {
        isSymbolMode = !isSymbolMode
        sender.numberLabel.text = isSymbolMode ? "ABC" : "123"
        
        // Update label tombol
        for btn in keyButtons where !btn.isFunctionKey && btn.keyValue != "0" {
            btn.lettersLabel.isHidden = isSymbolMode
        }
    }
    
    // MARK: - SuggestionBarDelegate
    func didSelectSuggestion(_ word: String) {
        textDocumentProxy.insertText(word + " ")
        engine.resetSequence()
        suggestionBar.setSuggestions([])
    }
    
    private func updateTheme() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        view.backgroundColor = isDark ? UIColor(white: 0.16, alpha: 1.0) : UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1.0)
        suggestionBar.applyTheme()
        for btn in keyButtons {
            btn.applyTheme()
        }
    }
}
