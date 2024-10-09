//
//  CaptureOverlayView.swift
//  WayGate
//
//  Created by Nabeel Nazir on 07/10/2024.
//

import Foundation
import RealityKit
import SwiftUI
import UniformTypeIdentifiers

struct CaptureOverlayView: View {
    @EnvironmentObject var appModel: AppDataModel
    var session: ObjectCaptureSession

    @Binding var showInfo: Bool

    @State private var hasDetectionFailed = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                CancelButton()
                    .opacity(!shouldShowTutorial ? 1 : 0)
                    .disabled(shouldDisableCancelButton ? true : false)
                Spacer()
                NextButton()
                    .opacity(shouldShowNextButton ? 1 : 0)
                    .disabled(!shouldShowNextButton)
            }
            .foregroundColor(.white)

            Spacer()

            if shouldShowTutorial, let url = Bundle.main.url(
                forResource: appModel.orbit.feedbackVideoName(
                    for: UIDevice.current.userInterfaceIdiom,
                    isObjectFlippable: appModel.isObjectFlippable),
                withExtension: "mp4") {
                TutorialVideoView(url: url, isInReviewSheet: false)
                    .frame(maxHeight: horizontalSizeClass == .regular ? 350 : 280)

                Spacer()
            } else if !capturingStarted {
                BoundingBoxGuidanceView(session: session, hasDetectionFailed: hasDetectionFailed)
            }

            HStack(alignment: .bottom, spacing: 0) {
                HStack(spacing: 0) {
                    if case .capturing = session.state {
                        NumOfImagesButton(session: session)
                            .rotationEffect(rotationAngle)
                            .transition(.opacity)
                    } else if case .detecting = session.state {
                        ResetBoundingBoxButton(session: session)
                            .transition(.opacity)
                    } else if case .ready = session.state {
                        FilesButton()
                            .transition(.opacity)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)

                if !capturingStarted {
                    CaptureButton(session: session, isObjectFlipped: appModel.isObjectFlipped, hasDetectionFailed: $hasDetectionFailed)
                        .layoutPriority(1)
                }

                HStack {
                    Spacer()

                    if !capturingStarted {
                        HelpButton(showInfo: $showInfo)
                            .transition(.opacity)
                    } else if case .capturing = session.state {
                        ManualShotButton(session: session)
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .opacity(shouldShowTutorial ? 0 : 1) // Keeps tutorial view centered.
        }
        .padding()
        .padding(.horizontal, 15)
        .background(shouldShowTutorial ? Color.black.opacity(0.5) : .clear)
        .allowsHitTesting(!shouldShowTutorial)
        .animation(.default, value: shouldShowTutorial)
        .background {
            if !shouldShowTutorial && appModel.messageList.activeMessage != nil {
                VStack {
                    Rectangle()
                        .frame(height: 130)
                        .hidden()

                    FeedbackView(messageList: appModel.messageList)
                        .layoutPriority(1)
                }
                .rotationEffect(rotationAngle)
            }
        }
        .task {
            for await _ in NotificationCenter.default.notifications(named:
                    UIDevice.orientationDidChangeNotification).map({ $0.name }) {
                withAnimation {
                    deviceOrientation = UIDevice.current.orientation
                }
            }
        }
    }

    private var capturingStarted: Bool {
        switch session.state {
            case .initializing, .ready, .detecting:
                return false
            default:
                return true
        }
    }

    private var shouldShowTutorial: Bool {
        if appModel.orbitState == .initial,
           case .capturing = session.state,
           appModel.orbit == .orbit1 {
            return true
        }
        return false
    }

    private var shouldShowNextButton: Bool {
        capturingStarted && !shouldShowTutorial
    }

    private var shouldDisableCancelButton: Bool {
        shouldShowTutorial || session.state == .ready || session.state == .initializing
    }

    private var rotationAngle: Angle {
        switch deviceOrientation {
            case .landscapeLeft:
                return Angle(degrees: 90)
            case .landscapeRight:
                return Angle(degrees: -90)
            case .portraitUpsideDown:
                return Angle(degrees: 180)
            default:
                return Angle(degrees: 0)
        }
    }
}

@available(iOS 17.0, *)
@MainActor
private struct BoundingBoxGuidanceView: View {
    var session: ObjectCaptureSession
    var hasDetectionFailed: Bool

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        HStack {
            if let guidanceText = guidanceText {
                Text(guidanceText)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.white)
                    .transition(.opacity)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 400 : 360)
            }
        }
    }

    private var guidanceText: String? {
        if case .ready = session.state {
            if hasDetectionFailed {
                return NSLocalizedString(
                    "Can‘t find your object. It should be larger than 3in (8cm) in each dimension.",
                    bundle: AppDataModel.bundleForLocalizedStrings,
                    value: "Can‘t find your object. It should be larger than 3in (8cm) in each dimension.",
                    comment: "Feedback message when detection has failed.")
            } else {
                return NSLocalizedString(
                    "Move close and center the dot on your object, then tap Continue. (Object Capture, State)",
                    bundle: AppDataModel.bundleForLocalizedStrings,
                    value: "Move close and center the dot on your object, then tap Continue.",
                    comment: "Feedback message to fill camera feed with object.")
            }
        } else if case .detecting = session.state {
            return NSLocalizedString(
                "Move around to ensure that the whole object is inside the box. Drag handles to manually resize. (Object Capture, State)",
                bundle: AppDataModel.bundleForLocalizedStrings,
                value: "Move around to ensure that the whole object is inside the box. Drag handles to manually resize.",
                comment: "Feedback message to size box to object.")
        } else {
            return nil
        }
    }
}

extension CaptureOverlayView {
    @MainActor
    struct CaptureButton: View {
        var session: ObjectCaptureSession
        var isObjectFlipped: Bool
        @Binding var hasDetectionFailed: Bool

        var body: some View {
            Button(
                action: {
                    performAction()
                },
                label: {
                    Text(buttonlabel)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 20)
                        .background(.blue)
                        .clipShape(Capsule())
                })
        }

        private var buttonlabel: String {
            if case .ready = session.state {
                return LocalizedString.continue
            } else {
                if !isObjectFlipped {
                    return LocalizedString.startCapture
                } else {
                    return LocalizedString.continue
                }
            }
        }

        private func performAction() {
            if case .ready = session.state {
                hasDetectionFailed = !(session.startDetecting())
            } else if case .detecting = session.state {
                session.startCapturing()
            }
        }
    }

    @available(iOS 17.0, *)
    struct ResetBoundingBoxButton: View {
        var session: ObjectCaptureSession

        var body: some View {
            Button(
                action: { session.resetDetection() },
                label: {
                    VStack(spacing: 6) {
                        Image("ResetBbox")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)

                        Text(LocalizedString.resetBox)
                            .font(.footnote)
                            .opacity(0.7)
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                })
        }
    }

    @available(iOS 17.0, *)
    struct NextButton: View {
        @EnvironmentObject var appModel: AppDataModel

        var body: some View {
            Button(action: {
                appModel.setPreviewModelState(shown: true)
            },
                   label: {
                Text(LocalizedString.next)
                    .modifier(VisualEffectRoundedCorner())
            })
        }
    }

    @available(iOS 17.0, *)
    struct ManualShotButton: View {
        var session: ObjectCaptureSession

        var body: some View {
            Button(
                action: {
                    session.requestImageCapture()
                },
                label: {
                    if session.canRequestImageCapture {
                        Text(Image(systemName: "button.programmable"))
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    } else {
                        Text(Image(systemName: "button.programmable"))
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }
            )
            .disabled(!session.canRequestImageCapture)
        }
    }

    struct DocumentBrowser: UIViewControllerRepresentable {
        let startingDir: URL

        func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentBrowser>) -> UIDocumentPickerViewController {
            let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
            controller.directoryURL = startingDir
            return controller
        }

        func updateUIViewController(
            _ uiViewController: UIDocumentPickerViewController,
            context: UIViewControllerRepresentableContext<DocumentBrowser>) {}
    }

    @available(iOS 17.0, *)
    struct FilesButton: View {
        @EnvironmentObject var appModel: AppDataModel
        @State private var showDocumentBrowser = false

        var body: some View {
            Button(
                action: {
                    showDocumentBrowser = true
                },
                label: {
                    Image(systemName: "folder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(.white)
                })
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
            .sheet(isPresented: $showDocumentBrowser,
                   onDismiss: { showDocumentBrowser = false },
                   content: { DocumentBrowser(startingDir: appModel.scanFolderManager.rootScanFolder) })
        }
    }

    struct HelpButton: View {
        @Binding var showInfo: Bool

        var body: some View {
            Button(action: {
                withAnimation {
                    showInfo = true
                }
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)

                    Text(LocalizedString.help)
                        .font(.footnote)
                        .opacity(0.7)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
            })
        }
    }

    @available(iOS 17.0, *)
    struct CancelButton: View {
        @EnvironmentObject var appModel: AppDataModel

        var body: some View {
            Button(action: {
                appModel.objectCaptureSession?.cancel()
            }, label: {
                Text(LocalizedString.cancel)
                    .modifier(VisualEffectRoundedCorner())
            })
        }
    }

    @available(iOS 17.0, *)
    struct NumOfImagesButton: View {
        var session: ObjectCaptureSession

        var body: some View {
            VStack(spacing: 8) {
                Text(Image(systemName: "photo"))

                Text(String(format: LocalizedString.numOfImages,
                            session.numberOfShotsTaken,
                            session.maximumNumberOfInputImages))
                .font(.footnote)
                .fontWidth(.condensed)
                .fontDesign(.rounded)
                .bold()
            }
            .foregroundColor(session.feedback.contains(.overCapturing) ? .red : .white)
        }
    }

    struct VisualEffectRoundedCorner: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(16.0)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .cornerRadius(15)
                .multilineTextAlignment(.center)
        }
    }

    struct VisualEffectView: UIViewRepresentable {
        var effect: UIVisualEffect?
        func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
        func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
    }
}

extension CaptureOverlayView {
    struct LocalizedString {
        static let startCapture = NSLocalizedString(
            "Start Capture (Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "Start Capture",
            comment: "Title for start capture button on the object capture screen.")

        static let resetBox = NSLocalizedString(
            "Reset Box (Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "Reset Box",
            comment: "Title for resetting bounding box on the object capture screen.")

        static let `continue` = NSLocalizedString(
            "Continue (Object Capture, Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "Continue",
            comment: "Title for continue button on the object capture screen.")

        static let next = NSLocalizedString(
            "Next (Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "Next",
            comment: "Title for next button on the object capture screen.")

        static let cancel = NSLocalizedString(
            "Cancel (Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "Cancel",
            comment: "Title for cancel button on the object capture screen.")

        static let numOfImages = NSLocalizedString(
            "%d/%d (Format, # of Images)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "%d/%d",
            comment: "Images taken over maximum number of images.")

        static let help = NSLocalizedString(
            "Help (Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "Help",
            comment: "Title for help button on the object capture screen to show the tutorial pages.")
    }
}
