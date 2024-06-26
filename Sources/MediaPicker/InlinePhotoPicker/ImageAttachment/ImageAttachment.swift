//
//  ImageAttachment.swift
//  InlinePhotosPickerDemo
//
//  Created by Aung Ko Min on 25/6/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI
import PhotosUI

@MainActor public final class ImageAttachment: ObservableObject, Identifiable {
    
    public enum Status {
        case loading
        case finished(UIImage)
        case failed(Error)
        var isFailed: Bool {
            return switch self {
            case .failed: true
            default: false
            }
        }
    }
    
    enum LoadingError: Error {
        case contentTypeNotSupported
    }
    
    private let pickerItem: PhotosPickerItem
    
    @Published var imageStatus: Status?
    @Published var imageDescription: String = ""
    
    nonisolated public var id: String {
        pickerItem.identifier
    }
    
    init(_ pickerItem: PhotosPickerItem) {
        self.pickerItem = pickerItem
    }
    
    func loadImage() async {
        guard imageStatus == nil || imageStatus?.isFailed == true else {
            return
        }
        imageStatus = .loading
        do {
            if let data = try await pickerItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                imageStatus = .finished(uiImage)
            } else {
                throw LoadingError.contentTypeNotSupported
            }
        } catch {
            imageStatus = .failed(error)
        }
    }
}
extension PhotosPickerItem {
    var identifier: String {
        guard let identifier = itemIdentifier else {
            fatalError("The photos picker lacks a photo library.")
        }
        return identifier
    }
}

