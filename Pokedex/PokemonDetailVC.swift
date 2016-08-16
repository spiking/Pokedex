//
//  PokemonDetailVC.swift
//  pokedex-by-devslopes
//
//  Created by Mark Price on 8/15/15.
//  Copyright © 2015 devslopes. All rights reserved.
//

import UIKit
import MBProgressHUD

class PokemonDetailVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var evolutionView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttack: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var expLbl: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    private var hud = MBProgressHUD()
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        title = pokemon.name.capitalizedString
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if nextEvoImg.hidden {
            bottomConstraint.constant = 0
            contentViewHeight.constant = 516
        } else {
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        descriptionTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    func showDownloadIndicator() {
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.backgroundColor = UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1.0)
        hud.color = UIColor.clearColor()
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
                                if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_exp") != nil {
                                    if NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_speed") != nil {
                                        print("ALL DATA IS SET!")
                                        return true
                                    }
                                }
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
            weightLbl.text = weight + " kg"
            print("Loaded from db")
        } else {
            weightLbl.text = pokemon.weight + " kg"
        }
        
        if let height = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_height") as? String {
            heightLbl.text = height + " m"
            print("Loaded from db")
        } else {
            heightLbl.text = pokemon.height + " m"
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
        
        if let speed = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_speed") as? String {
            speedLbl.text = speed
            print("Loaded from db")
        } else {
            speedLbl.text = pokemon.speed
        }
        
        if let exp = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_exp") as? String {
            expLbl.text = exp
            print("Loaded from db")
        } else {
            expLbl.text = pokemon.exp
        }
        
        if let description = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_description") as? String {
            descriptionTextView.text = description
            print("Loaded from db")
        } else {
            descriptionTextView.text = pokemon.description
        }
        
        descriptionTextView.font = UIFont(name: "Avenir-Book", size: 15)

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
            nextEvoImg.hidden = true
//            nextEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        }
        
        dismissDownloadIndicator()
    }
}
