import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var privacyView: UIView!
    @IBOutlet var termsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTop.layer.cornerRadius = 32
        viewTop.clipsToBounds = true
        
        privacyView.layer.cornerRadius = 20
        privacyView.clipsToBounds = true
        
        termsView.layer.cornerRadius = 20
        termsView.clipsToBounds = true
        
        let tapGesturePrivacy = UITapGestureRecognizer(target: self, action: #selector(viewTappedPrivacy))
        privacyView.addGestureRecognizer(tapGesturePrivacy)
        
        let tapGestureTerms = UITapGestureRecognizer(target: self, action: #selector(viewTappedTerms))
        termsView.addGestureRecognizer(tapGestureTerms)
        
    }
    
    @objc func viewTappedPrivacy() {
        if let viewControllerToShow = storyboard?.instantiateViewController(withIdentifier: "PrivacyVC") as? PrivacyViewController {
                viewControllerToShow.modalPresentationStyle = .fullScreen
                present(viewControllerToShow, animated: true, completion: nil)
            }
    }
    
    @objc func viewTappedTerms() {
        if let viewControllerToShow = storyboard?.instantiateViewController(withIdentifier: "TermsVC") as? TermsViewController {
                viewControllerToShow.modalPresentationStyle = .fullScreen
                present(viewControllerToShow, animated: true, completion: nil)
            }
    }
}
