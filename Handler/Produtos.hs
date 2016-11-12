{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handler.Produtos where

import Foundation
import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

formProduto :: Form Produtos
formProduto = renderDivs $ Produtos
    <$> areq textField "Nome do produto: "        Nothing
    <*> areq textField "Descrição do produto: "   Nothing
    <*> areq doubleField "Preço: "                Nothing

getProdutoR :: Handler Html
getProdutoR = do
            (widget, enctype) <- generateFormPost formProduto
            defaultLayout $ do
                setTitle "Administrator | Pixel Cakes"
                addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
                addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
                addStylesheet $ StaticR css_main_css
                addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
                addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                addScript $ StaticR js_main_js
                [whamlet|
                    <div class="container">
                        <img src=@{StaticR img_logo_png} alt="Logo Pixel Cakes" class="center-block" id="imglogin">
                        <nav class="navbar navbar-default" id="navbar-admin">
                            <div class="container-fluid">
                                <div class="navbar-header">
                                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                        <span class="sr-only">Navegação alternativa
                                        <span class="icon-bar">
                                        <span class="icon-bar">
                                        <span class="icon-bar">
        
                                <div id="navbar" class="navbar-collapse collapse">
                                    <ul class="nav navbar-nav">
                                        <li>
                                            <a href=@{PerfilR}>home
                                        <li class="dropdown">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                serviços <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{ServicoR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href=@{ListServR}>
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                        <li class="dropdown active">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                produtos <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{ProdutoR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href=@{ListProdR}>
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                        <li>
                                            <a href=@{ListContR}>contatos
                                        <li class="dropdown">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                usuários <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{UsuarioR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href="#">
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                    <ul class="nav navbar-nav navbar-right">
                                        <li>
                                            <form action=@{LogoutR} method=post>
                                                <input type="submit" value="sair" class="btn-sair">
                        <h2>Cadastrar produto</h2>
                        <form method=post action=@{ProdutoR} enctype=#{enctype}>
                            ^{widget}
                            <input type="submit" value="Cadastrar" class="btn btn-default">
         |]

postProdutoR :: Handler Html
postProdutoR = do
            ((result, _), _) <- runFormPost formProduto
            case result of
                FormSuccess produto -> do
                    alid <- runDB $ insert produto
                    defaultLayout $ do
                    setTitle "Administrator | Pixel Cakes"
                    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
                    addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
                    addStylesheet $ StaticR css_main_css
                    addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
                    addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                    addScript $ StaticR js_main_js
                    [whamlet|
                        <div class="container">
                            <img src=@{StaticR img_logo_png} alt="Logo Pixel Cakes" class="center-block" id="imglogin">
                            <nav class="navbar navbar-default" id="navbar-admin">
                                <div class="container-fluid">
                                    <div class="navbar-header">
                                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                            <span class="sr-only">Navegação alternativa
                                            <span class="icon-bar">
                                            <span class="icon-bar">
                                            <span class="icon-bar">
            
                                    <div id="navbar" class="navbar-collapse collapse">
                                        <ul class="nav navbar-nav">
                                            <li>
                                                <a href=@{PerfilR}>home
                                            <li class="dropdown">
                                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                    serviços <span class="caret">
                                                <ul class="dropdown-menu">
                                                    <li>
                                                        <a href=@{ServicoR}>
                                                            <span class="glyphicon glyphicon-plus"></span>
                                                            adicionar
                                                    
                                                    <li role="separator" class="divider"></li>
                                                    <li>
                                                        <a href=@{ListServR}>
                                                            <span class="glyphicon glyphicon-th-list"></span>
                                                            ver todos
                                            <li class="dropdown active">
                                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                    produtos <span class="caret">
                                                <ul class="dropdown-menu">
                                                    <li>
                                                        <a href=@{ProdutoR}>
                                                            <span class="glyphicon glyphicon-plus"></span>
                                                            adicionar
                                                    
                                                    <li role="separator" class="divider"></li>
                                                    <li>
                                                        <a href=@{ListProdR}>
                                                            <span class="glyphicon glyphicon-th-list"></span>
                                                            ver todos
                                            <li>
                                                <a href=@{ListContR}>contatos
                                            <li class="dropdown">
                                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                    usuários <span class="caret">
                                                <ul class="dropdown-menu">
                                                    <li>
                                                        <a href=@{UsuarioR}>
                                                            <span class="glyphicon glyphicon-plus"></span>
                                                            adicionar
                                                    
                                                    <li role="separator" class="divider"></li>
                                                    <li>
                                                        <a href="#">
                                                            <span class="glyphicon glyphicon-th-list"></span>
                                                            ver todos
                                        <ul class="nav navbar-nav navbar-right">
                                            <li>
                                                <form action=@{LogoutR} method=post>
                                                    <input type="submit" value="sair" class="btn-sair">
                                                    
                            <h2 class="alert alert-success text-center">Produto cadastrado com sucesso! 
                            <p class="text-uppercase text-center">Produto: #{fromSqlKey alid}
                    |]
                _ -> redirect HomeR

-- SELECT * FROM produto ORDER BY nome
getListProdR :: Handler Html
getListProdR = do
            produtos <- runDB $ selectList [] [Asc ProdutosNome]
            defaultLayout $ do
                setTitle "Administrator | Pixel Cakes"
                addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
                addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
                addStylesheet $ StaticR css_main_css
                addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
                addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                addScript $ StaticR js_main_js
                [whamlet|
                    <div class="container">
                        <img src=@{StaticR img_logo_png} alt="Logo Pixel Cakes" class="center-block" id="imglogin">
                        <nav class="navbar navbar-default" id="navbar-admin">
                            <div class="container-fluid">
                                <div class="navbar-header">
                                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                        <span class="sr-only">Navegação alternativa
                                        <span class="icon-bar">
                                        <span class="icon-bar">
                                        <span class="icon-bar">
        
                                <div id="navbar" class="navbar-collapse collapse">
                                    <ul class="nav navbar-nav">
                                        <li>
                                            <a href=@{PerfilR}>home
                                        <li class="dropdown">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                serviços <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{ServicoR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href=@{ListServR}>
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                        <li class="dropdown active">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                produtos <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{ProdutoR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href=@{ListProdR}>
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                        <li>
                                            <a href=@{ListContR}>contatos
                                        <li class="dropdown">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                usuários <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{UsuarioR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href="#">
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                    <ul class="nav navbar-nav navbar-right">
                                        <li>
                                            <form action=@{LogoutR} method=post>
                                                <input type="submit" value="sair" class="btn-sair">
                        <h2>Produtos cadastrados</h2>
                        <table class="table">
                            <thead>
                                <tr> 
                                    <th> id  
                                    <th> nome 
                                    <th> descricao
                                    <th> preco
                                    <th> excluir
                            $forall Entity alid produto <- produtos
                                <tr>
                                    <form action=@{DelProdutoR alid} method=post> 
                                        <td> #{fromSqlKey  alid}  
                                        <td> #{produtosNome  produto} 
                                        <td> #{produtosDescricao  produto} 
                                        <td> #{produtosPreco    produto}
                                        <td> <input type="submit" value="excluir">
                |]

postDelProdutoR :: ProdutosId -> Handler Html
postDelProdutoR alid = do
                runDB $ delete alid
                redirect ListProdR

footerzinho :: Widget
footerzinho = [whamlet|
                  <footer>
                      Footer
              |]