import Foundation

class NewsService {
    static let shared = NewsService()

    func fetchNewsData(completion: @escaping ([Article]?) -> Void) {
        let urlString = "https://gnews.io/api/v4/search?q=crypto%20news&lang=en&country=us&max=30&apikey=6e05ebbce436e95dde49b0ce894b93e3"
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
                let apiResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(apiResponse.articles)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    

}

