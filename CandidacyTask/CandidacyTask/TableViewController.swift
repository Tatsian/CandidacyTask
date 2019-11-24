import UIKit

class TableViewController: UITableViewController {
    
    var usersArray = [User]()
    var urlString = "https://jsonplaceholder.typicode.com/users"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()        
    }
    
    func downloadData() {
        guard let url = URL(string: urlString) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) {(data, responce, error) in
            guard let dataResponce = data else { return }
            DispatchQueue.main.async {
                self.parse(data: dataResponce)
                self.tableView.reloadData()
            }
        }
        dataTask.resume()
    }
    
    func parse(data: Data) {
        do {
            usersArray = try JSONDecoder().decode([User].self, from: data)
        } catch let error {
            print("there is an error: \(error)")
        }
    }
    
    static func storyboardInstance() -> DetailTableViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DetailTableViewController") as? DetailTableViewController
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = usersArray[indexPath.row]
        cell.textLabel?.text = user.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let testVC = TableViewController.storyboardInstance() else { return }
        testVC.userIdValue = usersArray[indexPath.row].id
        let navigationController = UINavigationController(rootViewController: testVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(testVC, animated: true)
    }
}
