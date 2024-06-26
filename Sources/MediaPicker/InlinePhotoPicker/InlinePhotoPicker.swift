/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 The sample app's primary view that configures an inline Photos picker.
 */

import SwiftUI
import PhotosUI

public struct InlinePhotoPicker: View {
    
    @StateObject private var photoPickerViewModel: InlinePhotoPickerViewModel
    
    public init(imageAttachments: Binding<[ImageAttachment]>) {
        _photoPickerViewModel = .init(wrappedValue: .init(imageAttachments: imageAttachments))
    }
    public var body: some View {
        PhotosPicker(
            selection: $photoPickerViewModel.selection,
            selectionBehavior: .continuousAndOrdered,
            matching: .images,
            preferredItemEncoding: .current,
            photoLibrary: .shared()
        ) {
            Color.clear.hidden()
        }
        .photosPickerStyle(.inline)
        .photosPickerDisabledCapabilities([.search, .selectionActions])
        .photosPickerAccessoryVisibility(.hidden, edges: .bottom)
    }
}

@MainActor final class InlinePhotoPickerViewModel: ObservableObject {
    @Published var selection = [PhotosPickerItem]() {
        didSet {
            let newAttachments = selection.map { item in
                attachmentByIdentifier[item.identifier] ?? ImageAttachment(item)
            }
            let newAttachmentByIdentifier = newAttachments.reduce(into: [:]) { partialResult, attachment in
                partialResult[attachment.id] = attachment
            }
            attachments = newAttachments
            attachmentByIdentifier = newAttachmentByIdentifier
        }
    }
    @Binding var attachments: [ImageAttachment]
    private var attachmentByIdentifier = [String: ImageAttachment]()
    
    public init(imageAttachments: Binding<[ImageAttachment]>) {
        self._attachments = imageAttachments
    }
}
