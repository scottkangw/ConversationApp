//
//  ConversationViewModel.swift
//  ConversationApp
//
//  Created by Scott.L on 21/12/2020.
//

import Foundation

final class ConversationViewModel {
    
    var conversationResults = Bindable([Conversation]())
    var filterChatResults = Bindable([Conversation]())
    var onShowError: ((Error) -> ())?
    
    func filterChat(_ searchText: String,
                    category: Conversation? = nil) {
        filterChatResults.value = conversationResults.value.filter { (chat: Conversation) -> Bool in
            guard let name = chat.name else { return false }
            return name.lowercased().contains(searchText.lowercased())
        }
    }
    
    func bindConversation() {
        if let localData = self.readLocalFile(forName: "conversation") {
            self.parse(jsonData: localData)
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            self.onShowError?(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([Conversation].self, from: jsonData)
            conversationResults.value = decodedData.sorted {
                guard let date = $0.date, let tempDate = $1.date else { return false }
                return date > tempDate
            }
            self.conversationResults.value = removeDuplicateElements(chat: conversationResults.value)
        } catch {
            self.onShowError?("Decode Error" as! Error)
        }
    }
    
    func removeDuplicateElements(chat: [Conversation]) -> [Conversation] {
        var uniqueChat = [Conversation]()
        for conversation in conversationResults.value {
            if !uniqueChat.contains(where: {$0.name == conversation.name }) {
                uniqueChat.append(conversation)
            }
        }
        return uniqueChat
    }
}


