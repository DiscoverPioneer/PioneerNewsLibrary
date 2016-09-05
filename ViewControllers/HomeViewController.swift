//
//  HomeViewController.swift
//  News
//
//  Created by Phil Scarfi on 9/5/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var sectionTitles = ["Latest News", "Startups", "Mobile", "Social", "Gadgets"]
    var sectionStories = ["Latest News":[Story](), "Startups":[Story](), "Mobile":[Story](), "Social":[Story](), "Gadgets":[Story]()]
    
    var containerVC: NewsContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let containerVC = self.createNewsContainerViewController()
        containerVC.delegate = self
        containerVC.dataSource = self
        self.containerVC = containerVC
        containerVC.presentInViewController(self, animated: true) {
            self.loadStories()
        }
    }
    
    func loadStories() {
        for name in sectionTitles {
            let section: Section
            switch name {
            case "Latest News":
                section = .All
                break
            case "Startups":
                section = .Startups
                break
            case "Mobile":
                section = .Mobile
                break
            case "Social":
                section = .Social
                break
            case "Gadgets":
                section = .Gadgets
                break
            default:
                section = .All
                break
            }
            APIController().getStoriesForSection(section, completion: { (stories) in
                self.sectionStories[name] = stories
                self.containerVC.reloadData()
                
            })
        }
    }
}

extension HomeViewController: NewsContainerViewControllerDataSource {
    func newsContainerViewControllerShouldLoadStoryHTMLBody(containerViewController: NewsContainerViewController) -> Bool {
            return true
    }
    
    func newsContainerViewControllerSectionTitles(containerViewController: NewsContainerViewController) -> [String] {
        return sectionTitles
    }
    
    func newsContainerViewController(containerViewController: NewsContainerViewController, storiesAtIndex index: Int) -> [Story] {
        
        let sectionTitle = sectionTitles[index]
        let stories = sectionStories[sectionTitle]
        return stories!
    }

}

extension HomeViewController: NewsContainerViewControllerDelegate {
    func newsContainerViewController(newsContainerViewController: NewsContainerViewController, refreshStoriesForSectionIndex index: Int, completion: (updatedStories: [Story]?) -> Void) {
        let name = sectionTitles[index]
        let section: Section
        switch name {
        case "Latest News":
            section = .All
            break
        case "Startups":
            section = .Startups
            break
        case "Mobile":
            section = .Mobile
            break
        case "Social":
            section = .Social
            break
        case "Gadgets":
            section = .Gadgets
            break
        default:
            section = .All
            break
        }
        APIController().getStoriesForSection(section, completion: { (stories) in
            self.sectionStories[name] = stories
            completion(updatedStories: stories)
        })
    }
    
    func newsContainerViewController(newsContainerViewController: NewsContainerViewController, didTapStory story: Story) {
        APIController().getHTMLBodyForStory(story, completion: { (htmlBody) in
            var story = story
            story.htmlBody = htmlBody
            newsContainerViewController.loadStory(story)
        })
    }
}
