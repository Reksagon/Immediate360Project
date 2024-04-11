import UIKit

class NewsTableViewCell: UITableViewCell {


    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet weak var contentMyView: UIView!
    

    func configure(with article: Article) {

        contentMyView.layer.cornerRadius = 20
        contentMyView.clipsToBounds = true
        
   
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withFullDate, .withColonSeparatorInTime, .withTimeZone]
        

        if let date = formatter.date(from: article.publishedAt) {

            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short

            let displayDate = displayFormatter.string(from: date)
            
            DispatchQueue.main.async { [weak self] in
                self?.date.text = displayDate
            }
        } else {
            self.date.text = "Date not available"
        }
        
        self.title.text = article.title
        loadImage(url: article.image)
        
    }



    override func prepareForReuse() {
        super.prepareForReuse()
        
        

    }
    

    
    func loadImage(url: URL) {
    
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                var imageData: Data?
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    imageData = data
                } else {
                    imageData = UIImage(named: "not_found")?.pngData()
                }
                
                DispatchQueue.main.async {
                    self?.titleImageView.image = UIImage(data: imageData!)
                }
            }
            task.resume()
    }
}

