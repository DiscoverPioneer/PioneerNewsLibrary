//
//  FullStoryViewController.swift
//  News
//
//  Created by Phil Scarfi on 9/4/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import UIKit
import Kingfisher

class FullStoryViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: FullStoryHeaderView!
    
    var story: Story!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if story != nil {
            loadStory()
        }
    }

    func loadStory() {
        createView()
        headerView.imageView.kf_setImageWithURL(story.imageURL)
        headerView.titleView.text = story.title
    }

    func createView() {
        let headerView = FullStoryHeaderView.instanceFromNib()
        headerView.frame = CGRectMake(0, 0, view.frame.width, 280)
        headerView.delegate = self
        let label = UILabel()
        if let html = story.htmlBody {
            
            
            label.numberOfLines = 0
            do {

             
                let str = try NSMutableAttributedString(data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                label.attributedText = str
                
                let maxHeight : CGFloat = 10000
                let rect = label.attributedText?.boundingRectWithSize(CGSizeMake(view.frame.width, maxHeight), options: .UsesLineFragmentOrigin, context: nil)
                var frame = label.frame
                frame.size.height = rect!.size.height
                label.frame = frame
            } catch {
                print(error)
            }
        }
        let totalHeight = headerView.frame.height + label.frame.height
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.contentSize = CGSizeMake(view.frame.width, totalHeight)
        scrollView.addSubview(headerView)
        label.frame.origin = CGPointMake(0,headerView.frame.maxY)
        label.frame.size.width = headerView.frame.width
        scrollView.addSubview(label)
        view.addSubview(scrollView)
        self.scrollView = scrollView
        self.headerView = headerView
    }
}

extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.stringByReplacingOccurrencesOfString("(?i)</?\(tag)\\b[^<]*>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag)
        }
        return mutableString
    }
}

extension FullStoryViewController: FullStoryHeaderViewDelegate {
    func fullStoryHeaderView(fullStoryHeaderView: FullStoryHeaderView, backButtonTapped sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    func fullStoryHeaderView(fullStoryHeaderView: FullStoryHeaderView, saveButtonTapped sender: AnyObject) {
        let objectsToShare = [story.link]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
}
