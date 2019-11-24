import UIKit

class DetailTableViewController: UITableViewController {

    var userIdValue = Int()
    var userPhotosArray = [UserPhoto]()
    var userAlbumArray = [UserAlbum]()
    var albumIds = [Int]()
    var urlPhotoString = "https://jsonplaceholder.typicode.com/photos"
    var urlAlbumString = "https://jsonplaceholder.typicode.com/albums"
    
    var dataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       downloadAlbumData(url: urlAlbumString)
    }

    func downloadAlbumData(url: String) {
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) {(data, responce, error) in
            guard let dataResponce = data else { return }
            DispatchQueue.main.async {
                self.parseAlbum(data: dataResponce)
                self.tableView.reloadData()
          }
        }
        dataTask.resume()
    }
    
    func parseAlbum(data: Data) {
        do {
            let albums = try JSONDecoder().decode([UserAlbum].self, from: data)
            for album in albums {
                if album.userId == userIdValue {
                    userAlbumArray.append(album)
                    albumIds.append(album.id)
                }
            }
        } catch let error {
            print("there is an error: \(error)")
        }
        downloadPhotoData(url: urlPhotoString)
    }
    
    func downloadPhotoData(url: String) {
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) {(data, responce, error) in
            guard let dataResponce = data else { return }
            DispatchQueue.main.async {
                self.parsePhoto(data: dataResponce)
                self.tableView.reloadData()
            }
        }
        dataTask.resume()
    }
    
    func parsePhoto(data: Data) {
        do {
            let photos = try JSONDecoder().decode([UserPhoto].self, from: data)
            for photo in photos {
                for id in albumIds {
                    if photo.albumId == id {
                        userPhotosArray.append(photo)
                    }
                }
            }
        } catch let error {
            print("there is an error: \(error)")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPhotosArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? PhotoUserTableViewCell else {
            return UITableViewCell()
        }
    
        let userPhoto = userPhotosArray[indexPath.row]
        cell.setUpCell(photoInfo: userPhoto)
        let url = userPhoto.url
        dataProvider.downloadImage(url: url) { image in
            cell.photoImage.image = image
            cell.activityIndicator.stopAnimating()
        }
        
        return cell
    }

}
