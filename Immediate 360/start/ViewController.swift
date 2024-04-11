
import UIKit
import FirebaseRemoteConfigInternal
import WebKit
import AppTrackingTransparency
import AdSupport

class ViewController: UIViewController {
    
    @IBOutlet var viewBottom: UIImageView!
    @IBOutlet var buttonStart: UIButton!
    @IBOutlet var myView: WKWebView!
    
    var isDataLoaded = false
    let remoteConfig = RemoteConfig.remoteConfig()
    var fetched = false
    let defaults = UserDefaults.standard
    static var namingUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBottom.layer.cornerRadius = 32
        viewBottom.clipsToBounds = true
        
        
        if let savedValue = defaults.string(forKey: "someKey") {
            print("Значення з кешу: \(savedValue)")
            loadMyView(url: savedValue)
        }
        else
        {
            fetchRemoteConfig()
            fetchData {
                print("All data fetched and processed")
                self.isDataLoaded = true
            }
        }
       

        //defaults.removeObject(forKey: "someKey")



       
    }
    

    
    func fetchData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        CryptoDataService.shared.fetchCryptoData { cryptoData in
            CryptoDataService.cryptoData = cryptoData
            print("Crypto data fetched")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FiatDataService.shared.fetchFiatData { fiatData in
            FiatDataService.fiatData = fiatData
            print("Fiat data fetched")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NewsService.shared.fetchNewsData { articles in
            NewsService.shared.fetchNewsData { articles in
                if let articles = articles {
                    print("News data fetched")
                    NewsViewController.newsData = articles
                } else {
                    print("News data error")
                }
                
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.processData()
            completion()
        }
    }
    
    
    func processData() {
        guard let cryptoData = CryptoDataService.cryptoData, let fiatData = FiatDataService.fiatData else {
            // Відобразіть повідомлення про помилку і дайте можливість повторити
            showAlertForRetry()
            return
        }
        let filteredFiatData = fiatData.filter { fiatCurrency in
            !cryptoData.contains { $0.symbol.lowercased() == fiatCurrency.symbol.lowercased() }
        }
        
        let fiatDataWithIDs = filteredFiatData.enumerated().map { index, fiatCurrency in
            var mutableFiatCurrency = fiatCurrency
            mutableFiatCurrency.id = index
            return mutableFiatCurrency
        }
        
        FiatDataService.fiatData = fiatDataWithIDs
        ChooseCurrencyViewController.currency = Currency(crypto: CryptoDataService.cryptoData!, fiat: FiatDataService.fiatData!)
        
        print("Data has been processed")
    }
    
    func showAlertForRetry() {
        let alert = UIAlertController(title: "Error", message: "Failed to load data. Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.fetchData {
                print("All data fetched and processed")
                self.isDataLoaded = true
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func startButton(_ sender: Any)
    {
        if self.isDataLoaded && self.fetched
        {
            //performSegue(withIdentifier: "goToMainScreen", sender: self)
            if ViewController.namingUrl != ""
            {
                self.loadMyView(url: ViewController.namingUrl)
                self.defaults.set(ViewController.namingUrl, forKey: "someKey")
            }else
            {
                UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.25, options: .transitionCrossDissolve,
                                  animations: {
                    UIApplication.shared.keyWindow!.rootViewController = UIStoryboard(name: "MainScreen", bundle: nil).instantiateInitialViewController()
                })
            }
        }
        showAlertForRetry()
    }
    
    func loadMyView(url: String)
    {
        let myURL = URL(string:url)
        let myRequest = URLRequest(url: myURL!)
        self.myView.isHidden = false
        self.myView.load(myRequest)
    }
    
    
    func fetchRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self?.remoteConfig.activate { (changed, error) in
                    let yourValue = self?.remoteConfig.configValue(forKey: "test").stringValue ?? ""
                    if yourValue != ""
                    {
                        self!.loadMyView(url: yourValue)
                        self!.defaults.set(yourValue, forKey: "someKey")
                    }
                    else
                    {
                        self!.fetched = true
                    }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
                self!.fetched = true
            }
        }
    }

    
}

