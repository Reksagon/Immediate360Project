import Foundation

struct Currency: Codable {
    var crypto: [CryptoCurrency]
    var fiat: [FiatCurrency]
}
