//
//  PageModel.swift
//  tickethamsterV3
//
//  Created by Eduardo Jimenez on 21/10/24.
//

import Foundation
import SwiftUI
import UIKit
import CryptoKit

extension String {
    /// Converts literal \n sequences stored in Firestore into real line breaks for SwiftUI.
    var firebaseLineBreaks: String {
        replacingOccurrences(of: "\\n", with: "\n")
    }
}



// MARK: - Persistent remote image cache

private final class HamsterImageMemoryCache {
    static let shared = NSCache<NSString, UIImage>()
}

private enum HamsterImageDiskCache {
    static let directory: URL = {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let directory = base.appendingPathComponent("HamsterRemoteImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }()

    static func fileURL(for remoteURL: URL) -> URL {
        let digest = SHA256.hash(data: Data(remoteURL.absoluteString.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
        return directory.appendingPathComponent(digest)
    }

    static func image(for remoteURL: URL) -> UIImage? {
        let key = remoteURL.absoluteString as NSString

        if let image = HamsterImageMemoryCache.shared.object(forKey: key) {
            return image
        }

        let fileURL = fileURL(for: remoteURL)
        guard
            let data = try? Data(contentsOf: fileURL),
            let image = UIImage(data: data)
        else {
            return nil
        }

        HamsterImageMemoryCache.shared.setObject(image, forKey: key)
        return image
    }

    static func store(_ data: Data, image: UIImage, for remoteURL: URL) {
        HamsterImageMemoryCache.shared.setObject(image, forKey: remoteURL.absoluteString as NSString)
        try? data.write(to: fileURL(for: remoteURL), options: .atomic)
    }
}

private final class HamsterRemoteImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var didFail = false

    private var task: URLSessionDataTask?
    private var currentURL: URL?

    func load(urlString: String) {
        task?.cancel()
        didFail = false

        let cleanURLString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        // EventViewModel can publish an empty value first and the real URL a moment later.
        // Do not turn that transient empty state into a permanent fallback.
        guard !cleanURLString.isEmpty else {
            currentURL = nil
            return
        }

        guard let url = URL(string: cleanURLString) else {
            currentURL = nil
            didFail = true
            return
        }

        currentURL = url

        if let cached = HamsterImageDiskCache.image(for: url) {
            image = cached
        }

        // Always try the network too. If it succeeds, the disk cache is refreshed.
        // If offline, the already-published cached image remains visible.
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadRevalidatingCacheData
        request.timeoutInterval = 15

        task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self else { return }
            guard self.currentURL == url else { return }

            guard
                error == nil,
                let data,
                let downloadedImage = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    if self.image == nil {
                        self.didFail = true
                    }
                }
                return
            }

            HamsterImageDiskCache.store(data, image: downloadedImage, for: url)

            DispatchQueue.main.async {
                self.image = downloadedImage
                self.didFail = false
            }
        }
        task?.resume()
    }

    deinit {
        task?.cancel()
    }
}

/// Remote image that persists the last successfully downloaded file on disk.
/// When offline it immediately reuses that file; when online it refreshes it.
struct OfflineCachedImage: View {
    let urlString: String
    let fallbackAsset: String
    var contentMode: ContentMode = .fill
    var stretchToFill: Bool = false

    @StateObject private var loader = HamsterRemoteImageLoader()

    @ViewBuilder
    private func renderedImage(_ image: Image) -> some View {
        if stretchToFill {
            image
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }

    var body: some View {
        Group {
            if let uiImage = loader.image {
                renderedImage(Image(uiImage: uiImage))
            } else if loader.didFail {
                renderedImage(Image(fallbackAsset))
            } else {
                ZStack {
                    Color.clear
                    ProgressView()
                }
            }
        }
        .task(id: urlString) {
            loader.load(urlString: urlString)
        }
    }
}

struct Page: Identifiable, Equatable {
    
    let id = UUID()
    
    // MARK: - Campos del ticket (UI existente)
    var tx1: String   // Type
    var tx2: String   // Header "SEC ROW SEAT"
    var tx3: String   // Sec
    var tx4: String   // Row
    var tx5: String   // Seat
    var tx6: String   // Name
    var tx7: String   // Date
    var tx8: String   // fijo "Mobile Entry"
    var tx9: String   // fijo "View in Wallet"
    
    // MARK: - Imágenes / URLs
    var imageUrl: String     // Firestore: imageUrl
    var barcodeUrl: String   // Firestore: Barcode (URL de imagen)
    var safeUrl: String      // Firestore: SafeIMG (URL de imagen)
    
    // MARK: - CodeView
    var acceso: String       // Firestore: Acceso
    
    // MARK: - Details (campos nuevos)
    var seatDetail: String       // Firestore: SeatDetail
    var barcodeNumber: String    // Firestore: BarcodeNumber
    var place: String            // Firestore: Place
    var city: String             // Firestore: City
    var purchase: String         // Firestore: Purchase
    var price: String            // Firestore: Price
    
    // MARK: - TabView
    var tag: Int
    
    // MARK: - Init desde Firebase
    init(type: String,
         sec: String,
         row: String,
         seat: String,
         name: String,
         date: String,
         imageUrl: String,
         barcodeUrl: String,
         safeUrl: String,
         acceso: String,
         seatDetail: String,
         barcodeNumber: String,
         place: String,
         city: String,
         purchase: String,
         price: String,
         tag: Int,
         headerText: String = "SEC     ROW     SEAT") {
        
        self.tx1 = type
        self.tx2 = headerText
        self.tx3 = sec
        self.tx4 = row
        self.tx5 = seat
        self.tx6 = name
        self.tx7 = date
        self.tx8 = "Mobile Entry"
        self.tx9 = "View in Wallet"
        
        self.imageUrl = imageUrl
        self.barcodeUrl = barcodeUrl
        self.safeUrl = safeUrl
        
        self.acceso = acceso
        
        self.seatDetail = seatDetail
        self.barcodeNumber = barcodeNumber
        self.place = place
        self.city = city
        self.purchase = purchase
        self.price = price
        
        self.tag = tag
    }
    
    // MARK: - Sample (para previews)
    static var samplePage = Page(
        type: "Boleto Normal",
        sec: "GNP-09",
        row: "32",
        seat: "8",
        name: "BAD BUNNY - DeBÍ TiRAR MáS FOToS WORLD TOUR",
        date: "Wed 10 Dic 2025 • 9:00 PM",
        imageUrl: "https://example.com/ticket.png",
        barcodeUrl: "https://example.com/barcode.png",
        safeUrl: "https://example.com/safe.png",
        acceso: "ACCESO B",
        seatDetail: "GNP-09 / 32 / 8",
        barcodeNumber: "323322837072082138c",
        place: "Estadio GNP Seguros",
        city: "Ciudad de México DF MX",
        purchase: "Mon, May 5 2025",
        price: "$4741.00",
        tag: 0
    )
    
    static var samplePages: [Page] = [
        samplePage
    ]
}
