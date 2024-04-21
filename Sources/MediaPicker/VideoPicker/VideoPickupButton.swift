//
//  VideoPickupButton.swift
//  MediaPicker
//
//  Created by Aung Ko Min on 2024/04/22.
//

import SwiftUI
import PhotosUI

public struct VideoPickupButton<Label: View>: View{
    @StateObject private var model = VideoPickerViewModel()
    @Binding private var asset:AVAsset?
    
    let label: (MediaPickerLoadingState<AVAsset>) -> Label
    
    public init(pickedVideo asset: Binding<AVAsset?>, @ViewBuilder label: @escaping (MediaPickerLoadingState<AVAsset>) -> Label) {
        self.label = label
        self._asset = asset
    }
    
    public var body: some View{
        PhotosPicker(selection: $model.selection,matching: .videos,photoLibrary: .shared()) {
            label(model.loadState)
        }
        .onChange(of: model.loadState) { oldValue, newValue in
            switch newValue {
            case .success(let asset):
                self.asset = asset
            default:
                self.asset = nil
            }
        }
    }
}

