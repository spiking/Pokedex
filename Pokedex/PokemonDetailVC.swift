//
//  PokemonDetailVC.swift
//  pokedex-by-devslopes
//
//  Created by Mark Price on 8/15/15.
//  Copyright © 2015 devslopes. All rights reserved.
//

import UIKit
import MBProgressHUD

class PokemonDetailVC: UIViewController {
    
    //    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttack: UILabel!
    
    
    private var hud = MBProgressHUD()
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = pokemon.name.capitalizedString
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        
        
        
        if isDataSet() {
            self.updateUI()
        } else {
            
            showDownloadIndicator()
            
            pokemon.downloadPokemonDetails { () -> () in
                self.updateUI()
            }
        }
    }
    
    func showDownloadIndicator() {
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.backgroundColor = UIColor.whiteColor()
        hud.color = UIColor.lightGrayColor()
        hud.square = true
    }
    
    func dismissDownloadIndicator() {
        hud.hide(true)
    }
    
    func isDataSet() -> Bool {
        if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_weight") != nil {
            if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_height") != nil {
                if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_attack") != nil {
                    if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_defense") != nil {
                        if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_description") != nil {
                            if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_type") != nil {
                                print("ALL DATA IS SET!")
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        print("ALL DATA IS NOT SET!")
        return false
    }
    
    func updateUI() {
        
        if let weight = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_weight") as? String {
            weightLbl.text = weight
            print("Loaded from db")
        } else {
            weightLbl.text = pokemon.weight
        }
        
        if let height = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_height") as? String {
            heightLbl.text = height
            print("Loaded from db")
        } else {
            heightLbl.text = pokemon.height
        }
        
        if let attack = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_attack") as? String {
            baseAttack.text = attack
            print("Loaded from db")
        } else {
            baseAttack.text = pokemon.attack
        }
        
        if let defense = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_defense") as? String {
            defenseLbl.text = defense
            print("Loaded from db")
        } else {
            defenseLbl.text = pokemon.defense
        }
        
        if let type = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_type") as? String {
            typeLbl.text = type
            print("Loaded from db")
        } else {
            typeLbl.text = pokemon.type
        }
        
        
        if let description = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_description") as? String {
            descriptionTextView.text = description
            print("Loaded from db")
        } else {
            descriptionTextView.text = pokemon.description
        }
        
        descriptionTextView.font = UIFont(name: "Avenir-Medium", size: 15)
        
        
        //        typeLbl.text = pokemon.type
        //        defenseLbl.text = pokemon.defense
        //        heightLbl.text = pokemon.height
        //        weightLbl.text = pokemon.weight
        //        baseAttack.text = pokemon.attack
        
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        if let nextEvolutionId = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_evolutionId") as? String {
            if let nextEvolutionText = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_evolutionText") as? String {
                evoLbl.text = nextEvolutionId
                print("Loaded from db")
                
                nextEvoImg.image = UIImage(named: nextEvolutionId)
                var str = "Next Evolution: \(nextEvolutionText)"
                
                if let nextEvolutionLvl = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_evolutionLvl") as? String {
                    str += " [Level \(nextEvolutionLvl)]"
                    evoLbl.text = str
                }
            }
            
        } else {
            evoLbl.text = "Max Evolution"
            nextEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        }
        
        dismissDownloadIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
