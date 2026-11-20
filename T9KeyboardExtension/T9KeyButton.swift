import UIKit

class T9KeyButton: UIButton {
    let numberLabel = UILabel()
    let lettersLabel = UILabel()
    private let stackView = UIStackView()
    
    var keyValue: String = ""
    var isFunctionKey: Bool = false
    
    init(number: String, letters: String, isFunc: Bool = false) {
        super.init(frame: .zero)
        self.keyValue = number
        self.isFunctionKey = isFunc
        setupViews(number: number, letters: letters)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews(number: "", letters: "")
    }
    
    private func setupViews(number: String, letters: String) {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Haptic feedback & click sound
        self.addTarget(self, action: #selector(playFeedback), for: .touchDown)
        
        if isFunctionKey {
            numberLabel.text = number
            numberLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            numberLabel.textAlignment = .center
            
            addSubview(numberLabel)
            numberLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            numberLabel.text = number
            numberLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
            numberLabel.textAlignment = .center
            
            lettersLabel.text = letters.uppercased()
            lettersLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
            lettersLabel.textAlignment = .center
            lettersLabel.textColor = UIColor.secondaryLabel
            
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 1
            stackView.isUserInteractionEnabled = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(numberLabel)
            stackView.addArrangedSubview(lettersLabel)
            
            addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        applyTheme()
    }
    
    func applyTheme() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        
        if isFunctionKey {
            backgroundColor = isDark ? UIColor(white: 0.32, alpha: 1.0) : UIColor(red: 0.70, green: 0.72, blue: 0.76, alpha: 1.0)
            numberLabel.textColor = isDark ? .white : .black
        } else {
            backgroundColor = isDark ? UIColor(white: 0.42, alpha: 1.0) : UIColor.white
            numberLabel.textColor = isDark ? .white : .black
            lettersLabel.textColor = isDark ? UIColor(white: 0.8, alpha: 1.0) : UIColor(white: 0.35, alpha: 1.0)
        }
    }
    
    private static let feedbackGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()
    
    @objc private func playFeedback() {
        T9KeyButton.feedbackGenerator.impactOccurred()
        T9KeyButton.feedbackGenerator.prepare()
        UIDevice.current.playInputClick()
    }
    
    override var isHighlighted: Bool {
        didSet {
            let isDark = traitCollection.userInterfaceStyle == .dark
            if isHighlighted {
                backgroundColor = isDark ? UIColor(white: 0.55, alpha: 1.0) : UIColor(red: 0.85, green: 0.87, blue: 0.90, alpha: 1.0)
            } else {
                applyTheme()
            }
        }
    }
}
