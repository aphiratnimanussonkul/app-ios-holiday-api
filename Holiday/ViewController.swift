import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    @IBOutlet weak var searchBarCountryCode: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var listHoliday = [HolidayDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listHoliday.count) Holiday Found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarCountryCode.delegate = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listHoliday.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let holiday = listHoliday[indexPath.row]
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listHoliday.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBarCountryCode.text else {
            return
        }
        
        let holidaysRequest = HolidayRequest(countryCode: searchBarText)
        holidaysRequest.getHolidays {
            [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let holidays):
                self?.listHoliday = holidays
            }
        }
    }
    
}

