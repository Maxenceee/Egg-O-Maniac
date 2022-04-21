//
//  EmailManager.swift
//  Egg-O-Maniac
//
//  Created by Maxence Gama on 30/11/2020.
//

import Foundation
import SendGrid

struct EmailManager {
    
    func send(form: FeedbackForm, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let userName = "EOM-Bot"
        let developerEmail = "maxence.gama@gmail.com"
        let senderAddress = "eom.bot@gmail.com"
        
        let personalization = Personalization(recipients: developerEmail)
        let subject = "Feedback Received from Egg-O-Maniac"
        let htmlContext = """
        <h4>User :</h4>
        <p>\(userName)</p>
        <h4>Object :</h4>
        <p>\(form.comments)</p>
        <h4>Subject :</h4>
        <p>\(form.category)</p>
        
        """

        let htmlText = Content(contentType: .htmlText, value: htmlContext)
        
        let from = Address(email: senderAddress)
        
        let email = Email(personalizations: [personalization], from: from, content: [htmlText], subject: subject)
        print(email)
        
        do {
            try session.send(request: email, completionHandler: { (result) in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        } catch(let error) {
            completion(.failure(error))
        }
    }
    
    
    private var session: Session {
        let apiKey = "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"
        
        let session = Session()
        session.authentication = Authentication.apiKey(apiKey)
        return session
    }
    
    
}
