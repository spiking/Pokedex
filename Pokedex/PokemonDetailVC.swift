//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Adam Thuvesen on 2016-08-07.
//  Copyright © 2016 Adam Thuvesen. All rights reserved.
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
    private var _pokemon: Pokemon!
    
    var pokemon: Pokemon {
        get {
            return _pokemon
        }
        
        set {
            _pokemon = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        
        if isDataSet() {
            self.updateUI()
            self.setConstraint()
        } else {
            showDownloadIndicator()
            pokemon.downloadPokemonDetails { () -> () in
                self.updateUI()
                self.setConstraint()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        descriptionTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    func setConstraint() {
        if nextEvoImg.hidden {
            bottomConstraint.constant = 0
            contentViewHeight.constant = 516
        }
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
        } else {
            weightLbl.text = pokemon.weight + " kg"
        }
        
        if let height = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_height") as? String {
            heightLbl.text = height + " m"
        } else {
            heightLbl.text = pokemon.height + " m"
        }
        
        if let attack = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_attack") as? String {
            baseAttack.text = attack
        } else {
            baseAttack.text = pokemon.attack
        }
        
        if let defense = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_defense") as? String {
            defenseLbl.text = defense
        } else {
            defenseLbl.text = pokemon.defense
        }
        
        if let type = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_type") as? String {
            typeLbl.text = type
        } else {
            typeLbl.text = pokemon.type
        }
        
        if let speed = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_speed") as? String {
            speedLbl.text = speed
        } else {
            speedLbl.text = pokemon.speed
        }
        
        if let exp = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_exp") as? String {
            expLbl.text = exp
        } else {
            expLbl.text = pokemon.exp
        }
        
        if let description = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_description") as? String {
            descriptionTextView.text = description
        } else {
            descriptionTextView.text = pokemon.description
        }
        
        descriptionTextView.font = UIFont(name: "Avenir-Book", size: 15)
        descriptionTextView.textContainerInset = UIEdgeInsetsZero
        descriptionTextView.textContainer.lineFragmentPadding = 0;

        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        if let nextEvolutionId = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_evolutionId") as? String {
            if let nextEvolutionName = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_evolutionName") as? String {
                
                evoLbl.text = nextEvolutionId
                nextEvoImg.image = UIImage(named: nextEvolutionId)
                var nextEvo = "Next Evolution: \(nextEvolutionName)"
                
                if let nextEvolutionLvl = NSUserDefaults.standardUserDefaults().valueForKey("\(pokemon.pokedexId)_evolutionLvl") as? String {
                    nextEvo += " [Level \(nextEvolutionLvl)]"
                }
                
                evoLbl.text = nextEvo
            }
            
        } else {
            evoLbl.text = "Max Evolution"
            nextEvoImg.hidden = true
        }
        
        dismissDownloadIndicator()
    }
}
