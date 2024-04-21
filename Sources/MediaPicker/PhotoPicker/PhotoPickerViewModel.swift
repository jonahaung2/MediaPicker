//
//  PhotoPickerViewModel.swift
//  MediaPicker
//
//  Created by Aung Ko Min on 2024/04/22.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI
import PhotosUI

class PhotoPickerViewModel: ObservableObject{
    private struct ImageData: Transferable {
        let image: UIImage
        static var transferRepresentation: some  TransferRepresentation{
            DataRepresentation(importedContentType: .image){ data in
                guard let uiImage = UIImage(data: data) else{
                    throw MideaPickerTransferError.importFailed
                }
                return ImageData(image: uiImage)
            }
        }
    }
    
    @Published private(set) var loadState: MediaPickerLoadingState<UIImage> = .empty
    
    @Published var selection: PhotosPickerItem? = nil {
        didSet {
            if let selection {
                let progress = loadTransferable(from: selection)
                loadState = .loading(progress)
            } else {
                loadState = .empty
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ImageData.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.selection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profile?):
                    self.loadState = .success(profile.image)
                case .failure(let error):
                    self.loadState = .failure(error)
                default:
                    self.loadState = .empty
                }
            }
        }
    }
}
