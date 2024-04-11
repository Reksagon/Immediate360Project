import UIKit

class CryptoCalculatorViewController: UIViewController {
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var viewTextField1: UIView!
    @IBOutlet var viewTextField2: UIView!
    @IBOutlet var viewCurrency: UIView!
    @IBOutlet var viewValue: UIView!
    @IBOutlet var labelCurrency: UILabel!
    @IBOutlet var labelValue: UILabel!
    @IBOutlet var imgCurrency: UIImageView!
    @IBOutlet var imgValue: UIImageView!
    @IBOutlet var textFieldCurrency: UITextField!
    @IBOutlet var textFieldValue: UITextField!
    
    
    static var currencyId = 0
    static var valueId = 1
    static var currencyCrypto = true
    static var valueCrypto = true
    var fiatRate = 0.0
    var fiatRateCurrency = 0.0
    var destinationVCcurrency = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCorners()
        
        setStart()
        
        textFieldCurrency.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tapGestureImageView = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imgCurrency.isUserInteractionEnabled = true
        imgCurrency.addGestureRecognizer(tapGestureImageView)
        let tapGestureLabel = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        labelCurrency.isUserInteractionEnabled = true
        labelCurrency.addGestureRecognizer(tapGestureLabel)
        let tapGestureView = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        viewCurrency.isUserInteractionEnabled = true
        viewCurrency.addGestureRecognizer(tapGestureView)
        
        let tapGestureImageViewValue = UITapGestureRecognizer(target: self, action: #selector(handleTapValue))
        imgValue.isUserInteractionEnabled = true
        imgValue.addGestureRecognizer(tapGestureImageViewValue)
        let tapGestureLabelValue = UITapGestureRecognizer(target: self, action: #selector(handleTapValue))
        labelValue.isUserInteractionEnabled = true
        labelValue.addGestureRecognizer(tapGestureLabelValue)
        let tapGestureViewValue = UITapGestureRecognizer(target: self, action: #selector(handleTapValue))
        viewValue.isUserInteractionEnabled = true
        viewValue.addGestureRecognizer(tapGestureViewValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("ChildDidDismiss"), object: nil)
        
    }
    
    func setStart()
    {
        if CryptoCalculatorViewController.currencyCrypto && CryptoCalculatorViewController.valueCrypto
        {
            labelCurrency.text = ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.currencyId].symbol
            labelValue.text = ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.valueId].symbol
            
            loadImage(symbol: ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.currencyId].symbol, imageView: imgCurrency)
            loadImage(symbol: ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.valueId].symbol, imageView: imgValue)
            
            textFieldCurrency.text = "1"
            let countCurrency = Double(textFieldCurrency.text!)
            let btcValueInUSD = countCurrency! * Double(ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.currencyId].priceUsd)!
            let ethAmount = btcValueInUSD / Double(ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.valueId].priceUsd)!
            textFieldValue.text = String(format: "%.4f", ethAmount)
        }
        else if !CryptoCalculatorViewController.currencyCrypto && CryptoCalculatorViewController.valueCrypto
        {
            FiatDataService.shared.fetchFiatDataDetail(for:ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.currencyId].symbol, completion: { fiatDetail in
                
                guard let fiatDetail = fiatDetail?.first,
                      let currencyRates = fiatDetail.rates[ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.currencyId].symbol],
                      let rate = currencyRates[ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.valueId].symbol.lowercased()] else {
                    print("Не вдалося знайти курс")
                    return
                }
                
                self.fiatRate = rate
                
                DispatchQueue.main.async {
                    self.textFieldCurrency.text = "1"
                    self.textFieldValue.text = String(format: "%.4f", rate)
                }
                
                
            })
            
            labelCurrency.text = ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.currencyId].symbol.uppercased()
            labelValue.text = ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.valueId].symbol
            
            loadImageFiat(symbol: ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.currencyId].symbol, imageView:imgCurrency)
            loadImage(symbol: ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.valueId].symbol, imageView: imgValue)
        }
        else if CryptoCalculatorViewController.currencyCrypto && !CryptoCalculatorViewController.valueCrypto
        {
            FiatDataService.shared.fetchFiatDataDetail(for:ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol, completion: { fiatDetail in
                
                guard let fiatDetail = fiatDetail?.first,
                      let currencyRates = fiatDetail.rates[ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol],
                      let rate = currencyRates[ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.currencyId].symbol.lowercased()] else {
                    print("Не вдалося знайти курс")
                    return
                }
                
                self.fiatRate = rate
                
                DispatchQueue.main.async {
                    self.textFieldCurrency.text = "1"
                    var cost = 1/rate
                    self.textFieldValue.text = String(format: "%.4f", cost)
                }
                
                
            })
            
            labelCurrency.text = ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.currencyId].symbol
            labelValue.text = ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol.uppercased()
            
            loadImage(symbol: ChooseCurrencyViewController.currency!.crypto[CryptoCalculatorViewController.currencyId].symbol, imageView:imgCurrency)
            loadImageFiat(symbol: ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol, imageView: imgValue)
        }
        else 
        {
            FiatDataService.shared.fetchFiatDataDetail(for:ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol, completion: { fiatDetail in
                
                guard let fiatDetail = fiatDetail?.first,
                      let currencyRates = fiatDetail.rates[ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol],
                      let rate = currencyRates[ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.currencyId].symbol] else {
                    print("Не вдалося знайти курс")
                    return
                }
                
                self.fiatRate = rate
                DispatchQueue.main.async {
                    self.textFieldCurrency.text = "1"
                    var cost = 1/rate
                    self.textFieldValue.text = String(format: "%.4f", cost)
                }
            })
            labelCurrency.text = ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.currencyId].symbol.uppercased()
            labelValue.text = ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol.uppercased()
            
            loadImageFiat(symbol: ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.currencyId].symbol, imageView:imgCurrency)
            loadImageFiat(symbol: ChooseCurrencyViewController.currency!.fiat[CryptoCalculatorViewController.valueId].symbol, imageView: imgValue)
        }
        
    }
    
    @objc func updateUI() {
        setStart()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChooseCurrency" {
            if let destinationVC = segue.destination as? ChooseCurrencyViewController {
                destinationVC.currency = destinationVCcurrency
            }
        }
    }
    
    @objc func handleTap() {
        destinationVCcurrency = true
        performSegue(withIdentifier: "ShowChooseCurrency", sender: self)
    }
    
    @objc func handleTapValue() {
        destinationVCcurrency = false
        performSegue(withIdentifier: "ShowChooseCurrency", sender: self)
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
    
    func loadImageFiat(symbol: String, imageView: UIImageView) {
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
                imageView.image = UIImage(data: imageData!)
            }
        }
        task.resume()
    }
    
    func setCorners()
    {
        viewTop.layer.cornerRadius = 32
        viewTop.clipsToBounds = true
        
        viewTextField1.layer.cornerRadius = 20
        viewTextField1.layer.masksToBounds = true
        viewTextField2.layer.cornerRadius = 20
        viewTextField2.layer.masksToBounds = true
        
        viewCurrency.layer.cornerRadius = 12
        viewCurrency.layer.masksToBounds = true
        viewValue.layer.cornerRadius = 12
        viewValue.layer.masksToBounds = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if CryptoCalculatorViewController.currencyCrypto && CryptoCalculatorViewController.valueCrypto
        {
            guard let countCurrencyStr = textFieldCurrency.text,
                  let countCurrency = Double(countCurrencyStr),
                  let btcPriceUsdStr = ChooseCurrencyViewController.currency?.crypto[CryptoCalculatorViewController.currencyId].priceUsd,
                  let btcPriceUsd = Double(btcPriceUsdStr),
                  let ethPriceUsdStr = ChooseCurrencyViewController.currency?.crypto[CryptoCalculatorViewController.valueId].priceUsd,
                  let ethPriceUsd = Double(ethPriceUsdStr) else {
                textFieldValue.text = ""
                return
            }
            
            let btcValueInUSD = countCurrency * btcPriceUsd
            let ethAmount = btcValueInUSD / ethPriceUsd
            textFieldValue.text = String(format: "%.4f", ethAmount)
        }else if !CryptoCalculatorViewController.currencyCrypto && CryptoCalculatorViewController.valueCrypto
        {
            
            if let amountText = textFieldCurrency.text, let amount = Double(amountText) {
                let value = amount * self.fiatRate
                self.textFieldValue.text = String(format: "%.4f", value)
            } else {
                self.textFieldValue.text = ""
            }
            
        }
        else
        {
            if let amountText = textFieldCurrency.text, let amount = Double(amountText) {
                let value = amount/self.fiatRate
                self.textFieldValue.text = String(format: "%.4f", value)
            } else {
                self.textFieldValue.text = ""
            }
        }
    }
    
    
    
    
}
