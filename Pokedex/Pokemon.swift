
//
//  Pokemon.swift
//  Pokedex
//
//  Created by Adam Thuvesen on 2016-08-07.
//  Copyright © 2016 Adam Thuvesen. All rights reserved.
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
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    private var _speed: String!
    private var _exp: String!
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
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
    
    var speed: String {
        if _speed == nil {
            _speed = ""
        }
        
        return _speed
    }
    
    var exp: String {
        if _exp == nil {
            _exp = ""
        }
        return _exp
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
                    let weightInKilogram = Double(weight)! * 0.454
                    let weightRounded = Double(round(10*weightInKilogram)/10)
                    self._weight = "\(weightRounded)"
                    NSUserDefaults.standardUserDefaults().setValue("\(weightRounded)", forKey: "\(self.pokedexId)_weight")
                }
                
                if let height = dict["height"] as? String {
                    let heightInMeters = Double(height)! * 0.305
                    let heightRounded = Double(round(10*heightInMeters)/10)
                    self._height = "\(heightRounded)"
                    NSUserDefaults.standardUserDefaults().setValue("\(heightRounded)", forKey: "\(self.pokedexId)_height")
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                    NSUserDefaults.standardUserDefaults().setValue("\(attack)", forKey: "\(self.pokedexId)_attack")
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                    NSUserDefaults.standardUserDefaults().setValue("\(defense)", forKey: "\(self.pokedexId)_defense")
                }
                
                if let speed = dict["speed"] as? Int {
                    self._speed = "\(speed)"
                    NSUserDefaults.standardUserDefaults().setValue("\(speed)", forKey: "\(self.pokedexId)_speed")
                }
                
                if let exp = dict["exp"] as? Int {
                    self._exp = "\(exp)"
                    NSUserDefaults.standardUserDefaults().setValue("\(exp)", forKey: "\(self.pokedexId)_exp")
                }
                
                NSUserDefaults.standardUserDefaults().setValue(self.pokedexId, forKey: "\(self.pokedexId)")
                
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
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 && self.notErrorInAPI(self.pokedexId) {
                    if let pokemonName = evolutions[0]["to"] as? String {
                        if pokemonName.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let pokemonStr = uri.stringByReplacingOccurrencesOfString(URL_POKEMON, withString: "")
                                let id = pokemonStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionName = pokemonName
                                self._nextEvolutionId = id
                                
                                // Change Polywhirl evolution from Polytoed to Poliwrath (Old school style)
                                if pokemonName == "Politoed" {
                                    self._nextEvolutionName = "Poliwrath"
                                    self._nextEvolutionId = "62"
                                }
                                
                                NSUserDefaults.standardUserDefaults().setValue(self._nextEvolutionId, forKey: "\(self.pokedexId)_evolutionId")
                                NSUserDefaults.standardUserDefaults().setValue(self._nextEvolutionName, forKey: "\(self.pokedexId)_evolutionName")
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                    NSUserDefaults.standardUserDefaults().setValue(self._nextEvolutionLvl, forKey: "\(self.pokedexId)_evolutionLvl")
                                }
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
    
    // Errors in the API
    
    func notErrorInAPI(id: Int) -> Bool {
        if id == 24 || id == 34 || id == 38 || id == 112 || id == 121 {
            return false
        }
        return true
    }
}






