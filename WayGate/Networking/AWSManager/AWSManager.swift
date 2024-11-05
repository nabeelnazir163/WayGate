//
//  AWSManager.swift
//  WayGate
//
//  Created by Nabeel Nazir on 04/11/2024.
//

import AWSS3
import AWSCore

final class AWSManager {
    static let shared = AWSManager()
    
    private init() { }
    
    typealias progressBlock = (_ progress: Double) -> Void
    typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void
    
    func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
            // Upload progress block
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, awsProgress) in
                guard let uploadProgress = progress else { return }
                DispatchQueue.main.async {
                    uploadProgress(awsProgress.fractionCompleted)
                    print("progress.fractionCompleted: \(awsProgress.fractionCompleted)")
                    if awsProgress.isFinished{
                        print("Upload Finished...")
                        //do any task here.
                    }
                }
            }

            // Completion block
            var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
            completionHandler = { (task, error) -> Void in
                DispatchQueue.main.async(execute: {
                    if error == nil {
                        let url = AWSS3.default().configuration.endpoint.url
                        let publicURL = url?.appendingPathComponent(AWSConstants.AWS_S3_BUCKET_NAME).appendingPathComponent(fileName)
                        print("File Uploaded SUCCESSFULLY to:\(String(describing: publicURL))")
                        if let completionBlock = completion {
                            completionBlock(publicURL?.absoluteString, nil)
                        }
                    } else {
                        if let completionBlock = completion {
                            completionBlock(nil, error)
                        }
                        print("File Uploading FAILED with error: \(String(describing: error?.localizedDescription))")
                    }
                })
            }
            // Start uploading using AWSS3TransferUtility
            let awsTransferUtility = AWSS3TransferUtility.default()
            awsTransferUtility.uploadFile(fileUrl, bucket: AWSConstants.AWS_S3_BUCKET_NAME, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                if let error = task.error {
                    print("Error uploading file: \(error.localizedDescription)\n error: \(error)")
                }
                if let _ = task.result {
                    print("Starting upload...")
                }
                return nil
            }
        }
}
