//
//  Album.swift
//  Saavn
//
//  Created by Keerthi Devipriya(kdp) on 03/03/24.
//

import Foundation

struct Album: Codable {
    var album: String?
    var album_url: String?
    var image_url: String?
    var language: String?
    var autoplay: String?
    var liked: String?
    var duration: String?
    var perma_url: String?
}


class AlbumDomainModel {
    var album: String?
    var image_url: String?
    var language: String?
    var perma_url: String?
    
    init(model: Album) {
        self.album = model.album
        self.perma_url = model.perma_url
        self.image_url = model.image_url
        self.language = model.language
    }
}


class DetailViewModel {
    var albumDomainModel: AlbumDomainModel?
    
    init(albumDomainModel: AlbumDomainModel? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            ApiIntegration.getAlbum { album in
                self.albumDomainModel = AlbumDomainModel(model: album)
            }
        }
    }
    
    func fetchAlbumDomainModel(completion: @escaping((AlbumDomainModel) -> Void)) {
        completion(self.albumDomainModel!)
    }
}
