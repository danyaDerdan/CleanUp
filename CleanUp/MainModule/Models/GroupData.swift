import Foundation
import Photos
import CoreLocation

enum GroupData {
    case succes([PhotoGroup])
    case loading
    case deleted
    case failure(Error)
    
    struct PhotoGroup {
        let date: Date
        let location: CLLocation?
        var assets: [PHAsset]
    }
}
