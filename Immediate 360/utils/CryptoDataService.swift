import Foundation

class CryptoDataService {
    static let shared = CryptoDataService()
    static var cryptoData: [CryptoCurrency]?

    func fetchCryptoData(completion: @escaping ([CryptoCurrency]?) -> Void) {
        let urlString = "https://api.coincap.io/v2/assets"
        guard let url = URL(string: urlString) else { return }
        
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
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                completion(apiResponse.data)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func getCachedData() -> [CryptoCurrency]? {
        return CryptoDataService.cryptoData
    }
}

