//
//  MediaPickerLoadingState.swift
//  MediaPicker
//
//  Created by Aung Ko Min on 2024/04/22.
//

import Foundation

public enum MediaPickerLoadingState<Content>: Equatable {
    
    case empty
    case loading(Progress)
    case success(Content)
    case failure(Error)
    
    static public func == (lhs: MediaPickerLoadingState, rhs: MediaPickerLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.loading(_), .loading(_)):
            return true
        case (.success(_), .success(_)):
            return true
        case (.failure(_), .failure(_)):
            return true
        default:
            return false
        }
    }
}
