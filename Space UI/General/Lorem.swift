//
//  Lorem.swift
//  Space UI
//
//  Created by Jayden Irwin on 2018-03-12.
//  Copyright © 2018 Jayden Irwin. All rights reserved.
//

import GameplayKit

/// A leightweight lorem ipsum generator.
public final class Lorem {
    
    /// Generates a single word.
    public static func word(index: Int) -> String {
        return allWords[(index) % allWords.count]
    }
    
    public static func word(random: GKRandom) -> String {
        let index = random.nextInt(upperBound: allWords.count)
        return allWords[index]
    }
    
    /// Generates multiple words whose count is defined by the given value.
    ///
    /// - Parameter count: The number of words to generate.
    /// - Returns: The generated words joined by a space character.
    public static func words(index: Int, count: Int) -> String {
        return compose({ word(index: index) },
                       count: count)
    }
    
    /// Generates a single sentence.
    public static func sentence(index: Int) -> String {
        let numberOfWords = Int.random(in: minWordsCountInSentence...maxWordsCountInSentence)
        
        return compose({ word(index: index) },
                       count: numberOfWords)
    }
    
}

fileprivate extension Lorem {
    
    enum Separator: String {
        case none = ""
        case space = " "
        case dot = "."
        case newLine = "\n"
    }
    
    static func compose(_ provider: () -> String, count: Int) -> String {
        var string = ""
        
        for index in 0..<count {
            string += provider()
            
            string += " "
        }
        
        return string
    }
    
    static let minWordsCountInSentence = 4
    static let maxWordsCountInSentence = 16
    static let minSentencesCountInParagraph = 3
    static let maxSentencesCountInParagraph = 9
    static let minWordsCountInTitle = 2
    static let maxWordsCountInTitle = 7
    
    static let allWords: [String] = "alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat".components(separatedBy: " ")
    
    static let emailDelimiters = ["", ".", "-", "_"]
    
    static let tweetLength = 140
    
}

fileprivate extension String {
    
    func firstLetterCapitalized() -> String {
        guard !isEmpty else { return self }
        return self[startIndex...startIndex].uppercased() + self[index(after: startIndex)..<endIndex]
    }
    
}
