
//
//  Pokemon.swift
//  pokedex-by-devslopes
//
//  Created by Mark Price on 8/14/15.
//  Copyright © 2015 devslopes. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    var nextEvolutionTxt: String {
        
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var description: String {
        
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        print("Configure \(_name)")
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            switch response.result {
            case .Success:
                print("Validation Successful")
                print(self._pokemonUrl)
            case .Failure(let error):
                print(error)
                print(self._pokemonUrl)
            }
            
            let result = response.result

            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                
                if let weight = dict["weight"] as? String {
                    self._weight = "\(weight)"
                    print("SAVE weight!")
                    
                    // Save to NSUserDefaults
                    
                    NSUserDefaults.standardUserDefaults().setValue(weight, forKey: "\(self.pokedexId)_weight")
                    
                }
                
                if let height = dict["height"] as? String {
                    self._height = "\(height)"
                    print("SAVE height!")

                     NSUserDefaults.standardUserDefaults().setValue(height, forKey: "\(self.pokedexId)_height")
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                    print("SAVE attack!")

                    NSUserDefaults.standardUserDefaults().setValue("\(attack)", forKey: "\(self.pokedexId)_attack")
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                    print("SAVE defense!")

                    NSUserDefaults.standardUserDefaults().setValue("\(defense)", forKey: "\(self.pokedexId)_defense")
                }
                
                NSUserDefaults.standardUserDefaults().setValue(self.pokedexId, forKey: "\(self.pokedexId)")
                
                
//                print(self._weight)
//                print(self._height)
//                print(self._attack)
//                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                    NSUserDefaults.standardUserDefaults().setValue(self._type!, forKey: "\(self.pokedexId)_type")
                    
                } else {
                    self._type = ""
                }
                
//                print(self._type)
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Can't support mega pokemon right now but
                        //api still has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                NSUserDefaults.standardUserDefaults().setValue(self._nextEvolutionId, forKey: "\(self.pokedexId)_evolutionId")
                                NSUserDefaults.standardUserDefaults().setValue(self._nextEvolutionTxt, forKey: "\(self.pokedexId)_evolutionText")
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                    NSUserDefaults.standardUserDefaults().setValue(self._nextEvolutionLvl, forKey: "\(self.pokedexId)_evolutionLvl")
                                }
                                
//                                print(self._nextEvolutionId)
//                                print(self._nextEvolutionTxt)
//                                print(self._nextEvolutionLvl)
                                
                            }
                        }
                        
                    }
                    
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                    print("************** DESC ************")
                                    
                                    NSUserDefaults.standardUserDefaults().setValue(description, forKey: "\(self.pokedexId)_description")
                                }
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                    completed()
                }

            }
            
        }
    }
}






