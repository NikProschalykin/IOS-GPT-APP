//
//  ChatAPI.swift
//  GhatGPT
//
//  Created by Николай Прощалыкин on 14.06.2023.
//

import Foundation

class ChatAPI {
    
    private let systemMessage: Message
    private let temperature: Double
    private let model: String
    
    
    private let apiKey: String
    private let urlSession = URLSession.shared
    private var historyList = [Message]()

     private var urlRequest: URLRequest {
         let url = URL(string: "https://api.openai.com/v1/chat/completions")!
         var urlRequest = URLRequest(url: url)
         urlRequest.httpMethod = "POST"
         headers.forEach {  urlRequest.setValue($1, forHTTPHeaderField: $0) }
         return urlRequest
     }
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private var headers: [String: String] {
            [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
        }
    
    
    init(apiKey: String, model: String = "gpt-3.5-turbo", systemPrompt: String = "You are a helpful assistant", temperature: Double = 0.5){
        self.apiKey = apiKey
        self.model = model
        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.temperature = temperature
    }
    
    private func appendToHistoryList(userText: String, responseText: String) {
        self.historyList.append(.init(role: "user", content: userText))
        self.historyList.append(.init(role: "assistant", content: responseText))
    }
    
    private func generateMessage(from text: String) -> [Message] {
        var messages = [systemMessage] + historyList + [Message(role: "user", content: text)]
        
        if messages.count > (4000 * 4) {
            _ = historyList.dropFirst()
            messages = generateMessage(from: text)
        }
        
        return messages
    }
    
    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = Request(model: model,
                              temperature: temperature,
                              message: generateMessage(from: text),
                              stream: stream)
        return try JSONEncoder().encode(request)
    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error > {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        guard 200...299 ~= httpResponse.statusCode else {
                    var errorText = ""
                    for try await line in result.lines {
                        try Task.checkCancellation()
                        errorText += line
                    }
                    
                    if let data = errorText.data(using: .utf8), let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                        errorText = "\n\(errorResponse.message)"
                    }
                    
                    throw "Bad Response: \(httpResponse.statusCode), \(errorText)"
                }
        
        var responseText = ""
                return AsyncThrowingStream { [weak self] in
                    guard let self else { return nil }
                    for try await line in result.lines {
                        try Task.checkCancellation()
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? self.jsonDecoder.decode(StreamCompletionResponse.self, from: data),
                           let text = response.choices.first?.delta.content {
                            responseText += text
                            return text
                        }
                    }
                    self.appendToHistoryList(userText: text, responseText: responseText)
                    return nil
                }
    }
    
    func sendMessage(_ text: String) async throws -> String {
            var urlRequest = self.urlRequest
            urlRequest.httpBody = try jsonBody(text: text, stream: false)
            
            let (data, response) = try await urlSession.data(for: urlRequest)
            try Task.checkCancellation()
            guard let httpResponse = response as? HTTPURLResponse else {
                throw "Invalid response"
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                var error = "Bad Response: \(httpResponse.statusCode)"
                if let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                    error.append("\n\(errorResponse.message)")
                }
                throw error
            }
            
            do {
                let completionResponse = try self.jsonDecoder.decode(CompletionResponce.self, from: data)
                let responseText = completionResponse.choices.first?.message.content ?? ""
                self.appendToHistoryList(userText: text, responseText: responseText)
                return responseText
            } catch {
                throw error
            }
        }
}

extension String: CustomNSError {
    
    public var errorUserInfo: [String : Any] {
        [
        
            NSLocalizedDescriptionKey: self
            
        ]
    }
    
}


