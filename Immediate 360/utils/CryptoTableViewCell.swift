import UIKit

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var contentMyView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }


    func configure(with cryptoCurrency: CryptoCurrency) {
       
        self.nameLabel.text = cryptoCurrency.name
        self.symbolLabel.text = cryptoCurrency.symbol
        loadImage(symbol: cryptoCurrency.symbol.lowercased())
        contentMyView.layer.cornerRadius = 20
        contentMyView.clipsToBounds = true
        
    }
    
    func configure(with fiatCurrency: FiatCurrency) {
       
        self.nameLabel.text = fiatCurrency.name
        self.symbolLabel.text = fiatCurrency.symbol.uppercased()
        loadImageFiat(symbol: fiatCurrency.symbol.lowercased())
        contentMyView.layer.cornerRadius = 20
        contentMyView.clipsToBounds = true
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
    }
    
    func loadImage(symbol: String) {
        guard let url = URL(string: "https://assets.coincap.io/assets/icons/\(symbol)@2x.png") else { return }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.iconImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    func loadImageFiat(symbol: String) {
        let newSymbol = String(symbol.dropLast())
        guard let url = URL(string: "https://flagcdn.com/60x45/\(newSymbol).png") else { return }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                var imageData: Data?
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    imageData = data
                } else {
                    imageData = UIImage(named: "not_found")?.pngData()
                }
                
                DispatchQueue.main.async {
                    self?.iconImageView.image = UIImage(data: imageData!)
                }
            }
            task.resume()
    }
}
