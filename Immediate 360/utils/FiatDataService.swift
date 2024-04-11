import Foundation

class FiatDataService {
    static let shared = FiatDataService()
    static var fiatData: [FiatCurrency]?
    
    func fetchFiatData(completion: @escaping ([FiatCurrency]?) -> Void) {
        guard let url = URL(string: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data")
                completion(nil)  
                return
            }
            
            do {
                if let cryptoDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                    let filteredCryptoDictionary = cryptoDictionary.filter { !$0.value.isEmpty }
                    let fiatCurrencies = filteredCryptoDictionary.map { symbol, name in
                        FiatCurrency(symbol: symbol, name: name)
                    }
                    completion(fiatCurrencies)
                }
            } catch {
                print("JSON error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchFiatDataDetail(for currencyCode: String, completion: @escaping ([FiatDetali]?) -> Void) {
        guard let url = URL(string: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/\(currencyCode).json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let fiatDetail = try decoder.decode(FiatDetali.self, from: data)
                completion([fiatDetail])
            } catch {
                print("JSON error: \(error)")
                completion(nil)
            }
        }
        task.resume()

    }

}

