//
//  IntroViewController.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 14/02/2021.
//

import UIKit

class IntroViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private let pageControl: UIPageControl = {
        let pagecontrol = UIPageControl()
        pagecontrol.numberOfPages = 4
        pagecontrol.currentPageIndicatorTintColor = .systemGray
        pagecontrol.pageIndicatorTintColor = .systemGray5
        return pagecontrol
    }()
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Not "
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 0, y: UIScreen.main.bounds.height < 750 ? (view.frame.size.height-50) : (view.frame.size.height-70), width: view.frame.width, height: 70)
        
        scrollView.frame  = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        if scrollView.subviews.count == 2 {
            configureScrollView()
        }
    }
    
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.size.height*CGFloat(pageControl.numberOfPages-2), height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        let colors: [UIColor] = [
            .systemRed,
            .systemBlue,
            .systemTeal,
            .systemGreen,
            .systemPink,
            .systemGray]
        for x in 0..<pageControl.numberOfPages {
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width,
                                            y: 0,
                                            width: view.frame.size.width,
                                            height: scrollView.frame.size.height))
            
            switch x {
            case 0:
                testLabel.text = "First"
            case 1:
                testLabel.text = "Second"
            case 2:
                testLabel.text = "Third"
            case 3:
                testLabel.text = "Fourth"
            default:
                break
            }
            
            page.addSubview(testLabel)
            testLabel.centerXAnchor.constraint(equalTo: page.centerXAnchor).isActive = true
            testLabel.centerYAnchor.constraint(equalTo: page.centerYAnchor).isActive = true
            testLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            testLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            page.backgroundColor = colors[x]
            scrollView.addSubview(page)
        }
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
}
extension IntroViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage  = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        print(pageControl.currentPage)
    }
}
