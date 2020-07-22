//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Mahmoud Nasser on 7/22/20.
//  Copyright © 2020 Mahmoud Nasser. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView!
    var progressView: UIProgressView!
    let webSites = ["apple.com", "hackingwithswift.com", "google.com", "wekipedia.com"]

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.sizeToFit()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open", style: .plain, target: self, action: #selector(openTapped))

        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        
        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward
            , target: webView, action: #selector(webView.goForward))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        let progressBar = UIBarButtonItem(customView: progressView)

        toolbarItems = [back,forward,spacer,progressBar, spacer, refresh]
        navigationController?.isToolbarHidden = false


        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        let url = URL(string: "https://" + webSites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "open web page", message: nil, preferredStyle: .actionSheet)


        for websit in webSites {
            ac.addAction(UIAlertAction(title: websit, style: .default, handler: openWebPage))
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: openWebPage))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openWebPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}

extension ViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        
        
        if let host = url?.host {
            for website in webSites {
                if host.contains(website) {
                    print("allowed")
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
        
    }
}
