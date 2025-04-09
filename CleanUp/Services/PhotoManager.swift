import Photos

protocol PhotoManagerProtocol {
    func groupAssets(_ assets: [PHAsset]) -> [GroupData.PhotoGroup]
}

final class PhotoManager: PhotoManagerProtocol {
    func groupAssets(_ assets: [PHAsset]) -> [GroupData.PhotoGroup] {
        var groupsDict = [String: GroupData.PhotoGroup]()
        for asset in assets  {
            guard let date = asset.creationDate else { continue }
            
            let groupKey = asset.groupKey()
            
            if var group = groupsDict[groupKey] {
                group.assets.append(asset)
                groupsDict[groupKey] = group
            } else {
                groupsDict[groupKey] = GroupData.PhotoGroup(
                    date: date,
                    location: asset.location,
                    assets: [asset]
                )
            }
        }
        return groupsDict.values
            .filter { $0.assets.count >= 2 }
            .sorted { $0.date > $1.date }
    }
}

private extension PHAsset {
    func groupKey() -> String {
        guard let date = creationDate else { return UUID().uuidString }
        let dateKey = Calendar.current.startOfDay(for: date).timeIntervalSince1970
        if let location = location {
            let lat = String(format: "%.3f", location.coordinate.latitude)
            let lon = String(format: "%.3f", location.coordinate.longitude)
            return "location_\(dateKey)_\(lat)_\(lon)"
        }
        return "date_\(dateKey)"
    }
}
