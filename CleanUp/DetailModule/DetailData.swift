import Foundation

enum DetaiData {
    case success(DetailModel)
    
    struct DetailModel {
        let imageData: Data
        let text: String
    }
}
