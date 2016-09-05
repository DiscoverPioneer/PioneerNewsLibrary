//
//  FullStoryHeaderView.swift
//  News
//
//  Created by Phil Scarfi on 9/4/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

protocol FullStoryHeaderViewDelegate {
    func fullStoryHeaderView(fullStoryHeaderView: FullStoryHeaderView, backButtonTapped sender: AnyObject)
    func fullStoryHeaderView(fullStoryHeaderView: FullStoryHeaderView, saveButtonTapped sender: AnyObject)

}

class FullStoryHeaderView: UIView {

    var delegate: FullStoryHeaderViewDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!

    class func instanceFromNib() -> FullStoryHeaderView {
        return UINib(nibName: "FullStoryHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! FullStoryHeaderView
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        delegate?.fullStoryHeaderView(self, backButtonTapped: sender)
    }
    @IBAction func saveButtonTapped(sender: AnyObject) {
        delegate?.fullStoryHeaderView(self, saveButtonTapped: sender)
    }
}
