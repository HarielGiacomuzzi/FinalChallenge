//
//  XMLParser.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/18/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class XMLParser: NSObject, NSXMLParserDelegate {
    
    private var currentElement : String?
    private var currentNode : String?
    private var isOnNode = false;
    
    func loadBoardFrom(fileName : String){
        var url = NSURL(fileURLWithPath: fileName)
        var parser = NSXMLParser(contentsOfURL: url);
        parser?.delegate = self;
        parser?.parse();
        BoardGraph.SharedInstance.setNeighborsReference();
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "HOUSE"{
            isOnNode = true;
            currentNode = "House"
            BoardGraph.SharedInstance.createNode((attributeDict["x"] as! NSString).doubleValue, y: (attributeDict["y"] as! NSString).doubleValue, name: "House", father: nil);
        }
        if elementName == "STORE"{
            isOnNode = true;
            currentNode = "Store"
            BoardGraph.SharedInstance.createNode((attributeDict["x"] as! NSString).doubleValue, y: (attributeDict["y"] as! NSString).doubleValue, name: "Store", father: nil);
            BoardGraph.SharedInstance.setFather(attributeDict["father"] as String!, sonName: "Store");
        }
        if elementName == "BAU"{
            isOnNode = true;
            var number = (attributeDict["number"] as? NSString)?.integerValue;
            currentNode = "Bau\(number!)"
            BoardGraph.SharedInstance.createNode((attributeDict["x"] as! NSString).doubleValue, y: (attributeDict["y"] as! NSString).doubleValue, name: "Bau\(number!)", father: nil);
            BoardGraph.SharedInstance.setFather(attributeDict["father"] as String!, sonName: "Bau\(number!)");
        }
        if elementName == "node"{
            isOnNode = true;
            currentElement = elementName;
            currentNode = attributeDict["name"] as String!;
            BoardGraph.SharedInstance.createNode((attributeDict["x"] as NSString!).doubleValue, y: (attributeDict["y"] as NSString!).doubleValue, name: attributeDict["name"] as String!, father: nil);
            BoardGraph.SharedInstance.setFather(attributeDict["father"] as String!, sonName: "Store");
        }
        if elementName == "next" && isOnNode {
            BoardGraph.SharedInstance.setNeighbors(currentNode!, nextNode: attributeDict["name"] as String!)
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "node"{
            isOnNode = false;
        }
    }
    
}