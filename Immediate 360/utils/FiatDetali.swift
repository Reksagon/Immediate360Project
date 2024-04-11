import Foundation

struct FiatDetali: Codable {
    let date: String
    let rates: [String: [String: Double]]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        
        let dynamicKeyContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
        
        var rates = [String: [String: Double]]()
        for key in dynamicKeyContainer.allKeys {
            if key.stringValue != "date" { 
                let value = try dynamicKeyContainer.decode([String: Double].self, forKey: key)
                rates[key.stringValue] = value
            }
        }
        self.rates = rates
    }
    
    enum CodingKeys: String, CodingKey {
        case date
    }
    
    struct DynamicCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
}

