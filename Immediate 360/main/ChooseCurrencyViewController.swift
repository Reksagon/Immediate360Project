import UIKit

class ChooseCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    @IBOutlet var textFieldSeacrch: UITextField!
    @IBOutlet var bttnCrypto: UIButton!
    @IBOutlet var bttnFiat: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var crypto = true
    var filteredCryptoData: Currency?
    static var currency: Currency?
    var currency: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldSeacrch.delegate = self
        filteredCryptoData = ChooseCurrencyViewController.currency!
        
        setCorners()
    }
    
    @IBAction func click()
    {
        if crypto
        {
            crypto = false
            bttnCrypto.layer.borderWidth = 1
            bttnCrypto.layer.borderColor = UIColor(hex: "#424242")?.cgColor
            bttnCrypto.backgroundColor = UIColor.clear
            bttnCrypto.tintColor = UIColor.white
            
            bttnFiat.layer.borderWidth = 0
            bttnFiat.backgroundColor = UIColor.white
            bttnFiat.tintColor = UIColor(hex: "#171717")
        }
        else
        {
            crypto = true
            bttnFiat.layer.borderWidth = 1
            bttnFiat.layer.borderColor = UIColor(hex: "#424242")?.cgColor
            bttnFiat.backgroundColor = UIColor.clear
            bttnFiat.tintColor = UIColor.white
            
            bttnCrypto.layer.borderWidth = 0
            bttnCrypto.backgroundColor = UIColor.white
            bttnCrypto.tintColor = UIColor(hex: "#171717")
            
        }
        
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    func setCorners()
    {
        bttnFiat.layer.cornerRadius = 20
        bttnFiat.layer.borderWidth = 1
        bttnFiat.layer.borderColor = UIColor(hex: "#424242")?.cgColor
        bttnFiat.clipsToBounds = true
        
        bttnCrypto.layer.cornerRadius = 20
        bttnCrypto.clipsToBounds = true
        bttnCrypto.backgroundColor = UIColor.white
        
        textFieldSeacrch.layer.cornerRadius = 20
        textFieldSeacrch.clipsToBounds = true
        
        textFieldSeacrch.layer.cornerRadius = 20
        textFieldSeacrch.layer.masksToBounds = true
        if let textField = self.textFieldSeacrch {
            let placeholderText = "Search"
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if crypto
        {
            return filteredCryptoData?.crypto.count ?? 0
        }
        else
        {
            return filteredCryptoData?.fiat.count ?? 0
        }
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if crypto
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoTableViewCell,
                  let cryptoCurrency = filteredCryptoData?.crypto[indexPath.row] else {
                fatalError("Unable to dequeue CryptoTableViewCell or CryptoCurrency is nil")
            }
            cell.configure(with: cryptoCurrency)
            return cell
        }
        else
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoTableViewCell,
                  let fiatCurrency = filteredCryptoData?.fiat[indexPath.row] else {
                fatalError("Unable to dequeue CryptoTableViewCell or CryptoCurrency is nil")
            }
            cell.configure(with: fiatCurrency)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if crypto
        {
            if currency!
            {
                
                if let cryptoCurrency = filteredCryptoData?.crypto[indexPath.row] {
                    CryptoCalculatorViewController.currencyId = Int(cryptoCurrency.rank)!-1
                }
                CryptoCalculatorViewController.currencyCrypto = true
            }
            else
            {
                if let cryptoCurrency = filteredCryptoData?.crypto[indexPath.row] {
                    CryptoCalculatorViewController.valueId = Int(cryptoCurrency.rank)!-1
                }
                CryptoCalculatorViewController.valueCrypto = true
            }
            
        }
        else
        {
            if currency!
            {
                if let cryptoCurrency = filteredCryptoData?.fiat[indexPath.row]{
                    CryptoCalculatorViewController.currencyId = cryptoCurrency.id!
                }
                CryptoCalculatorViewController.currencyCrypto = false
            }
            else
            {
                if let cryptoCurrency = filteredCryptoData?.fiat[indexPath.row] {
                    CryptoCalculatorViewController.valueId = cryptoCurrency.id!
                }
                CryptoCalculatorViewController.valueCrypto = false
            }
        }

        
        NotificationCenter.default.post(name: NSNotification.Name("ChildDidDismiss"), object: nil)
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        filterContentForSearchText(searchText)
        return true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if crypto {
            filteredCryptoData?.crypto = searchText.isEmpty ? ChooseCurrencyViewController.currency!.crypto : ChooseCurrencyViewController.currency?.crypto.filter { cryptoCurrency -> Bool in
                return cryptoCurrency.symbol.lowercased().contains(searchText.lowercased())
            } ?? []
        } else {
            filteredCryptoData?.fiat = searchText.isEmpty ? ChooseCurrencyViewController.currency!.fiat : ChooseCurrencyViewController.currency?.fiat.filter { fiatCurrency -> Bool in
                return fiatCurrency.symbol.lowercased().contains(searchText.lowercased())
            } ?? []
        }

        tableView.reloadData()
    }

    
}
