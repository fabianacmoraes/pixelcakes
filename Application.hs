{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeFamilies      #-}

module Application where

import Foundation
import Yesod
import Yesod.Static

import Handler.Servicos
import Handler.Produtos
import Handler.Usuario
import Handler.Contato
------------------
mkYesodDispatch "App" resourcesApp
        
getIndexR :: Handler Html
getIndexR = defaultLayout $ do
    setTitle "Pixel Cakes"
    toWidgetHead[hamlet|
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
    |]
    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
    addStylesheet $ StaticR css_main_css
    addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
    addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    addScript $ StaticR js_main_js
    --addStylesheet $ StaticR css_bootstrap_min_css
    $(whamletFile "templates/intro.hamlet")
    $(whamletFile "templates/nav.hamlet")
    $(whamletFile "templates/about.hamlet")
    $(whamletFile "templates/parallax.hamlet")
    $(whamletFile "templates/services.hamlet")
    $(whamletFile "templates/gallery.hamlet")
    $(whamletFile "templates/price.hamlet")
    $(whamletFile "templates/footer.hamlet")  
    
getProdutosR :: Handler Html
getProdutosR = do
    produtos <- runDB $ selectList [] [Asc ProdutosNome]
    defaultLayout $ do
    setTitle "Pixel Cakes"
    toWidgetHead[hamlet|
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
    |]
    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
    addStylesheet $ StaticR css_main_css
    addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
    addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    addScript $ StaticR js_main_js
    $(whamletFile "templates/nav2.hamlet")
    $(whamletFile "templates/products.hamlet")  
    $(whamletFile "templates/footer.hamlet")  

getServicosR :: Handler Html
getServicosR = do
    servicos <- runDB $ selectList [] [Asc ServicosNome]
    defaultLayout $ do
    setTitle "Pixel Cakes"
    toWidgetHead[hamlet|
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
    |]
    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
    addStylesheet $ StaticR css_main_css
    addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
    addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    addScript $ StaticR js_main_js
    $(whamletFile "templates/nav2.hamlet")
    $(whamletFile "templates/services2.hamlet")
    $(whamletFile "templates/footer.hamlet")  
    
getContatoR :: Handler Html
getContatoR = do
            (widget, enctype) <- generateFormPost formContato
            defaultLayout  $ do
                toWidgetHead [julius|
                    function enviado(){
                        alert("Enviado com sucesso.");
                    }
                |]
                setTitle "Pixel Cakes"
                addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
                addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
                addStylesheet $ StaticR css_main_css
                addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
                addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                addScript $ StaticR js_main_js
                
                $(whamletFile "templates/nav2.hamlet")
                   
                $(whamletFile "templates/contact.hamlet")               
                $(whamletFile "templates/footer.hamlet") 