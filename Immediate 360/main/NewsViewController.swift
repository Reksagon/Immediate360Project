import UIKit

class NewsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsViewController.newsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell.")
        }
        if let newsData = NewsViewController.newsData, indexPath.row < newsData.count {
            let news = newsData[indexPath.row]
            cell.configure(with: news)
        } else {
            fatalError("newsData is either nil or the indexPath is out of bounds.")
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let newsData = NewsViewController.newsData, indexPath.row < newsData.count {
            let news = newsData[indexPath.row]
            UIApplication.shared.open(news.url)
        }
        
    }
    
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    static var newsData: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTop.layer.cornerRadius = 32
        viewTop.clipsToBounds = true
    
    }


}
