import UIKit

class FuturesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet weak var chooseCryptoCurrency: UITextField!
    @IBOutlet weak var enterInvestment: UITextField!
    @IBOutlet weak var enterSellingPrice: UITextField!
    @IBOutlet var lblProfit: UILabel!
    @IBOutlet var lblSumProfit: UILabel!
    @IBOutlet var lblFinalAmount: UILabel!
    @IBOutlet var bttnClearData: UIButton!
    @IBOutlet var viewCurrency: UIView!
    @IBOutlet var labelCurrency: UILabel!
    @IBOutlet var imgCurrency: UIImageView!
    
    var hidden = false
    static var indexCurrency = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTop.layer.cornerRadius = 32
        viewTop.clipsToBounds = true
        

        viewCurrency.layer.cornerRadius = 12
        viewCurrency.layer.masksToBounds = true
        setChooseCryptoCurrency()
        setEnterInvestment()
        setEnterSellingPrice()
        setDelegate()
        
        bttnClearData.layer.cornerRadius = 25
        bttnClearData.layer.borderWidth = 1
        bttnClearData.layer.borderColor = UIColor(hex: "#424242")?.cgColor
        
        
        let tapGestureImageView = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imgCurrency.isUserInteractionEnabled = true
        imgCurrency.addGestureRecognizer(tapGestureImageView)
        let tapGestureLabel = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        labelCurrency.isUserInteractionEnabled = true
        labelCurrency.addGestureRecognizer(tapGestureLabel)
        let tapGestureView = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        viewCurrency.isUserInteractionEnabled = true
        viewCurrency.addGestureRecognizer(tapGestureView)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("ChildDidDismiss"), object: nil)
        
        setStart()

        
    }
    
    @objc func updateUI() {
        setStart()
    }
    
    func setStart()
    {
        
        var item = ChooseCurrencyViewController.currency!.crypto[FuturesViewController.indexCurrency]
        labelCurrency.text = item.symbol
        loadImage(symbol: item.symbol, imageView: imgCurrency)
    
        var amount = Double(item.priceUsd)!
        chooseCryptoCurrency.text = String(format: "%.4f", amount)
    }
    
    @objc func handleTap() {
        performSegue(withIdentifier: "ShowCryptoFutures", sender: self)
    }
    
    @IBAction func clearData()
    {
        hidden = false
        lblProfit.isHidden = true
        lblSumProfit.isHidden = true
        lblFinalAmount.isHidden = true
        bttnClearData.isHidden = true
        
        enterInvestment.text = ""
        enterSellingPrice.text = ""
    }
    
    func setChooseCryptoCurrency()
    {
        chooseCryptoCurrency.layer.cornerRadius = 20
        chooseCryptoCurrency.layer.masksToBounds = true
        if let textField = self.chooseCryptoCurrency {
            let placeholderText = "Choose cryptocurrency"
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }

    }

    func setEnterInvestment()
    {
        enterInvestment.layer.cornerRadius = 20
        enterInvestment.layer.masksToBounds = true
        if let textField = self.enterInvestment {
            let placeholderText = "Enter your investment, $"
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }

    }
    
    func setEnterSellingPrice()
    {
        enterSellingPrice.layer.cornerRadius = 20
        enterSellingPrice.layer.masksToBounds = true
        if let textField = self.enterSellingPrice {
            let placeholderText = "Enter selling price, $"
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }

    }
    
    func setDelegate()
    {
        chooseCryptoCurrency.delegate = self
        enterInvestment.delegate = self
        enterSellingPrice.delegate = self
        
        chooseCryptoCurrency.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        enterInvestment.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        enterSellingPrice.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
            checkFields()
        }

        func checkFields() {
            if chooseCryptoCurrency.text?.isEmpty == false && enterInvestment.text?.isEmpty == false && enterSellingPrice.text?.isEmpty == false {
                if !hidden
                {
                    hidden = true
                    lblProfit.isHidden = false
                    lblSumProfit.isHidden = false
                    lblFinalAmount.isHidden = false
                    bttnClearData.isHidden = false
                }
                
                if let currencyText = chooseCryptoCurrency.text, let currency = Double(currencyText),
                   let investmentText = enterInvestment.text, let investment = Double(investmentText),
                   let sellingText = enterSellingPrice.text, let selling = Double(sellingText) {
                    let count = investment / currency
                    let final = count * selling
                    let profit = final - investment
                    
                    if profit >= 0 {
                        lblSumProfit.text = String(format: "+$%.2f", profit)
                    } else {
                        lblSumProfit.text = String(format: "-$%.2f", abs(profit))
                    }
                    
                    lblFinalAmount.text = String(format: "Final amount: $%.2f", final)
                } else {
                    lblSumProfit.text = "Error"
                    lblFinalAmount.text = "Error"
                }

            }
        }
    
    func loadImage(symbol: String, imageView: UIImageView) {
        guard let url = URL(string: "https://assets.coincap.io/assets/icons/\(symbol.lowercased())@2x.png") else { return }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }

}
