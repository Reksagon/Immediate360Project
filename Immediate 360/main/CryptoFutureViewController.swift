import UIKit

class CryptoFutureViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var textFieldSeacrch: UITextField!
    var filteredCryptoData: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        filteredCryptoData = ChooseCurrencyViewController.currency!
        
        setCorners()
    }
    

    func setCorners()
    {
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
        return filteredCryptoData?.crypto.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoFutureCell", for: indexPath) as? CryptoTableViewCell,
              let cryptoCurrency = filteredCryptoData?.crypto[indexPath.row] else {
            fatalError("Unable to dequeue CryptoTableViewCell or CryptoCurrency is nil")
        }
        
        cell.configure(with: cryptoCurrency)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cryptoCurrency = filteredCryptoData?.crypto[indexPath.row] {
            FuturesViewController.indexCurrency = Int(cryptoCurrency.rank)!-1
        }
        NotificationCenter.default.post(name: NSNotification.Name("ChildDidDismiss"), object: nil)
        dismiss(animated: true)
    }
    
}
