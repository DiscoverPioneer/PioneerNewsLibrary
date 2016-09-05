//
//  SectionViewController.swift
//  News
//
//  Created by Phil Scarfi on 9/2/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

protocol SectionViewControllerDelegate {
    func refreshStories(completion:(updatedStories: [Story]?) -> Void)
    func sectionViewController(sectionViewController: SectionViewController, didTapStory story: Story)
}

class SectionViewController: UIViewController {
    var delegate: SectionViewControllerDelegate?
    private var storyContainerViewController: StoryContainerViewController?
    private var stories: [Story]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func addChild() {
        let storyBoard = UIStoryboard(name: "PioneerNewsLibrary", bundle: nil)
        if let vc = storyBoard.instantiateViewControllerWithIdentifier("StoryContainerViewController") as? StoryContainerViewController {
            addChildViewController(vc)
            vc.view.frame = view.frame
            view.addSubview(vc.view)
            vc.didMoveToParentViewController(self)
            self.storyContainerViewController = vc
            storyContainerViewController?.dataSource = self
            storyContainerViewController?.delegate = self
            if let stories = stories {
                storyContainerViewController?.loadStories(stories)
            }
        }
    }
    
    private func removeChild() {
        if let vc = childViewControllers.last {
            vc.willMoveToParentViewController(nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
    }

    func setSectionStories(stories: [Story]) {
        self.stories = stories
        storyContainerViewController?.loadStories(stories)
    }
}

extension SectionViewController: StoryContainerViewControllerDataSource {
    func featureTitleForStoryContainerViewController(storyContainerViewController: StoryContainerViewController) -> String {
        return title ?? ""
    }
    
    func featureSubtitleForStoryContainerViewController(storyContainerViewController: StoryContainerViewController) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.stringFromDate(NSDate())
    }
}

extension SectionViewController: StoryContainerViewControllerDelegate {
    func refreshStories(completion: (updatedStories: [Story]?) -> Void) {
        delegate?.refreshStories(completion)
    }
    
    func didSelectStory(story: Story) {
        delegate?.sectionViewController(self, didTapStory: story)
    }
}
