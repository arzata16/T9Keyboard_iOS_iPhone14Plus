import UIKit

class ViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let testTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "T9Keyboard Hadi"
        view.backgroundColor = UIColor.systemGroupedBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.axis = .vertical
        contentView.spacing = 18
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        // 1. Interactive Test Box
        let testBoxCard = createCardView()
        let lblTestTitle = UILabel()
        lblTestTitle.text = "🧪 Uji Coba Keyboard di Sini"
        lblTestTitle.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        testTextField.placeholder = "Ketuk di sini untuk mencoba T9..."
        testTextField.borderStyle = .roundedRect
        testTextField.font = UIFont.systemFont(ofSize: 16)
        testTextField.clearButtonMode = .whileEditing

        let lblHint = UILabel()
        lblHint.text = "Ketuk kotak di atas. Jika keyboard bawaan muncul, tekan tombol bola dunia (🌐) di kiri bawah untuk berpindah ke T9 Keyboard."
        lblHint.font = UIFont.systemFont(ofSize: 13)
        lblHint.textColor = .secondaryLabel
        lblHint.numberOfLines = 0

        testBoxCard.addArrangedSubview(lblTestTitle)
        testBoxCard.addArrangedSubview(testTextField)
        testBoxCard.addArrangedSubview(lblHint)
        contentView.addArrangedSubview(testBoxCard)

        // 2. Setup Guide Card
        let guideCard = createCardView()
        let lblGuideTitle = UILabel()
        lblGuideTitle.text = "📲 Cara Mengaktifkan di WhatsApp & iPhone"
        lblGuideTitle.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        let stepsText = """
        Keyboard T9 ini berjalan sebagai keyboard sistemik resmi iOS, sehingga bisa digunakan langsung di WhatsApp, Telegram, Instagram, Safari, dan semua aplikasi chat!

        Langkah aktivasi di iPhone 14 Plus:
        1. Buka menu Pengaturan (Settings) di iPhone Anda.
        2. Pilih Umum (General) ➔ Papan Ketik (Keyboard).
        3. Ketuk Papan Ketik (Keyboards) ➔ Tambah Papan Ketik Baru (Add New Keyboard...).
        4. Di bagian 'Papan Ketik Pihak Ketiga', pilih 'T9 Keyboard'.
        5. Selesai! Buka WhatsApp, ketuk kolom pesan, lalu tahan atau tekan tombol bola dunia (🌐) di pojok kiri bawah untuk memilih T9 Keyboard.
        """
        let lblSteps = UILabel()
        lblSteps.text = stepsText
        lblSteps.font = UIFont.systemFont(ofSize: 14)
        lblSteps.textColor = .label
        lblSteps.numberOfLines = 0

        let btnOpenSettings = UIButton(type: .system)
        btnOpenSettings.setTitle("⚙️ Buka Pengaturan iPhone", for: .normal)
        btnOpenSettings.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btnOpenSettings.backgroundColor = .systemBlue
        btnOpenSettings.setTitleColor(.white, for: .normal)
        btnOpenSettings.layer.cornerRadius = 10
        btnOpenSettings.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btnOpenSettings.addTarget(self, action: #selector(openIOSSettings), for: .touchUpInside)

        guideCard.addArrangedSubview(lblGuideTitle)
        guideCard.addArrangedSubview(lblSteps)
        guideCard.addArrangedSubview(btnOpenSettings)
        contentView.addArrangedSubview(guideCard)

        // 3. Feature Highlights
        let featureCard = createCardView()
        let lblFeatureTitle = UILabel()
        lblFeatureTitle.text = "✨ Fitur Utama T9 Keyboard"
        lblFeatureTitle.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        let featText = """
        • Prediktif Cerdas T9: Cukup tekan tombol angka sekali per huruf, kata akan langsung diprediksi otomatis (Kamus Bahasa Indonesia & Inggris).
        • Mode Multi-Tap Klasik: Beralih ke gaya Nokia 3310 (tekan tombol 2 tiga kali untuk huruf 'C').
        • Getaran Haptik: Umpan balik getaran taktil yang realistis dan suara klik mekanik.
        • Desain Khusus iPhone 14 Plus: Layout 3x4 luas dan nyaman digunakan satu tangan.
        """
        let lblFeatures = UILabel()
        lblFeatures.text = featText
        lblFeatures.font = UIFont.systemFont(ofSize: 13.5)
        lblFeatures.textColor = .secondaryLabel
        lblFeatures.numberOfLines = 0

        featureCard.addArrangedSubview(lblFeatureTitle)
        featureCard.addArrangedSubview(lblFeatures)
        contentView.addArrangedSubview(featureCard)
    }

    private func createCardView() -> UIStackView {
        let card = UIStackView()
        card.axis = .vertical
        card.spacing = 12
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 14
        card.isLayoutMarginsRelativeArrangement = true
        card.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return card
    }

    @objc private func openIOSSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
