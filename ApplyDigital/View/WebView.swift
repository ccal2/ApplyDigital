//
//  WebView.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 02/12/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let url: URL

    var request: URLRequest {
        URLRequest(url: url)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
