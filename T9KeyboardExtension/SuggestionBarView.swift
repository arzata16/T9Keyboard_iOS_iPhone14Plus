import UIKit

protocol SuggestionBarDelegate: AnyObject {
    func didSelectSuggestion(_ word: String)
}

class SuggestionBarView: UIView {
    weak var delegate: SuggestionBarDelegate?
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let dividerLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dividerLine)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            dividerLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        applyTheme()
    }
    
    func setSuggestions(_ words: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if words.isEmpty {
            let placeholder = UILabel()
            placeholder.text = "Ketik angka untuk prediksi T9..."
            placeholder.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            placeholder.textColor = UIColor.tertiaryLabel
            stackView.addArrangedSubview(placeholder)
            return
        }
        
        for (index, word) in words.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(word, for: .normal)
            
            if index == 0 {
                // Saran utama diberi aksen bold
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                button.setTitleColor(tintColor, for: .normal)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                button.setTitleColor(UIColor.label, for: .normal)
            }
            
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            button.configuration = config
            button.backgroundColor = UIColor.secondarySystemFill
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            button.addTarget(self, action: #selector(suggestionTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func suggestionTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        UIDevice.current.playInputClick()
        delegate?.didSelectSuggestion(title)
    }
    
    func applyTheme() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        backgroundColor = isDark ? UIColor(white: 0.22, alpha: 1.0) : UIColor(red: 0.88, green: 0.90, blue: 0.93, alpha: 1.0)
        dividerLine.backgroundColor = isDark ? UIColor(white: 0.35, alpha: 1.0) : UIColor(red: 0.78, green: 0.80, blue: 0.84, alpha: 1.0)
    }
}
