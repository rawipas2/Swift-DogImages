//
//  HomeViewModel.swift
//  DogAPI
//
//  Created by Rawipas Samoondee on 10/9/2566 BE.
//

import UIKit
import Combine

class HomeViewModel: ObservableObject {
    
    private var controller : HomeViewController!
    private var images : [UIImage] = []
    
    init(controller: HomeViewController)
    {
        self.controller = controller
        self.reloadData()
    }
    
    func reloadData() {
        fetchDogImageData { [weak self] dogImage in
            guard let imageURLs = dogImage?.message
            else { return }
            
            self?.getUIImagesDog(imageURLs: imageURLs) { [weak self] images in
                self?.images = images
                self?.controller.collectionView.reloadData()
            }
        }
    }
    
    private func randomBetween() -> Int {
        return Int.random(in: 5...10)
    }
    
    private func fetchDogImageData(completion: @escaping (DogImagesData?) -> Void) {
        let apiUrl = URL(string: "https://dog.ceo/api/breeds/image/random/\(randomBetween().description)")!
        let session = URLSession.shared
        let request = URLRequest(url: apiUrl)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let dogImages = try JSONDecoder().decode(DogImagesData.self, from: data)
                completion(dogImages)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    private func getUIImagesDog(
        imageURLs: [String] ,
        completion: @escaping ([UIImage]) -> Void)
    {
        let imageDownloadQueue = DispatchQueue(label: "downloadImageDogQueue",
                                               attributes: .concurrent)
        let downloadGroup = DispatchGroup()
        var images : [UIImage] = []
        for imageURL in imageURLs {
            downloadGroup.enter()
            imageDownloadQueue.async {
                if let url = URL(string: imageURL),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
                downloadGroup.leave()
            }
        }
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion(images)
        }
    }
    
    func getNumberImageCollection() -> Int {
        return images.count
    }
    
    func getUIImageByIndex(index: Int) -> UIImage {
        return images[index]
    }
}
