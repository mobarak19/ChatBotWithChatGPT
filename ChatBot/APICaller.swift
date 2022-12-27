//
//  APICaller.swift
//  ChatBot
//
//  Created by Genusys Inc on 12/13/22.
//
import OpenAISwift
import Foundation


final class APICaller{
    static let shared = APICaller()
    
    private var client : OpenAISwift?
    
    @frozen enum Constants{
        static let key = "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"
    }
    private init(){}
    
    public func setUp(){
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getResponse(input:String,completion:@escaping(Result<String,Error>)->Void){
        self.client?.sendCompletion(with: input,model: .gpt3(.babbage), completionHandler: { result in
            switch result{
            case .success(let model):
                print(String(describing: model.choices))
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

}


