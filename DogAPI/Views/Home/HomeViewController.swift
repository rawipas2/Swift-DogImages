//
//  ViewController.swift
//  DogAPI
//
//  Created by Rawipas Samoondee on 10/9/2566 BE.
//

import UIKit
import Combine
import CoreMotion

class HomeViewController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    // MARK Tag 2000^ < 3000 CollectionView
    enum HomeViewControllerTag: Int {
           case collection = 3000
       }
    
    public var motionManager: CMMotionManager!
    public var collectionView : UICollectionView!
    private var viewModel: HomeViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = view.viewWithTag(HomeViewControllerTag.collection.rawValue) as? UICollectionView
        else { return }
        
        self.collectionView = collectionView
        self.motionManager = CMMotionManager()
        self.viewModel = HomeViewModel(controller: self)
        self.startShakeDetection()
        
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionImage")
    }
    
    private func startShakeDetection() {
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 0.2
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let acceleration = data?.acceleration {
                    let shakeThreshold = 2.0
                    if acceleration.x >= shakeThreshold || acceleration.y >= shakeThreshold || acceleration.z >= shakeThreshold {
                        self.viewModel.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getNumberImageCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionImage", for: indexPath) as? ImageCollectionViewCell
        else { return UICollectionViewCell() }
        
        let uiImage = self.viewModel.getUIImageByIndex(index: indexPath.row)
        collection.setImageView(uiImage: uiImage)
    
        return collection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size : Int = Int.random(in: 50...150)
        return CGSize(width: size, height: size)
    }
    
}
