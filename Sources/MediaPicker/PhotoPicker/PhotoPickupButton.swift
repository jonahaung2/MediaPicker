//
//  PhotoPickupButton.swift
//  MediaPicker
//
//  Created by Aung Ko Min on 2024/04/22.
//

import SwiftUI
import PhotosUI

public struct PhotoPickupButton<Label: View>: View{
    
    @StateObject private var model = PhotoPickerViewModel()
    @Binding private var image:UIImage?
    private let label: (MediaPickerLoadingState<UIImage>) -> Label
    
    public init(pickedImage image: Binding<UIImage?>, @ViewBuilder label: @escaping (MediaPickerLoadingState<UIImage>) -> Label) {
        self.label = label
        self._image = image
    }
    
    public var body: some View{
        PhotosPicker(selection: $model.selection,matching: .images,photoLibrary: .shared()) {
            label(model.loadState)
        }.onChange(of: model.loadState) { oldValue, newValue in
            switch newValue {
            case .success(let image):
                self.image = image
            default:
                self.image = nil
            }
        }
    }
}
