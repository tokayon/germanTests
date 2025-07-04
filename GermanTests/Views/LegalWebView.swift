//
//  LegalWebView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/29/25.
//

import SwiftUI
import WebKit

struct LegalWebView: View {
    let title: String
    let urlString: String

    var body: some View {
        WebView(url: URL(string: urlString))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}
