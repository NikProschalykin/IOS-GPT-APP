//
//  Resorces.swift
//  GhatGPT
//
//  Created by Николай Прощалыкин on 15.06.2023.
//

import UIKit

enum Resorces {
    
    enum Colors {
        static var active = UIColor(hexString: "#437BFE")
        static var inactive = UIColor(hexString: "#929DA5")
        
        static var background = UIColor.systemBackground
        static var backgroundGray = UIColor.systemGray5
        static var settingsBlocksBackground = UIColor.systemGroupedBackground
        static var separator = UIColor.systemGray3
        
        static var titleLabel = UIColor.label
        static var titleSecondaryLabel = UIColor.secondaryLabel
    }
    
    enum Font {
        static func helveticaRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "helvetica", size: size) ?? UIFont()
        }
        static func helveticaBold(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica-Bold", size: size) ?? UIFont()
        }
    }
    
    enum Authors {
        case user
        case assistant
    }
    
    enum Strings {
        
        enum SettinsStrings {
            
            enum SettingsDescriptionsRawStrings {
                static let streamModeBlock = "Show streaming response from ChatGPT.\n(may not work correctly)."
                
                static let apiKeyBlock = "Click on the key field to see or hide it. Set the new key value by pressing the SETUP API Key button. Copy key by copy button."
                
                static let Title = "Application Settings"
            }
            
            enum SettingsDescriptions {
                
                static let streamModeBlock: NSMutableAttributedString = {
                    let text = NSMutableAttributedString(string: Resorces.Strings.SettinsStrings.SettingsDescriptionsRawStrings.streamModeBlock)
                    
                    let rangeNormalText = NSString(string: Resorces.Strings.SettinsStrings.SettingsDescriptionsRawStrings.streamModeBlock).range(of: "Show streaming response from ChatGPT.\n",options: String.CompareOptions.caseInsensitive)
                    
                    let rangeRedText = NSString(string: Resorces.Strings.SettinsStrings.SettingsDescriptionsRawStrings.streamModeBlock).range(of: "(may not work correctly)",options: String.CompareOptions.caseInsensitive)
                    
                    text.addAttributes([.foregroundColor: Resorces.Colors.titleSecondaryLabel,
                                        .font: Resorces.Font.helveticaRegular(with: 14)],
                                       range: rangeNormalText)
                    
                    text.addAttributes([.foregroundColor: UIColor.systemRed,
                                        .font: Resorces.Font.helveticaRegular(with: 14)],
                                       range: rangeRedText)
                
                    return text
                }()
                
                static let apiKeyBlock: NSMutableAttributedString = {
                    let text = NSMutableAttributedString(string: Resorces.Strings.SettinsStrings.SettingsDescriptionsRawStrings.apiKeyBlock)
                    
                    let range = NSString(string: Resorces.Strings.SettinsStrings.SettingsDescriptionsRawStrings.streamModeBlock).range(of: "Show streaming response from ChatGPT.\n",options: String.CompareOptions.caseInsensitive)
                    
                    text.addAttributes([.foregroundColor: Resorces.Colors.titleSecondaryLabel,
                                        .font: Resorces.Font.helveticaRegular(with: 14)],
                                       range: NSRange(location: 0, length: text.length))
            
                    return text
                }()
            }
        }
        enum ChatStrings {
            
            static let startMessage = "Hi, I'm your chatGPT assistant. Let's start chatting! Enter your first message"
            static let textViewPlaceHolder = "Message"
            
        }
    }
}