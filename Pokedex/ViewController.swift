//
//  ViewController.swift
//  Pokedex
//
//  Created by Adam Thuvesen on 2016-08-07.
//  Copyright © 2016 Adam Thuvesen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    var musicButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Search
        searchBar.searchBarStyle = .Minimal
        searchBar.barTintColor = UIColor.clearColor()
        searchBar.backgroundImage = UIImage()
        searchBar.translucent = false
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1.0).CGColor
        
        title = "Pokedex"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        if let textFieldSearchBar = searchBar.valueForKey("searchField") as? UITextField,
            let searchIcon = textFieldSearchBar.leftView as? UIImageView {
            
            searchIcon.image = searchIcon.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            searchIcon.tintColor = UIColor.whiteColor()
        }
        
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = UIColor.whiteColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.whiteColor()
        
        setupInfoButton()
        setupMusicButton()
        parsePokemonCSV()
        initAudio()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    
    func setupMusicButton() {
        musicButton = UIButton(type: UIButtonType.Custom)
        musicButton.setImage(UIImage(named: "MusicLogo"), forState: UIControlState.Normal)
        musicButton.addTarget(self, action: #selector(ViewController.musicBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        musicButton.frame = CGRectMake(0, 0, 25, 25)
        let barButton = UIBarButtonItem(customView: musicButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func setupInfoButton() {
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(UIImage(named: "InfoLogo"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(ViewController.infoBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 25, 25)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    
    func hideKeyboardWithSearchBar(bar:UISearchBar) {
        bar.resignFirstResponder()
    }
    
    func infoBtnPressed() {
        performSegueWithIdentifier(SEGUE_INFO, sender: nil)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
        collection.reloadData()
    }
    
    func initAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        if let music = NSUserDefaults.standardUserDefaults().valueForKey("MUSIC") as? String {
            if music == "OFF" {
                musicPlayer.stop()
                musicButton.alpha = 0.2
            } else {
                musicPlayer.play()
                musicButton.alpha = 1.0
            }
        } else {
            musicPlayer.play()
            musicButton.alpha = 1.0
        }
    }
    
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier(SEGUE_DETAILVC, sender: poke)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let itemWidth = (CGRectGetWidth(collection!.frame) - 2 - (numberOfColumns - 1)) / numberOfColumns
        
        return CGSizeMake(itemWidth, itemWidth)
    }
    
    @IBAction func musicBtnPressed(sender: UIButton!) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
            NSUserDefaults.standardUserDefaults().setValue("OFF", forKey: "MUSIC")
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
            NSUserDefaults.standardUserDefaults().setValue("ON", forKey: "MUSIC")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count == 0 {
            performSelector(#selector(ViewController.hideKeyboardWithSearchBar(_:)), withObject:searchBar, afterDelay:0)
            inSearchMode = false
            collection.reloadData()
            return
        }
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_DETAILVC {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}


