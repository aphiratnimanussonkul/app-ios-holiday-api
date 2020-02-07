import Foundation

enum HolidayError: Error {
    case noDataAvilable
    case canNotProcessData
}

struct HolidayRequest {
    let resourceURL: URL
    let API_KEY = "4ffde523176cdad0808ba1a8c816b3c55b435004"
    
    init(countryCode: String) {
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy"
        let currentYear = dateFormat.string(from: date)
        let resourceString = "https://calendarific.com/api/v2/holidays?api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"

        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        
        self.resourceURL = resourceURL
    }
    
    func getHolidays(completion: @escaping(Result<[HolidayDetail], HolidayError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {
            data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvilable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let holidaysResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                let holidayDetail = holidaysResponse.response.holidays
                completion(.success(holidayDetail))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        
        dataTask.resume()
    }
}
