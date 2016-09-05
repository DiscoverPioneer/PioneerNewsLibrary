//
//  StoryContainerViewController.swift
//  News
//
//  Created by Phil Scarfi on 9/3/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import UIKit
import TabPageViewController
import Kingfisher

protocol StoryContainerViewControllerDelegate {
    func refreshStories(completion:(updatedStories: [Story]?) -> Void)
    func didSelectStory(story: Story)
}

protocol StoryContainerViewControllerDataSource  {
    func featureTitleForStoryContainerViewController(storyContainerViewController: StoryContainerViewController) -> String
    func featureSubtitleForStoryContainerViewController(storyContainerViewController: StoryContainerViewController) -> String
}

class StoryContainerViewController: UIViewController {

    var delegate:StoryContainerViewControllerDelegate?
    var dataSource: StoryContainerViewControllerDataSource?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let reuseIdentifier = "cell"
    private let featureReuseIdentifier = "featurecell"

    private var stories = [Story]()
    private let refreshCtrl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "FeatureStoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: featureReuseIdentifier)

        collectionView.registerNib(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        let navigationHeight = topLayoutGuide.length ?? 0.0
        collectionView.contentInset.top = navigationHeight + TabPageOption().tabHeight
        
        refreshCtrl.addTarget(self, action: #selector(StoryContainerViewController.startRefresh), forControlEvents: .ValueChanged)
        collectionView?.addSubview(refreshCtrl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func loadStories(stories: [Story]) {
        self.stories = stories
        collectionView.reloadData()
    }
    
    func startRefresh() {
        delegate?.refreshStories({ (updatedStories) in
            self.refreshCtrl.endRefreshing()
            if let updatedStories = updatedStories {
                self.loadStories(updatedStories)
            }
        })
    }
    
}

extension StoryContainerViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(featureReuseIdentifier, forIndexPath: indexPath) as! FeatureStoryCollectionViewCell
            cell.featureTitleView.text = dataSource?.featureTitleForStoryContainerViewController(self)
            cell.subtitleView.text = dataSource?.featureSubtitleForStoryContainerViewController(self)

            var images = [UIImage]()
            var numberOfImages = 5
            for story in stories {
                if story.imageURL != stories.first?.imageURL {
                    KingfisherManager.sharedManager.retrieveImageWithURL(story.imageURL, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                        if let image = image {
                            images.append(image)
                            cell.images = images
                            cell.rotateImages()
                        }
                    })
                    numberOfImages -= 1
                    if numberOfImages < 0 {
                        break
                    }
                } else {
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StoryCollectionViewCell
            let story = stories[indexPath.item - 1]
            cell.storyImageView.kf_showIndicatorWhenLoading = true
            cell.storyImageView.kf_setImageWithURL(story.imageURL, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            cell.storyTitleView.text = story.title        
            return cell
        }
    }
}

extension StoryContainerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSizeMake(collectionView.frame.width, 350)
        }
        return CGSizeMake(collectionView.frame.width, 250)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

extension StoryContainerViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if indexPath.item > 0 {
            let story = stories[indexPath.item - 1]
            delegate?.didSelectStory(story)
        }
     
    }
}
