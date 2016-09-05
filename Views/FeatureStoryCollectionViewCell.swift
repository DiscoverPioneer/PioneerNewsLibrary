//
//  FeatureStoryCollectionViewCell.swift
//  News
//
//  Created by Phil Scarfi on 9/3/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

class FeatureStoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var featureTitleView: UILabel!
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var featuredImagesView: UIImageView!
    var images = [UIImage]()
    private var currentImageIndex = -1
    private var timer: NSTimer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func rotateImages() {
        featuredImagesView.image = images.first
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: #selector(FeatureStoryCollectionViewCell.rotate), userInfo: nil, repeats: true)
    }
    
    func rotate() {
        if images.count > 1 {
            currentImageIndex += 1
            let index = currentImageIndex % images.count
            let toImage = images[index]
            UIView.transitionWithView(self.featuredImagesView,
                                      duration:5,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { self.featuredImagesView.image = toImage },
                                      completion: nil)
            
        } else if images.count == 1 {
            featuredImagesView.image = images[0]
        }
    }
}
