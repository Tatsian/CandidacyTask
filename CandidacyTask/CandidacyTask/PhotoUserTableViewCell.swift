import UIKit

class PhotoUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCell.layer.cornerRadius = 8
        viewCell.layer.masksToBounds = true
        createDefaultShadow(for: shadowView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
        activityIndicator.startAnimating()
    }
    
    func setUpCell(photoInfo: UserPhoto) {
        photoTitle.text = photoInfo.title
    }
    
    func createDefaultShadow(for view: UIView) {
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2.0

        view.clipsToBounds = false
        view.layer.masksToBounds = false
    }
}
